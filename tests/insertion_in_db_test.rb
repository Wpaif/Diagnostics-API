require 'pg'
require 'test/unit'
require_relative '../app/csv_handler'
require_relative '../app/queries_handler'

class TestInsert < Test::Unit::TestCase
  def teardown
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    db.exec('DROP TABLE IF EXISTS diagnostics')
    db.close
  end

  def test_create_table
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    csv_columns = CSV.read("#{Dir.pwd}/tests_helper/test_data.csv", headers: true, col_sep: ';').headers

    CsvHandler.new.set_table
    db_columns = db.exec("SELECT column_name FROM information_schema.columns WHERE table_name = 'diagnostics'")
                   .values.flatten
    db.close

    db_columns.each { |column| assert_include csv_columns, column }
  end

  def test_create_table_that_already_exists
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    csv_columns = CSV.read("#{Dir.pwd}/tests_helper/test_data.csv", headers: true, col_sep: ';').headers
    service = CsvHandler.new
    service.set_table

    db_columns = db.exec("SELECT column_name FROM information_schema.columns WHERE table_name = 'diagnostics'")
                   .values.flatten

    db_columns.each { |column| assert_include csv_columns, column }
  end

  def test_drop_table_successfully
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    service = CsvHandler.new
    service.set_table

    service.drop_table
    table_in_db = db.exec("SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'diagnostics')")
                    .getvalue(0, 0)
    db.close

    assert_equal 'f', table_in_db
  end

  def test_enter_data_successfully
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/tests_helper/test_db_data.json"))
    service = CsvHandler.new
    service.set_table

    service.insert_data_into_database File.read("#{Dir.pwd}/tests_helper/test_data.csv")

    assert_equal expected_db_data, JSON.parse(QueriesHandler.set_tests_db)
  end

  def test_enter_data_multiple_times
    service = CsvHandler.new
    service.set_table
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/tests_helper/test_multiple_insert_db_data.json"))

    service.insert_data_into_database File.read("#{Dir.pwd}/tests_helper/test_multiple_insert_data1.csv")
    service.insert_data_into_database File.read("#{Dir.pwd}/tests_helper/test_multiple_insert_data2.csv")

    assert_equal expected_db_data, JSON.parse(QueriesHandler.set_tests_db)
  end

  def test_try_to_enter_data_into_a_non_existent_table
    service = CsvHandler.new
    service.set_table

    assert_raise(PG::ProtocolViolation) do
      service.insert_data_into_database File.read("#{Dir.pwd}/tests_helper/test_invalid_data.csv")
    end
  end

  def test_enter_data_invalid
    service = CsvHandler.new
    service.set_table

    assert_raise(PG::ProtocolViolation) do
      service.insert_data_into_database File.read("#{Dir.pwd}/tests_helper/test_invalid_data.csv")
    end
  end
end
