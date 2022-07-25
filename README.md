# Rebase Challenge 2022

API em Ruby para listagem de exames médicos.

## Tech Stack

* Docker
* Ruby

## Executando o projeto

- Execute o seguinte comando no emulador de terminal:

    ```bash
    docker compose up
    ```
### Executando testes

1. Execute o seguinte comando no emulador de terminal:

    ```bash
    docker compose -f docker-compose.yml -f docker-compose.test.yml up
    ```
2. Execute o seguinte comando em outra janela do emulador de terminal:

    ```bash
    docker exec -it rebase-challengefinal-app-1 ruby include_tests.rb
    ```

## Endpoints

### GET /diagnostics
Ao realizar uma requisição em <localhost:3000/diagnostics>, será retornado todos os diagnósticos disponiveis no momento.

### POST /insert
Ao realizar uma requisição em <localhost:3000/insert>, será possível adicionar novos diagnósticos ao banco de dados.
- Headers: Content_Type: text/csv
- Body: texto no formato CSV 
