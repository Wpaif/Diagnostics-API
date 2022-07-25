require 'pg'

class QueriesHandler
  def initialize
    @database = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
  end

  def set_tests_db
    db = PG.connect dbname: 'hospital_data', host: @database, user: 'postgres', password: 'mypass'
    result = db.exec('SELECT * FROM diagnostics')
    result.map { |row| row }.to_json
  rescue PG::UndefinedTable
    false
  end
end
