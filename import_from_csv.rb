require './csv_handler'

service = CsvHandler.new
service.drop_table
service.set_table
service.insert_data_into_database File.read('./data.csv')