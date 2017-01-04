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
      value = @params.delete(field)
      table_field_name = FIELD_OPERATION_MAPPINGS[field][:table_field_name]
      operation = FIELD_OPERATION_MAPPINGS[field][:operation]
      @relation = if @params[:name_switch] && %i(given_name surname).include?(field)
                    @relation.where(field => @given_name_surname)
                  else
                    @relation.where("#{table_field_name} #{operation} ?", value)
                  end
    end

    @relation.where(@params.except(:name_switch)).order(:surname, :given_name, :middle_names)
  end
end
