require 'test/unit'
require './csv_handler'

return unless ENV['APP_ENV'].eql? 'test'

class TestImportCsv < Test::Unit::TestCase
  def test_import
    csv = CSV.read('./tests/tests_helper/test_data.csv', headers: true, col_sep: ';')
    csv_column = csv.headers
    csv_data = csv.map(&:fields)
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'

    CsvHandler.new('./tests/tests_helper/test_data.csv').import_csv
    db_data = db.exec('SELECT * FROM diagnostics').values
    db_colunm = db.exec("SELECT column_name FROM information_schema.columns WHERE table_name = 'diagnostics'")
                  .values.flatten

    assert_equal db_data, csv_data
    db_colunm.each { |column| assert_include csv_column, column }
  end
end
