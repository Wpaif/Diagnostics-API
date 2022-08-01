require 'pg'
require 'net/http'
require 'test/unit'
require 'sidekiq/testing'
require_relative '../app/csv_handler'
require_relative '../app/queries_handler'

class TestServerUp < Test::Unit::TestCase
  def teardown
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    db.exec('DROP TABLE IF EXISTS diagnostics')
    db.close
  end

  def test_get_tests_successfully
    handler = CsvHandler.new('test-db')
    handler.set_table
    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_query_data.csv", headers: true, col_sep: ';') do |row|
      handler.insert_data_into_database row.fields
    end
    expected_response_body = JSON.parse File.read("#{Dir.pwd}/tests_helper/json/test_query_db_data.json")

    response = Net::HTTP.get_response 'localhost', '/diagnostics', 3000

    assert_equal response.code, '200'
    assert_equal 'application/json', response['Content-Type']
    assert_equal expected_response_body, JSON.parse(response.body)
  end

  def test_get_tests_in_empty_db
    response = Net::HTTP.get_response 'localhost', '/diagnostics', 3000

    assert_equal response.code, '200'
    assert_equal 'text/plain;charset=utf-8', response['Content-Type']
    assert_equal 'Não há diagnósticos registrados.'.force_encoding('ascii-8bit'), response.body
  end

  def test_post_import_invalid_data
    address = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/insert', 'Content-Type': 'text/csv')
    request.body = File.read("#{Dir.pwd}/tests_helper/csv/test_invalid_data.csv")

    response = address.request(request)

    assert_equal response.code, '422'
    assert_equal 'Os dados pasados estão no formato inválido.'.force_encoding('ascii-8bit'), response.body
  end

  def token_found_successfully
    handler = CsvHandler.new('test-db')
    handler.set_table
    CSV.foreach("#{Dir.pwd}/tests_helper/test_token_data.csv", headers: true, col_sep: ';') do |row|
      handler.insert_data_into_database row.fields
    end
    expected_response_body = JSON.parse(File.read("#{Dir.pwd}/tests_helper/json/test_token_db_data.json"))

    response = Net::HTTP.get_response 'localhost', '/diagnostics/AIWH8Y', 3000

    assert_equal response.code, '200'
    assert_equal 'application/json', response['Content-Type']
    assert_equal expected_response_body, JSON.parse(response.body)
  end

  def token_not_found
    handler = CsvHandler.new('test-db')
    handler.set_table
    CSV.foreach("#{Dir.pwd}/tests_helper/csv/test_token_data.csv", headers: true, col_sep: ';') do |row|
      handler.insert_data_into_database row.fields
    end
    expected_response_body = JSON.parse(File.read("#{Dir.pwd}/tests_helper/json/test_token_db_data.json"))

    response = Net::HTTP.get_response 'localhost', '/diagnostics/ABCDEF', 3000

    assert_equal response.code, '404'
    assert_equal 'text/plain;charset=utf-8', response['Content-Type']
    assert_equal 'Diagnóstico não encontrado.'.force_encoding('ascii-8bit'), response.body
  end
end
