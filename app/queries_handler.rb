require 'pg'

class QueriesHandler
  def self.set_diagnostics_db
    db = PG.connect dbname: 'hospital_data', host: ENV['DB'], user: 'postgres', password: 'mypass'
    result = db.exec('SELECT * FROM diagnostics')
    db.close
    result.map { |row| row }.to_json
  rescue PG::UndefinedTable
    false
  end

  def self.get_diagnostic_token(token)
    db = PG.connect dbname: 'hospital_data', host: ENV['DB'], user: 'postgres', password: 'mypass'
    query = %(SELECT * FROM diagnostics WHERE "token resultado exame" = '#{token}')
    result = db.exec(query)
    db.close
    return false if result.cmd_tuples.zero?
    
    patient_columns = ['token resultado exame', 'data exame', 'cpf', 'nome paciente', 'email paciente', 
                       'data nascimento paciente']
    physician_columns = ['crm médico', 'crm médico estado', 'nome médico']
    exam_columns = ['tipo exame', 'limites tipo exame', 'resultado tipo exame']
    first_row = result.first
    data = first_row.select { |key, _value| patient_columns.include?(key) }
    data['médico'] = first_row.select { |key, _value| physician_columns.include?(key) }
    data['diagnósticos'] = result.map { |row| row.select { |key, _value| exam_columns.include?(key) } }
    data.to_json
  end
end
