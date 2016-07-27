class ImportPrisoners
  attr_reader :params, :success, :errors

  def initialize(params)
    @params = params
    @success = false
    @errors = []
  end

  def call
    @import = Import.new(params)

    if @import.save
      remove_previous_imports

      begin
        process_import_file
        @success = true
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
    @success
  end

  def errors
    @errors
  end

  private

  def remove_previous_imports
    Import.where('id != ?', @import.id).destroy_all
  end

  def process_import_file
    # TODO
  end
end
