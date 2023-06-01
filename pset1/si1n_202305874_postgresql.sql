/*=====================================================================================================*/
/*Bem-vindo ao projeto de implementação de banco de dados no PostgreSQL.                               */
/*=====================================================================================================*/


--Apagando o banco de dados uvv, caso ele já exista.

DROP DATABASE IF EXISTS uvv
;

--Deletando o usuário "caique_almeida_amaral", caso ele já exista.

DROP USER IF EXISTS caique_almeida_amaral
;

--Criando um usuário com meu nome "caique_almeida_amaral" com as permissões para criar bancos de dados, criar roles e com uma senha criptografada.

CREATE USER caique_almeida_amaral WITH
CREATEDB
CREATEROLE
ENCRYPTED PASSWORD 'senha'
;

--Usando usuário.

\c 'postgresql://caique_almeida_amaral:senha@localhost/postgres'
;

--Criando o banco de dados uvv e definindo suas características.

CREATE DATABASE uvv WITH 
OWNER             = caique_almeida_amaral
TEMPLATE          = template0
ENCODING          = UTF8
LC_COLLATE        = "pt_BR.UTF-8"
LC_CTYPE          = "pt_BR.UTF-8"
ALLOW_CONNECTIONS = true
;

--Usando o banco de dados que foi criado.

\c uvv
;

--Consulta SQL para me mostrar o usuário atual.

SELECT CURRENT_USER
;

--Criando um schema lógico chamado de "lojas" com usuário “caique_almeida_amaral” para usalo.

CREATE SCHEMA lojas 
AUTHORIZATION caique_almeida_amaral
;

--Alterando o search_path para o usuário criado

SET SEARCH_PATH TO lojas, "$user", public
;

--Alterando o search_path para o usuário criado de forma permanente

ALTER USER caique_almeida_amaral
SET SEARCH_PATH TO lojas, "$user", public
;


/*====================================================================================================*/
/*Nesta etapa todas as tabelas são criadas.                                                           */
/*As chaves primárias e relacionamentos são criados junto as tabelas.                                 */
/*Para que isso ocorra a ordem de criação deve ser obrigatoriamente tabelas filhas e em seguida       */
/*tabelas pais.                                                                                       */
/*====================================================================================================*/

--Criando a tabela "lojas" com a coluna "loja_id" como chave primária.

CREATE TABLE lojas (
loja_id                              NUMERIC(38)  NOT NULL,
nome                                 VARCHAR(225) NOT NULL,
endereco_web                         VARCHAR(100),
endereco_fisico                      VARCHAR(512),
latitude                             NUMERIC,
longitude                            NUMERIC,
logo                                 BYTEA,
logo_mime_type                       VARCHAR(512),
logo_arquivo                         VARCHAR(512),
logo_charset                         VARCHAR(512),
logo_ultima_atualizacao              DATE,
CONSTRAINT pk_lojas                  PRIMARY KEY (loja_id)
);

--Criando a tabela "produtos" com a coluna "produto_id" como chave primária.

CREATE TABLE produtos (
produto_id                           NUMERIC(38)  NOT NULL,
nome                                 VARCHAR(225) NOT NULL,
preco_unitario                       NUMERIC(10,2),
detalhes                             BYTEA,
imagem                               BYTEA,
imagem_mime_type                     VARCHAR(512),
imagem_arquivo                       VARCHAR(512),
imagem_charset                       VARCHAR(512),
imagem_ultima_atualizacao            DATE,
CONSTRAINT pk_produtos               PRIMARY KEY (produto_id)
);

--Criando a tabela "clientes" com a coluna "cliente_id" como chave primária.

CREATE TABLE clientes (
cliente_id                           NUMERIC(38)  NOT NULL,
email                                VARCHAR(255) NOT NULL,
nome                                 VARCHAR(255) NOT NULL,
telefone1                            VARCHAR(20),
telefone2                            VARCHAR(20),
telefone3                            VARCHAR(20),
CONSTRAINT pk_clientes               PRIMARY KEY (cliente_id)
);


/*====================================================================================================*/
/* Criando a tabela "pedidos" com a chave primária "pedido_id".                                       */
/*As colunas "cliente_id" e "loja_id" são chaves estrangeiras que fazem referência a chave primária   */
/*das tabelas "clientes" e "lojas", respectivamente.                                                  */
/*====================================================================================================*/

CREATE TABLE pedidos (
pedido_id                            NUMERIC(38) NOT NULL,
data_hora                            TIMESTAMP   NOT NULL,
cliente_id                           NUMERIC(38) NOT NULL, 
status                               VARCHAR(15) NOT NULL,
loja_id                              NUMERIC(38) NOT NULL,
CONSTRAINT pk_pedidos                PRIMARY KEY (pedido_id),
CONSTRAINT fk_pedidos_clientes       FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id),
CONSTRAINT fk_pedidos_lojas          FOREIGN KEY (loja_id)    REFERENCES lojas (loja_id)
);


