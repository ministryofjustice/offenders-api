class SearchIdentities
  FIELD_OPERATION_MAPPINGS = {
    given_name: { table_field_name: 'identities.given_name', operation: 'ILIKE' },
    middle_names: { table_field_name: 'identities.middle_names', operation: 'ILIKE' },
    surname: { table_field_name: 'identities.surname', operation: 'ILIKE' },
    noms_id: { table_field_name: 'offenders.noms_id', operation: '=' },
    nationality_code: { table_field_name: 'offenders.nationality_code', operation: '=' },
    establishment_code: { table_field_name: 'offenders.establishment_code', operation: '=' },
    date_of_birth_from: { table_field_name: 'identities.date_of_birth', operation: '>=' },
    date_of_birth_to: { table_field_name: 'identities.date_of_birth', operation: '<=' }
  }.freeze

  def initialize(params, relation = nil)
    @relation = begin
                  relation.joins(:offender)
                rescue
                  Identity.joins(:offender)
                end
    @params = params
    @given_name_surname = [params[:given_name], params[:surname]].compact.map(&:upcase)
  end

  def call
    FIELD_OPERATION_MAPPINGS.keys.each do |field|
      next unless @params[field]
      prepare_where_clause_default_variables(field)
      perform_advanced_name_search(field)
      add_condition_to_relation unless @skip_add_condition
    end
    add_remaining_params_to_filter_on
    return_records_or_count
  end

  private

  def prepare_where_clause_default_variables(field)
    @table_field_name = FIELD_OPERATION_MAPPINGS[field][:table_field_name]
    @operation = FIELD_OPERATION_MAPPINGS[field][:operation]
    @value = @params.delete(field)
    @skip_add_condition = false
  end

  def perform_advanced_name_search(field)
    check_name_switch(field)
    check_exact_surname(field)
    check_name_variation(field)
    check_soundex(field)
  end

  def check_name_switch(field)
    return unless @params[:name_switch] && %i(given_name surname).include?(field)
    @operation = 'IN'
    @value = @given_name_surname
  end

  def check_exact_surname(field)
    return unless @params[:exact_surname] && field == :surname
    @operation = '='
    @value.upcase!
  end

  def check_name_variation(field)
    return unless @params[:name_variation] && field == :given_name
    @relation = @relation.nicknames(@value)
    @skip_add_condition = true
  end

  def check_soundex(field)
    return unless @params[:soundex] && field == :surname
    @relation = @relation.soundex(@value)
    @skip_add_condition = true
  end

  def add_condition_to_relation
    @relation = @relation.where("#{@table_field_name} #{@operation} (?)", @value)
  end

  def add_remaining_params_to_filter_on
    @relation = @relation.where(@params.slice(:gender, :date_of_birth, :pnc_number, :cro_number))
  end

  def return_records_or_count
    if @params[:count]
      @relation.order('count_id DESC, identities.surname ASC').group(:surname).count.map do |k, v|
        { surname: k, count: v }
      end
    else
      @relation.order(:surname, :given_name, :middle_names)
    end
  end
end
