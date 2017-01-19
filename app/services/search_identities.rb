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

  FIELDS = FIELD_OPERATION_MAPPINGS.keys

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
    FIELDS.each do |field|
      next unless @params[field]
      @table_field_name = FIELD_OPERATION_MAPPINGS[field][:table_field_name]
      @operation = FIELD_OPERATION_MAPPINGS[field][:operation]
      @value = @params.delete(field)

      check_name_switch_and_name_variation(field)
      add_condition_to_relation
    end

    @relation = @relation.where(@params.except(:count, :name_switch, :name_variation))

    return_records_or_count
  end

  private

  def check_name_switch_and_name_variation(field)
    if @params[:name_switch] && %i(given_name surname).include?(field)
      @operation = 'IN'
      @value = @given_name_surname
    elsif @params[:name_variation] && field == :given_name
      @operation = 'IN'
      @value = Nickname.for(@value.upcase).map(&:name)
    end
  end

  def add_condition_to_relation
    @relation = @relation.where("#{@table_field_name} #{@operation} (?)", @value)
  end

  def return_records_or_count
    if @params[:count]
      @relation.order('count_all DESC, surname ASC').group(:surname).count.map do |k, v|
        { surname: k, count: v }
      end
    else
      @relation.order(:surname, :given_name, :middle_names)
    end
  end
end
