require 'sinatra'
require 'rack/handler/puma'
require_relative 'queries_handler'
require_relative 'sidekiq/import_worker'

get '/diagnostics' do
  content = QueriesHandler.set_tests_db
  if content
    content_type :json
    return content
  end

  content_type :text
  'Não há diagnósticos registrados.'
end

get '/diagnostics/:token' do
  content = QueriesHandler.get_diagnostic_token(params[:token])
  if content
    content_type :json
    return content
  end

  content_type :text
  [404, 'Diagnóstico não encontrado.']
end

post '/insert' do
  csv = CSV.parse(request.body.read, headers: true, col_sep: ';')
  return [422, 'Os dados pasados estão no formato inválido.'] unless csv.headers.count.eql?(16)

  csv.each do |row|
    ImportWorker.perform_async(row.fields, ENV['DB'])
  end
  [201, 'Os dados foram inseridos com sucesso.']
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
