class SearchIdentities
  FIELD_OPERATION_MAPPINGS = {
    given_name_1: { table_field_name: 'identities.given_name_1', operation: 'LIKE' },
    given_name_2: { table_field_name: 'identities.given_name_2', operation: 'LIKE' },
    given_name_3: { table_field_name: 'identities.given_name_3', operation: 'LIKE' },
    surname: { table_field_name: 'identities.surname', operation: 'LIKE' },
    gender: { table_field_name: 'identities.gender', operation: '=' },
    noms_id: { table_field_name: 'offenders.noms_id', operation: '=' },
    ethnicity_code: { table_field_name: 'identities.ethnicity_code', operation: '=' },
    nationality_code: { table_field_name: 'offenders.nationality_code', operation: '=' },
    establishment_code: { table_field_name: 'offenders.establishment_code', operation: '=' },
    date_of_birth: { table_field_name: 'identities.date_of_birth', operation: '=' },
    date_of_birth_from: { table_field_name: 'identities.date_of_birth', operation: '>=' },
    date_of_birth_to: { table_field_name: 'identities.date_of_birth', operation: '<=' },
    pnc_number: { table_field_name: 'identities.pnc_number', operation: 'LIKE' },
    cro_number: { table_field_name: 'identities.cro_number', operation: 'LIKE' }
  }.freeze

  def initialize(params, relation = nil)
    @relation = begin
                  relation.joins(:offender)
                rescue
                  Identity.joins(:offender)
                end
    @params = params
    @given_name_surname = [params[:given_name_1], params[:surname]].compact.map(&:upcase)
  end

  def call
    FIELD_OPERATION_MAPPINGS.keys.each do |field|
      next unless @params[field]
      prepare_where_clause_default_variables(field)
      perform_advanced_name_search(field)
      add_condition_to_relation unless @skip_add_condition
    end
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
    check_exact_surname(field)
    check_name_switch(field)
    check_name_variation(field)
    check_soundex(field)
  end

  def check_exact_surname(field)
    return unless @params[:exact_surname] && field == :surname
    @operation = '='
    @value.upcase!
  end

  def check_name_switch(field)
    return unless @params[:name_switch] && %i(given_name_1 surname).include?(field)
    @operation = 'IN'
    @value = @given_name_surname
  end

  def check_name_variation(field)
    return unless @params[:name_variation] && field == :given_name_1
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

  def return_records_or_count
    if @params[:count]
      @relation.order('count_id DESC, identities.surname ASC').group(:surname).count.map do |k, v|
        { surname: k, count: v }
      end
    else
      @relation.order(:surname, :given_name_1, :given_name_2)
    end
  end
end
