require 'test/unit'
require './csv_handler'
require './queries_handler'
require 'pg'

class TestQueries < Test::Unit::TestCase
  def teardown
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    db.exec('DROP TABLE IF EXISTS diagnostics')
    db.close
  end

  def test_try_get_tests_successfully
    service = CsvHandler.new
    service.set_table
    service.insert_data_into_database File.read('./tests/tests_helper/test_data.csv')
    expected_result = JSON.parse(File.read('./tests/tests_helper/test_db_data.json'))
    result = QueriesHandler.new.set_tests_db

    assert_equal expected_result, JSON.parse(result)
  end

  def test_try_get_tests_in_empty_db
    result = QueriesHandler.new.set_tests_db

    assert_equal false, result
  end
end
