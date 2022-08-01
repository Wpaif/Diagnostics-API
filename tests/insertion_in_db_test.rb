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

  def test_set_table
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    csv_columns = CSV.read("#{Dir.pwd}/tests_helper/csv/test_enter_one_register.csv", headers: true, col_sep: ';').headers

    CsvHandler.new('test-db').set_table
    db_columns = db.exec("SELECT column_name FROM information_schema.columns WHERE table_name = 'diagnostics'")
                   .values.flatten
    db.close

    db_columns.each { |column| assert_include csv_columns, column }
  end

  def test_set_table_that_already_exists
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    csv_columns = CSV.read("#{Dir.pwd}/tests_helper/csv/test_enter_one_register.csv", headers: true, col_sep: ';').headers
    handler = CsvHandler.new('test-db')
    handler.set_table

    handler.set_table
    db_columns = db.exec("SELECT column_name FROM information_schema.columns WHERE table_name = 'diagnostics'")
                   .values.flatten
    db.close

    db_columns.each { |column| assert_include csv_columns, column }
  end

  def test_enter_data_successfully
    expected_db_data = JSON.parse File.read("#{Dir.pwd}/tests_helper/json/test_one_db_data.json")
    handler = CsvHandler.new('test-db')
    handler.set_table

    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_enter_one_register.csv", headers: true, col_sep: ';') do |row|
      handler.insert_data_into_database row.fields
    end

    assert_equal expected_db_data, JSON.parse(QueriesHandler.set_tests_db)
  end

  def test_enter_data_multiple_times
    handler = CsvHandler.new('test-db')
    handler.set_table
    expected_db_data = JSON.parse File.read("#{Dir.pwd}/tests_helper/json/test_multiple_insertion_data.json")

    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_enter_one_register.csv", headers: true, col_sep: ';') do |row|
      handler.insert_data_into_database row.fields
    end
    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_enter_one_register_extra.csv", headers: true, col_sep: ';') do |row|
      handler.insert_data_into_database row.fields
    end

    assert_equal expected_db_data, JSON.parse(QueriesHandler.set_tests_db)
  end

  def test_try_to_enter_data_into_a_non_existent_table
    handler = CsvHandler.new('test-db')

    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_enter_one_register.csv", headers: true, col_sep: ';') do |row|
      assert_raise(PG::UndefinedTable) { handler.insert_data_into_database row.fields }
    end
  end

  def test_enter_data_invalid
    handler = CsvHandler.new('test-db')
    handler.set_table

    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_invalid_data.csv", headers: true, col_sep: ';') do |row|
      assert_raise(PG::ProtocolViolation) { handler.insert_data_into_database row.fields }
    end
  end

  def test_drop_table_successfully
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    handler = CsvHandler.new('test-db')
    handler.set_table

    handler.drop_table
    table_in_db = db.exec("SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'diagnostics')")
                    .getvalue(0, 0)
    db.close

    assert_equal 'f', table_in_db
  end
end
