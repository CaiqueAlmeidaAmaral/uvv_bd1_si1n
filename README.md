# Projeto de PSET SI1N-UVV

* **Aluno:** Caíque Almeida Amaral
* **Matrícula:** 202305874
* **Professor:** Abrantes Araujo Silva Filho
* **Turma:** SI1N
* **Monitor(a):** Suellen Miranda Amorim

> Essa atividade avaliativa foi realizado para a matéria de Design e Desenvolvimento de Banco de Dados 1 na Universidade de Vila Velha.

## Estrutura dos Diretórios
- **[pset1](https://github.com/caiquealmr/uvv_bd1_si1n/tree/main/pset1)**
  - **[si1n_202305874_postgresql.architect](https://github.com/caiquealmr/uvv_bd1_si1n/blob/main/pset1/si1n_202305874_postgresql.architect)**
  - **[si1n_202305874_postgresql.pdf](https://github.com/caiquealmr/uvv_bd1_si1n/blob/main/pset1/si1n_202305874_postgresql.pdf)**
  - **[si1n_202305874_postgresql.sql]()**
- **[README.md](https://github.com/caiquealmr/uvv_bd1_si1n/blob/main/README.md)**

## O PSET
Um Problem Set (PSET) é um conjunto de problemas e tarefas difíceis que o forçam a estudar e realmente compreender a matéria.

Esse projeto consiste em um PSET com objetivo de implementar um banco de dados no PostgreSQL, a partir de um diagrama relacional, e escrever códigos SQL para gerar diversos relatórios.


## Softwares utilizados 

| Software            | Objetivo                     |
|---------------------|------------------------------|
| SQL Power Architect | Criar o Projeto Lógico       |
| Emacs               | Criar o Script.sql           |
| PostgreSQl          | Implementar o banco de dados |
| Linha de Comando    | Desenvolver o projeto        |


## Diagrama Relacional
A partir do **SQL Power Architect** criei todas as tabelas e seus atributos incluindo comentários, criando chaves primárias, cardinalidades, relacionamentos, chaves estrangeiras e chaves compostas. Os arquivos gerados foram:

- Código para rodar o diagrama dentro do Software
  - **[arquivo.architect](https://github.com/caiquealmr/uvv_bd1_si1n/blob/main/pset1/si1n_202305874_postgresql.architect)** 
- Arquivo PDF com uma representação visual do diagrama
  - **[arquivo.pdf](https://github.com/caiquealmr/uvv_bd1_si1n/blob/main/pset1/si1n_202305874_postgresql.pdf)** 

## Implementação do banco de dados no PostgreSQL
A implementação do banco de dados foi feita no **PostgreSQL**, o sistema de gerenciamento de bancos de dados open source mais avançado que existe atualmente. Todo o passo a passo está descrito no **[script.sql]()**, o qual está comentado e organizado de forma que qualquer leitor possa compreender cada comando usado.

* Caso queira testa-lo em seu terminal Linux é necessário usar o seguinte comando:

```
psql -U postgres < si1n_202305874_postgresql.sql 
```

## Comandos utilizados

| Sintaxe             | Função                     |
|---------------------|----------------------------|
| DROP DATABASE       | Apagar Banco de Dados      |
| DROP USER           | Apagar Usuário             |
| CREATE DATABASE     | Criar Banco de Dados       |
| CREATE USER         | Criar Usuário              |
| SET ROLE            | Define o Usuário Corrente  |
| SET SEARCH_PATH     | Alterar o Esquema Padrão   |
| CREATE TABLE        | Criar Tabela               |
| CREATE SCHEMA       | Criar Esquema Lógico       |
| ALTER TABLE         | Alterar tabela             |
| ADD CONSTRAINT      | Adicionar Restrição        |
| COMMENT ON DATABASE | Comentar Banco de Dados    |
| COMMENT ON TABLE    | Comentar Tabela            |
| COMMENT ON COLUMN   | Comentar Coluna            |

## Conclusão

O projeto de implementação do banco de dados **PostgreSQL** foi concluído com sucesso, consegui desenvolver meu aprendizado sobre Bancos de Dados de forma prática e eficiênte.

Realizei tarefas como criar Banco de dados, Usuários, criar Esquemas Lógicos, criar Tabelas, Chaves primárias, Chaves estrangeiras, Chaves compostas e Restrições de Checagem.

Estou ansioso por continuar meu desenvolvimento nas Áreas de Tecnologias de Informação.
 
