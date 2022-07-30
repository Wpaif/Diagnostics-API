require 'pg'
require 'sidekiq'
require_relative '../csv_handler'

class ImportWorker
  include Sidekiq::Worker

  def perform(csv, db)
    handler = CsvHandler.new(db)
    handler.set_table
    handler.insert_data_into_database csv
  end
end
