# Rebase Challenge 2022

API em Ruby para listagem de exames médicos.

## Tech Stack
| Stack      | Versão      |
| -----------| ----------- |
| Docker     | 20.10.17    |
| Ruby       | latest      |

## Executando a aplicação localmente

- Execute o seguinte comando num emulador de terminal:

    ```bash
    docker compose up -d
    ```
- Caso deseje ver o log use:
    ```bash
    docker compose up
    ```
### Executando testes

Atenção: A aplicação só poderá ser testada se ela estiver em execução localmente.

- Execute o seguinte comando num emulador de terminal:

    ```bash
    bash test
    ```

## Importando os dados do arquivo CSV de forma assíncrona 
```bash
    bash import
```
## Endpoints

### GET /diagnostics
Ao realizar uma requisição em <localhost:3000/diagnostics>, será retornado todos os diagnósticos disponiveis no momento, como:
```json
[
    {
    "cpf":"048.973.170-88",
    "nome paciente":"Emilly Batista Neto",
    "email paciente":"gerald.crona@ebert-quigley.com",
    "data nascimento paciente":"2001-03-11",
    "endereço/rua paciente":"165 Rua Rafaela",
    "cidade paciente":"Ituverava",
    "estado patiente":"Alagoas",
    "crm médico":"B000BJ20J4",
    "crm médico estado":"PI",
    "nome médico":"Maria Luiza Pires",
    "email médico":"denna@wisozk.biz",
    "token resultado exame":"IQCZ17",
    "data exame":"2021-08-05",
    "tipo exame":"tgp",
    "limites tipo exame":"38-63",
    "resultado tipo exame":"9"
    },
    {
        "cpf":"048.973.170-88",
        "nome paciente":"Emilly Batista Neto",
        "email paciente":"gerald.crona@ebert-quigley.com",
        "data nascimento paciente":"2001-03-11",
        "endereço/rua paciente":"165 Rua Rafaela",
        "cidade paciente":"Ituverava",
        "estado patiente":"Alagoas",
        "crm médico":"B000BJ20J4",
        "crm médico estado":"PI",
        "nome médico":"Maria Luiza Pires",
        "email médico":"denna@wisozk.biz",
        "token resultado exame":"IQCZ17",
        "data exame":"2021-08-05",
        "tipo exame":"t4-livre",
        "limites t
        ipo exame":"34-60",
        "resultado tipo exame":"94"
    }
]
```
### GET /diagnostics/:token
Ao relizar um requisição que segue esse molde, será possível efetuar uma consulta no banco de dados. Caso haja algum token conrespondente nos registros do banco de dados, uma busca será efetuada e terá como retorno os dados referentes a tal pessoa, como:
```json
{
    "cpf":"048.108.026-04",
    "nome paciente":"Juliana dos Reis Filho",
    "email paciente":"mariana_crist@kutch-torp.com",
    "data nascimento paciente":"1995-07-03",
    "token resultado exame":"0W9I67",
    "data exame":"2021-07-09",
    "médico": {
            "crm médico":"B0002IQM66",
            "crm médico estado":"SC",
            "nome médico":"Maria Helena Ramalho"
    },
    "diagnóstico": 
        [
            {
                "tipo exame":"hdl",
                "limites tipo exame":"19-75",
                "resultado tipo exame":"74"
            },
            {
                "tipo exame":"leucócitos",
                "limites tipo exame":"9-61",
                "resultado tipo exame":"91"
            }
        ]
}
```
### POST /insert
Ao realizar uma requisição em **localhost:3000/insert**, será possível adicionar novos diagnósticos ao banco de dados por meio de um arquivo CSV válido.

