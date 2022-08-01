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
    docker compose up
    ```
- Caso não deseje ver os logs use:
    ```bash
    docker compose up -d
    ```
    Atenção: O container ficará em execução em segundo plano dessa maneira.
### Executando testes

A aplicação só poderá ser testada se ela estiver em execução.

- Execute o seguinte comando num emulador de terminal:

    ```bash
    bash test
    ```

## Importando os dados do arquivo CSV de forma assíncrona 
Usando o comando abaixo um script será executado importando todos os dados do arquivo data.csv de forma assíncrona para o banco de dados.
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
        "limites tipo exame":"34-60",
        "resultado tipo exame":"94"
    }
]
```
### GET /diagnostics/:token
Ao relizar uma requisição válida, será possível efetuar uma consulta. Caso haja algum token conrespondente nos registros do banco de dados, uma busca será efetuada e terá como retorno os dados referentes a tal, como:
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
    "diagnósticos": 
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
Ao realizar uma requisição em **localhost:3000/insert**, será possível adicionar novos diagnósticos ao banco de dados por meio de um arquivo CSV válido. <br><br> O CSV será válido quando for análogo a:
```
cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
089.034.562-70;Patricia Gentil;herta_wehner@krajcik.name;1998-02-25;5334 Rodovia Thiago Bittencourt;Jequitibá;Paraná;B0000DHDOF;MT;Luiz Felipe Raia Jr.;marshall@brekke-funk.name;K7EG7Z;2021-10-23;t4-livre;34-60;45
050.039.641-88;João Macieira;jefferey.wehner@lockman.name;2000-10-04;452 Rua Raul Rodrigues;São João da Paraúna;Alagoas;B0000DHDOF;MT;Luiz Felipe Raia Jr.;marshall@brekke-funk.name;2I9EBC;2022-01-10;t4-livre;34-60;5
```