/*====================================================================================================*/
/*Criando a tabela "envios" com a chave primária "envio_id".                                          */
/*As colunas "loja_id" e "cliente_id" são chaves estrangeiras que fazem referência a chave primária   */
/*das tabelas "lojas" e "clientes", respectivamente.                                                  */
/*====================================================================================================*/

CREATE TABLE envios (
envio_id                             NUMERIC(38)  NOT NULL,
loja_id                              NUMERIC(38)  NOT NULL,
cliente_id                           NUMERIC(38)  NOT NULL,
endereco_entrega                     VARCHAR(512) NOT NULL,
status                               VARCHAR(15)  NOT NULL,
CONSTRAINT pk_envios                 PRIMARY KEY (envio_id),
CONSTRAINT fk_envios_lojas           FOREIGN KEY (loja_id)    REFERENCES lojas (loja_id),
CONSTRAINT fk_envios_clientes        FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id)
);


/*====================================================================================================*/
/*Criando a tabela "estoques" com a chave primária "estoque_id".                                      */
/*As colunas "loja_id" e "produto_id" são chaves estrangeiras que fazem referência a chave primária   */
/*das tabelas "lojas" e "produtos", respectivamente.                                                  */
/*====================================================================================================*/

CREATE TABLE estoques (
estoque_id                           NUMERIC(38) NOT NULL,
loja_id                              NUMERIC(38) NOT NULL,
produto_id                           NUMERIC(38) NOT NULL,
quantidade                           NUMERIC(38) NOT NULL,
CONSTRAINT pk_estoques               PRIMARY KEY (estoque_id),
CONSTRAINT fk_estoques_lojas         FOREIGN KEY (loja_id)    REFERENCES lojas (loja_id),
CONSTRAINT fk_estoques_produtos      FOREIGN KEY (produto_id) REFERENCES produtos (produto_id)
);


/*====================================================================================================*/
/*Criando a tabela "pedidos_itens" com as chaves estrangeiras primárias "pedido_id" e "produto_id",   */
/*essas chaves.                                                                                       */
/*fazem referência as chaves primárias das tabelas "pedidos" e "produtos", respectivamente.           */
/*A coluna "envio_id" é a chave estrangeira que faz referência a chave primária da tabela "envios".   */
/*====================================================================================================*/

CREATE TABLE pedidos_itens (
pedido_id                            NUMERIC(38)    NOT NULL,
produto_id                           NUMERIC(38)    NOT NULL,
numero_da_linha                      NUMERIC(38)    NOT NULL,
preco_unitario                       NUMERIC (10,2) NOT NULL,
quantidade                           NUMERIC(38)    NOT NULL,
envio_id                             NUMERIC(38),
CONSTRAINT pk_pedidos_itens          PRIMARY KEY (pedido_id,produto_id),
CONSTRAINT fk_pedidos_itens_pedidos  FOREIGN KEY (pedido_id) REFERENCES pedidos (pedido_id),
CONSTRAINT fk_pedidos_itens_produtos FOREIGN KEY (produto_id)REFERENCES produtos (produto_id),
CONSTRAINT fk_pedidos_itens_envios   FOREIGN KEY (envio_id)  REFERENCES envios (envio_id)
);


/*====================================================================================================*/
/*Aqui estão os comandos para a criação das restrições de verificação.                                */
/*====================================================================================================*/

--Criando uma constraint de checagem para tabela "produtos", onde a coluna "preco_unitario" não pode armazenar valores menores que 0.

ALTER TABLE produtos
ADD CONSTRAINT preco_unitario_constraint
CHECK (preco_unitario >= 0)
;


--Criando uma constraint de checagem para tabela “estoques”, onde a coluna “quantidade” não pode armazenar valores menores que 0.

ALTER TABLE estoques
ADD CONSTRAINT quantidade_constraint
CHECK (quantidade >= 0
);


--Criando uma constraint de checagem para tabela “pedidos_itens”, onde a coluna “preco_unitario” não pode armazenar valores menores que 0.

ALTER TABLE pedidos_itens
ADD CONSTRAINT preco_unitario_constraint
CHECK (preco_unitario >= 0)
;


--Criando uma constraint de checagem para tabela “pedidos_itens”, onde a coluna “quantidade” não pode armazenar valores menores que 0.

ALTER TABLE pedidos_itens
ADD CONSTRAINT quantidade_constraint
CHECK (quantidade >= 0)
;


