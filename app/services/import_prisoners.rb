class ImportPrisoners
  attr_reader :params, :errors

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
    @errors = []
  end

  def call
    @import = Import.new(params)

    if @import.save
      remove_previous_imports

      begin
        process_import_file
        @import.update_attribute(:successful, true)
      rescue
        @errors << 'Could not complete import'
      end
    end

    self
  end

  def import
    @import
  end

  def success?
    @import.successful? rescue false
  end

  def errors
    @errors
  end

  private

  def remove_previous_imports
    Import.where('id != ?', @import.id).destroy_all
  end

  def process_import_file
    require 'csv'
    csv_text = params[:file].read
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      if csv.headers.include?('Offender Surname')
        Prisoner.create! prisoner_attributes_from(row)
      elsif csv.headers.include?('Alias Surname')
        prisoner = Prisoner.where(noms_id: row['NOMS Number']).first
        prisoner.aliases.create!(alias_attributes_from(row)) if prisoner
      end
    end
  end

  def prisoner_attributes_from(row)
    {
      noms_id: row['NOMS Number'],
      given_name: row['Offender Given Name 1'],
      middle_names: row['Offender Given Name 2'],
      surname: row['Offender Surname'],
      title: row['Salutation'],
      date_of_birth: Date.parse(row['Date of Birth']),
      gender: row['Gender Code'],
      pnc_number: row['PNC ID'],
      nationality_code: row['Nationality Code'],
      ethnicity_code: row['Ethnic Code'],
      sexual_orientation_code: row['Sexual Orientation Code'],
      cro_number: row['Criminal Records Office number']
    }
  end

  def alias_attributes_from(row)
    {
      given_name: row['Alias Given Name 1'],
      middle_names: row['Alias Given Name 2'],
      surname: row['Alias Surname'],
      gender: row['Alias Gender'],
      date_of_birth: Date.parse(row['Alias Date of Birth'])
    }
  end
end
