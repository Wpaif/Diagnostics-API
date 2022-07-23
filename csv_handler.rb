require 'pg'
require 'csv'

class CsvHandler
  def initialize(file_path)
    @file_path = file_path
    @db = ENV['APP_ENV'].eql?('test') ? 'test-db' : 'db'
  end

  def import_csv
    db = PG.connect dbname: 'hospital_data', host: @db, user: 'postgres', password: 'mypass'
    set_table(db)
    insert_data_into_database(db)
    db.close
  end

  private

  def set_table(db)
    db.exec(
      '
        DROP TABLE IF EXISTS diagnostics;

        CREATE TABLE diagnostics (
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

  def insert_data_into_database(db)
    CSV.foreach(@file_path, headers: true, col_sep: ';') do |row|
      db.exec_params(
        'INSERT INTO diagnostics VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)',
        row.fields
      )
    end
  end
end
