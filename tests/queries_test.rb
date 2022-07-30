require 'pg'
require 'test/unit'
require_relative '../app/csv_handler'
require_relative '../app/queries_handler'

class TestQueries < Test::Unit::TestCase
  def teardown
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    db.exec('DROP TABLE IF EXISTS diagnostics')
    db.close
  end

  def test_try_get_tests_successfully
    service = CsvHandler.new('test-db')
    service.set_table
    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_query_data.csv", headers: true, col_sep: ';') do |row|
      service.insert_data_into_database row.fields
    end
    expected_result = JSON.parse File.read("#{Dir.pwd}/tests_helper/json/test_query_db_data.json")

    result = QueriesHandler.set_tests_db

    assert_equal expected_result, JSON.parse(result)
  end

  def test_try_get_tests_in_empty_db
    result = QueriesHandler.set_tests_db

    assert_equal false, result
  end

  def test_get_tests_token_success
    service = CsvHandler.new('test-db')
    service.set_table
    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_token_data.csv", headers: true, col_sep: ';') do |row|
      service.insert_data_into_database row.fields
    end
    expected_result = JSON.parse File.read("#{Dir.pwd}/tests_helper/json/test_search_db_data.json")

    result = QueriesHandler.get_tests_token('AIWH8Y')

    assert_equal expected_result, JSON.parse(result)
  end

  def test_token_not_found
    service = CsvHandler.new('test-db')
    service.set_table
    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_token_data.csv", headers: true, col_sep: ';') do |row|
      service.insert_data_into_database row.fields
    end

    result = QueriesHandler.get_tests_token('ASDFGH')

    assert_equal false, result
  end
end
