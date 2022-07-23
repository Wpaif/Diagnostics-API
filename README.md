# Rebase Challenge 2022

API em Ruby para listagem de exames médicos.

## Tech Stack

* Docker
* Ruby

## Executando o projeto

1. Execute o seguinte comando no emulador de terminal:

    ```bash
    docker compose up
    ```
2. Visite <http://localhost:3000/diagnostics>.

### Executando testes

1. Execute o seguinte comando no emulador de terminal:

    ```bash
    docker compose -f docker-compose.yml -f docker-compose.test.yml up
    ```
2. Execute o seguinte comando em outra janela do emulador de terminal:

    ```bash
    docker exec -it rebase-challengefinal-app-1 ruby include_tests.rb
    ```
