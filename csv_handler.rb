require 'pg'
require 'csv'

class CsvHandler
  def initialize
    @database = ENV['APP_ENV'] == 'test' ? 'test-db' : 'db'
    @db = PG.connect dbname: 'hospital_data', host: @database, user: 'postgres', password: 'mypass'
  end

  def set_table
    @db.exec(
      '
        CREATE TABLE IF NOT EXISTS diagnostics (
          "cpf" VARCHAR(14),
          "nome paciente" VARCHAR(100),
          "email paciente" VARCHAR(100),
          "data nascimento paciente" DATE,
          "endereço/rua paciente" VARCHAR(100),
          "cidade paciente" VARCHAR(50),
          "estado patiente" VARCHAR(50),
          "crm médico" VARCHAR(10),
          "crm médico estado" VARCHAR(50),
          "nome médico" VARCHAR(100),
          "email médico" VARCHAR(100),
          "token resultado exame" VARCHAR(10),
          "data exame" DATE,
          "tipo exame" VARCHAR(50),
          "limites tipo exame" VARCHAR(10),
          "resultado tipo exame" INTEGER
        );
      '
    )
  end

  def insert_data_into_database(data)
    CSV.new(data, headers: true, col_sep: ';').each do |row|
      @db.exec_params(
        'INSERT INTO diagnostics VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)',
        row.fields
      )
    end
  end

  def drop_table
    @db.exec('DROP TABLE IF EXISTS diagnostics')
  end
end
