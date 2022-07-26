require 'pg'
require 'test/unit'
require 'net/http'
require_relative '../app/csv_handler'
require_relative '../app/queries_handler'

class TestServerUp < Test::Unit::TestCase
  def teardown
    db = PG.connect dbname: 'hospital_data', host: 'test-db', user: 'postgres', password: 'mypass'
    db.exec('DROP TABLE IF EXISTS diagnostics')
    db.close
  end

  def test_get_tests_successfully
    service = CsvHandler.new
    service.set_table
    service.insert_data_into_database File.read("#{Dir.pwd}/tests_helper/test_data.csv")
    expected_response_body = JSON.parse File.read("#{Dir.pwd}/tests_helper/test_db_data.json")

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

  def test_post_data_successfully
    address = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/insert', 'Content-Type': 'text/csv')
    request.body = File.read("#{Dir.pwd}/tests_helper/test_data.csv")
    expected_db_data = JSON.parse File.read("#{Dir.pwd}/tests_helper/test_db_data.json")

    response = address.request(request)

    assert_equal response.code, '201'
    assert_equal 'Os dados foram inseridos com sucesso.'.force_encoding('ascii-8bit'), response.body
    assert_equal expected_db_data, JSON.parse(QueriesHandler.set_tests_db)
  end

  def test_post_insert_multiple_times
    address = Net::HTTP.new('localhost', 3000)
    first_request = Net::HTTP::Post.new('/insert', 'Content-Type': 'text/csv')
    first_request.body = File.read("#{Dir.pwd}/tests_helper/test_multiple_insert_data1.csv")
    second_request = Net::HTTP::Post.new('/insert', 'Content-Type': 'text/csv')
    second_request.body = File.read("#{Dir.pwd}/tests_helper/test_multiple_insert_data2.csv")
    expected_db_data = JSON.parse(File.read("#{Dir.pwd}/tests_helper/test_multiple_insert_db_data.json"))

    address.request(first_request)
    address.request(second_request)

    assert_equal expected_db_data, JSON.parse(QueriesHandler.set_tests_db)
  end

  def test_post_import_invalid_data
    address = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/insert', 'Content-Type': 'text/csv')
    request.body = File.read("#{Dir.pwd}/tests_helper/test_invalid_data.csv")

    response = address.request(request)

    assert_equal '422', response.code
    assert_equal 'Os dados pasados estão em formato inválido.'.force_encoding('ascii-8bit'), response.body
  end
end
