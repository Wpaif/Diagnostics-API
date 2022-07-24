require 'test/unit'
require 'net/http'

class TestPost < Test::Unit::TestCase
  def test_post_import
    csv = File.read('./tests/tests_helper/test_post_data.csv')
    address = Net::HTTP.new('localhost', 3000)
    request = Net::HTTP::Post.new('/insert', 'Content-Type': 'text/csv')
    request.body = csv

    response = address.request(request)

    assert_equal response.code, '201'
  end
end