--Criando uma restrição de checagem em que a coluna “endereco_fisico” ou a coluna "endereço_web" da tabela "lojas" deve ser obrigatóriamente preenchida. 

ALTER TABLE lojas
ADD CONSTRAINT endereco_fisico_web_constraint
CHECK (endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL)
;

--Criando uma constraint de checagem para tabela “pedidos”, onde a coluna “status” só pode aceitar os seguintes valores: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO e ENVIADO.

ALTER TABLE pedidos
ADD CONSTRAINT status_constraint
CHECK (status = 'CANCELADO' OR status = 'COMPLETO' OR status = 'ABERTO' OR status = 'PAGO' OR status = 'REEMBOLSADO' OR status = 'ENVIADO')
;


--Criando uma constraint de checagem para tabela “envios”, onde a coluna “status” só pode aceitar os seguintes valores: CRIADO, ENVIADO, TRANSITO e ENTREGUE.

ALTER TABLE envios
ADD CONSTRAINT status_constraint
CHECK (status = 'CRIADO' OR status = 'ENVIADO' OR status = 'TRANSITO' OR status = 'ENTREGUE')
;

/*====================================================================================================*/
/*Aqui estão todos os comentários, estão divididos como comentário ao banco de dados e comentérios de */
/*cada tabela com suas respectivas colunas.                                                           */
/*====================================================================================================*/

--Comentário referente ao banco de dados "uvv".

COMMENT ON DATABASE uvv IS
'Esse banco de dados é responsável por armazenar as tabelas lojas, produtos, clientes, pedidos, estoques, envios e produtos_itens.'
;

--Comentários referentes a tabela "lojas".

COMMENT ON TABLE lojas IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência as lojas.
';
COMMENT ON COLUMN lojas.loja_id IS 
'Essa é a chave primária da tabela “lojas”.'
;
COMMENT ON COLUMN lojas.nome IS 
'Essa coluna é responsável por armazenar o nome das lojas.'
;
COMMENT ON COLUMN lojas.endereco_web IS 
'Essa coluna é responsável por armazenar o endereço web das lojas.'
;
COMMENT ON COLUMN lojas.endereco_fisico IS 
'Essa coluna é responsável por armazenar o endereço físico das lojas.'
;
COMMENT ON COLUMN lojas.latitude IS 
'Essa coluna é responsável por armazenar o valor numérico da latitude das lojas.'
;
COMMENT ON COLUMN lojas.longitude IS 
'Essa coluna é responsável por armazenar o valor numérico da longitude das lojas.'
;
COMMENT ON COLUMN lojas.logo IS 
'Essa coluna é responsável por armazenar a logo das lojas no formato BYTEA.'
;
COMMENT ON COLUMN lojas.logo_mime_type IS 
'Essa coluna é responsável por armazenar o tipo de mime da logo das lojas.'
;
COMMENT ON COLUMN lojas.logo_arquivo IS 
'Essa coluna é responsável por armazenar o arquivo da logo das lojas.'
;
COMMENT ON COLUMN lojas.logo_charset IS 
'Essa coluna é responsável por armazenar o charset da logo das lojas.'
;
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 
'Essa coluna é responsável por armazenar a data da última atualização da logo das lojas.'
;

--Comentários referentes a tabela "produtos".

COMMENT ON TABLE produtos IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência aos produtos.'
;
COMMENT ON COLUMN produtos.produto_id IS 
'Essa é a chave primária da tabela "produtos".'
;
COMMENT ON COLUMN produtos.nome IS 
'Essa coluna é responsável por armazenar o nome dos produtos.'
;
COMMENT ON COLUMN produtos.preco_unitario IS 
'Essa coluna é responsável por armazenar o valor numérico do preço unitário dos produtos.'
;
COMMENT ON COLUMN produtos.detalhes IS 
'Essa coluna é responsável por armazenar os detalhes dos produtos no formato BYTEA.'
;
COMMENT ON COLUMN produtos.imagem IS 
'Essa coluna é responsável por armazenar as imagens dos produtos no formato BYTEA.'
;
COMMENT ON COLUMN produtos.imagem_mime_type IS 
'Essa coluna é responsável por armazenar o tipo de mime da imagem dos produtos.'
;
COMMENT ON COLUMN produtos.imagem_arquivo IS 
'Essa coluna é responsável por armazenar o arquivo da imagem dos produtos.'
;
COMMENT ON COLUMN produtos.imagem_charset IS 
'Essa coluna é responsável por armazenar o charset da imagem dos produtos.'
;
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 
'Essa coluna é responsável por armazenar a data da última atualização da imagem dos produtos.'
;

--Comentários referentes a tabela "clientes".

