require 'test/unit'
require 'net/http'
require './csv_handler'

return unless ENV['APP_ENV'].eql? 'test'

class TestServerUp < Test::Unit::TestCase
  def test_sever_up
    CsvHandler.new('./tests/tests_helper/test_data.csv').import_csv
    expected_response = JSON.parse(File.read('./tests/tests_helper/test_response.json'))

    response = Net::HTTP.get_response 'localhost', '/diagnostics', 3000

    assert_equal response.code, '200'
    assert_equal response['Content-Type'], 'application/json'
    assert_equal JSON.parse(response.body), expected_response
  end
end
