require 'pg'
require 'sidekiq'
require_relative '../csv_handler'

class ImportWorker
  include Sidekiq::Worker

  def perform(csv, db)
    service = CsvHandler.new(db)
    service.create_table
    service.insert(csv)
  end
end