COMMENT ON TABLE clientes IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência aos clientes.'
;
COMMENT ON COLUMN clientes.cliente_id IS 
'Essa é a chave primária da tabela "clientes".'
;
COMMENT ON COLUMN clientes.email IS 
'Essa coluna é responsável por armazenar o email dos clientes.'
;
COMMENT ON COLUMN clientes.nome IS 
'Essa coluna é responsável por armazenar o nome dos clientes.'
;
COMMENT ON COLUMN clientes.telefone1 IS 
'Essa coluna é responsável por armazenar o primeiro telefone dos clientes.'
;
COMMENT ON COLUMN clientes.telefone2 IS 
'Essa coluna é responsável por armazenar o segundo telefone dos clientes.'
;
COMMENT ON COLUMN clientes.telefone3 IS 
'Essa coluna é responsável por armazenar o terceiro telefone dos clientes.'
;

--Comentários referentes a tabela "pedidos".

COMMENT ON TABLE pedidos IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência aos pedidos.'
;
COMMENT ON COLUMN pedidos.pedido_id IS 
'Essa é a chave primária da tabela "pedidos".'
;
COMMENT ON COLUMN pedidos.data_hora IS 
'Essa coluna é responsável por armazenar a data e hora dos pedidos.'
;
COMMENT ON COLUMN pedidos.cliente_id IS 
'Essa é chave primária da tabela "clientes", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "clientes" e "pedidos".'
;
COMMENT ON COLUMN pedidos.status IS 
'Essa coluna é responsável por armazenar o status dos pedidos.'
;
COMMENT ON COLUMN pedidos.loja_id IS 
'Essa é chave primária da tabela "lojas", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "lojas" e "pedidos".'
;

--Comentários referentes a tabela "envios".

COMMENT ON TABLE envios IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência aos envios.'
;
COMMENT ON COLUMN envios.envio_id IS 
'Essa é a chave primária da tabela "envios".'
;
COMMENT ON COLUMN envios.loja_id IS 
'Essa é chave primária da tabela "lojas", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "lojas" e "envios".'
;
COMMENT ON COLUMN envios.cliente_id IS 
'Essa é chave primária da tabela "clientes", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "clientes" e "envios".'
;
COMMENT ON COLUMN envios.endereco_entrega IS 
'Essa coluna é responsável por armazenar o endereço de entrega dos envios.'
;
COMMENT ON COLUMN envios.status IS
'Essa coluna é responsável por armazenar o status dos envios.'
;

--Comentários referentes a tabela "estoques".

COMMENT ON TABLE estoques IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência aos estoques.'
;
COMMENT ON COLUMN estoques.estoque_id IS 
'Essa é a chave primária da tabela "estoques".'
;
COMMENT ON COLUMN estoques.loja_id IS 
'Essa é chave primária da tabela "lojas", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "lojas" e "estoques".'
;
COMMENT ON COLUMN estoques.produto_id IS 
'Essa é chave primária da tabela "produtos", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "produtos" e "estoques".'
;
COMMENT ON COLUMN estoques.quantidade IS 
'Essa coluna é responsável por armazenar o o valor numérico da quantidade de produtos em estoque.'
;

--Comentários referentes a tabela "pedidos_itens".

COMMENT ON TABLE pedidos_itens IS 
'Essa tabela é responsável por armazenar as colunas que fazem referência aos pedidos de itens.'
;
COMMENT ON COLUMN pedidos_itens.produto_id IS 
'Essa é chave primária da tabela "produtos", está aqui como chave estrangeira primária devido ao relacionamento entre as tabelas "produtos" e "pedidos_itens". Não só por isso, essa chave também é identificada como chave primária para a tabela "pedidos_itens".'
;
COMMENT ON COLUMN pedidos_itens.pedido_id IS 
'Essa é chave primária da tabela "pedidos", está aqui como chave estrangeira primária devido ao relacionamento entre as tabelas "pedidos" e "pedidos_itens". Não só por isso, essa chave também é identificada como chave primária para a tabela "pedidos_itens".'
;
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 
'Essa coluna é responsável por armazenar o número da linha dos produtos e pedidos da tabela pedidos_itens.'
;
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 
'Essa coluna é responsável por armazenar o valor numérico do valor unitário dos produtos e pedidos da tabela pedidos_itens.'
;
COMMENT ON COLUMN pedidos_itens.quantidade IS 
'Essa coluna é responsável por armazenar o valor numérico da quantidade dos produtos e pedidos da tabela pedidos_itens.'
;
COMMENT ON COLUMN pedidos_itens.envio_id IS 
'Essa é chave primária da tabela "envios", está aqui como chave estrangeira devido ao relacionamento entre as tabelas "envios" e "pedidos_itens".'
;
