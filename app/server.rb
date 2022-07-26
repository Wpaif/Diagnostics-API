require 'sinatra'
require 'rack/handler/puma'
require_relative 'csv_handler'
require_relative 'queries_handler'

get '/diagnostics' do
  content = QueriesHandler.set_tests_db
  if content
    content_type :json
    return content
  end

  content_type :text
  'Não há diagnósticos registrados.'
end

post '/insert' do
  service = CsvHandler.new
  service.set_table
  service.insert_data_into_database request.body.read
  [201, 'Os dados foram inseridos com sucesso.']
rescue PG::ProtocolViolation
  [422, 'Os dados pasados estão em formato inválido.']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
