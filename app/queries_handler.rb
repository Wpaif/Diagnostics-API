require 'pg'

class QueriesHandler
  def self.set_tests_db
    db = PG.connect dbname: 'hospital_data', host: ENV['DB'], user: 'postgres', password: 'mypass'
    result = db.exec('SELECT * FROM diagnostics')
    result.map { |row| row }.to_json
  rescue PG::UndefinedTable
    false
  end
end