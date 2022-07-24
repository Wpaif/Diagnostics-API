require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'
require './csv_handler'

get '/diagnostics' do
  content_type :json

  database = ENV['APP_ENV'].eql?('test') ? 'test-db' : 'db'
  db = PG.connect dbname: 'hospital_data', host: database, user: 'postgres', password: 'mypass'

  result = db.exec('SELECT * FROM "diagnostics"')
  result.map { |row| row }.to_json
end

post '/insert' do
  database = ENV['APP_ENV'].eql?('test') ? 'test-db' : 'db'
  db = PG.connect dbname: 'hospital_data', host: database, user: 'postgres', password: 'mypass'

  csv = CSV.new(request.body.read, headers: true, col_sep: ';')
  csv.each do |row|
    db.exec_params(
      'INSERT INTO diagnostics VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)',
      row.fields
    )
  end
  [201, 'Dados foram enseridos com sucesso!']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
