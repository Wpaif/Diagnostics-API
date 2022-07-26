# Rebase Challenge 2022

API em Ruby para listagem de exames médicos.

## Tech Stack
| Stack      | Versão      |
| -----------| ----------- |
| Docker     | 20.10.17    |
| Ruby       | latest      |

## Executando a aplicação localmente

- Execute o seguinte comando no emulador de terminal:

    ```bash
    docker compose up -d
    ```
- Caso deseje ver o log use:
    ```bash
    docker compose up
    ```
### Executando testes

Atenção: A aplicação só poderá ser testada se ela estiver em execução localmente.

- Execute o seguinte comando no emulador de terminal:

    ```bash
    bash test
    ```
## Endpoints

### GET /diagnostics
Ao realizar uma requisição em <localhost:3000/diagnostics>, será retornado todos os diagnósticos disponiveis no momento.

### POST /insert
Ao realizar uma requisição em <localhost:3000/insert>, será possível adicionar novos diagnósticos ao banco de dados.
1. Headers: Content_Type: text/csv
2. Body: texto no formato CSV 

| Headers                    | Body                    |
| ----------------------     | ---------------------   |
| Content_Type: text/csv     | Texto no formato SCV    |

