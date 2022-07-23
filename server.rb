require 'sinatra'
require 'pg'
require 'rack/handler/puma'

get '/diagnostics' do
  content_type :json

  database = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
  db = PG.connect dbname: 'hospital_data', host: database, user: 'postgres', password: 'mypass'

  result = db.exec('SELECT * FROM "diagnostics"')
  result.map { |tuple| tuple }.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)