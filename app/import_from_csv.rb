require_relative 'sidekiq/import_worker'

CSV.foreach("#{Dir.pwd}/data.csv", headers: true, col_sep: ';') do |register|
  ImportWorker.perform_async(register.fields, 'db')
end
