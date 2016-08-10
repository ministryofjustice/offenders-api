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
        ParseCsv.call(params[:file].read)
        @import.update_attribute(:successful, true)
      rescue ParseCsv::ParsingError => e
        @errors << e.to
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
end
