-- Crie o keyspace (espaço de chaves) se ainda não existir
CREATE KEYSPACE IF NOT EXISTS test2 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Use o keyspace criado
USE test2;

-- Crie a primeira tabela para entidades de tipo diferente
CREATE TABLE IF NOT EXISTS tabela_1 (
    id UUID,
    nome TEXT,
    idade INT,
    endereco TUPLE<TEXT, TEXT, INT>,
    interesses LIST<TEXT>,
    idiomas SET<TEXT>,
    informacoes MAP<TEXT, TEXT>,
    PRIMARY KEY ((id), idade))
WITH CLUSTERING ORDER BY (idade ASC);

-- Inserir dados na primeira tabela
INSERT INTO tabela_1 (id, nome, idade, endereco, interesses, idiomas, informacoes)
VALUES (uuid(), 'João', 30, ('Rua Principal', 'Cidade', 12345), ['Esportes', 'Música'], {'Português', 'Inglês'}, {'email' : 'joao@email.com', 'telefone' : '123-456-7890'});
   
INSERT INTO tabela_1 (id, nome, idade, endereco, interesses, idiomas, informacoes)
VALUES (uuid(), 'Maria', 25, ('Avenida Secundária', 'Outra Cidade', 54321), ['Leitura', 'Cinema'], {'Português', 'Espanhol'}, {'email' : 'maria@email.com', 'telefone' : '987-654-3210'});

INSERT INTO tabela_1 (id, nome, idade, endereco, interesses, idiomas, informacoes)
VALUES (uuid(), 'Pedro', 28, ('Rua do Centro', 'Cidade', 56789), ['Esportes', 'Cozinha'], {'Português', 'Inglês'}, {'email' : 'pedro@email.com', 'telefone' : '456-789-0123'});
   
INSERT INTO tabela_1 (id, nome, idade, endereco, interesses, idiomas, informacoes)
VALUES (uuid(), 'Ana', 22, ('Rua Principal', 'Cidade', 12345), ['Arte', 'Música'], {'Português', 'Francês'}, {'email' : 'ana@email.com', 'telefone' : '789-012-3456'});

INSERT INTO tabela_1 (id, nome, idade, endereco, interesses, idiomas, informacoes)
VALUES (uuid(), 'Carlos', 35, ('Rua Secundária', 'Outra Cidade', 54321), ['Viagem', 'Esportes'], {'Português', 'Espanhol'}, {'email' : 'carlos@email.com', 'telefone' : '234-567-8901'});


-- Crie a segunda tabela para entidades de tipo diferente
CREATE TABLE IF NOT EXISTS tabela_2 (
    id UUID PRIMARY KEY,
    titulo TEXT,
    autores LIST<TEXT>,
    publicacao MAP<TEXT, INT>
);

-- Inserir dados na segunda tabela
INSERT INTO tabela_2 (id, titulo, autores, publicacao)
VALUES (uuid(), 'Livro 1', ['Autor 1', 'Autor 2'], {'ano' : 2020, 'edicao' : 1});

INSERT INTO tabela_2 (id, titulo, autores, publicacao)
VALUES (uuid(), 'Livro 2', ['Autor 3', 'Autor 4'], {'ano' : 2019, 'edicao' : 2});
   
INSERT INTO tabela_2 (id, titulo, autores, publicacao)
VALUES (uuid(), 'Livro 3', ['Autor 5'], {'ano' : 2021, 'edicao' : 1});
    
INSERT INTO tabela_2 (id, titulo, autores, publicacao)
VALUES (uuid(), 'Livro 4', ['Autor 6'], {'ano' : 2022, 'edicao' : 3});
    
INSERT INTO tabela_2 (id, titulo, autores, publicacao)
VALUES (uuid(), 'Livro 5', ['Autor 7', 'Autor 8'], {'ano' : 2018, 'edicao' : 4});


-- TUPLE
-- Substituir valores na coluna de tupla
UPDATE tabela_1 
SET endereco = ('Nova Rua', 'Nova Cidade', 99999) 
WHERE id = uuid() AND idade = 30;

-- Remover um valor da coluna de tupla
DELETE endereco 
FROM tabela_1
WHERE id = uuid() AND idade = 30;

-- Adicionar um valor à coluna de tupla
UPDATE tabela_1 
SET endereco = ('Nova Rua', 'Nova Cidade', 54321) 
WHERE id = uuid() AND idade = 30;


-- LIST
-- Substituir valores na coluna de lista
UPDATE tabela_1 
SET interesses =  ['Esportes'] 
WHERE id = uuid() AND idade = 30;

-- Adicionar um valor da coluna de lista
UPDATE tabela_1 
SET interesses +=  ['Danca', 'Judo'] 
WHERE id = uuid() AND idade = 30;

-- Remover um valor da coluna de lista
UPDATE tabela_1 
SET interesses =  ['Esportes', 'Danca'] 
WHERE id = uuid() AND idade = 30;


-- MAP
-- Substituir valores na coluna de mapa
UPDATE tabela_1 
SET informacoes['telefone'] = '123-456-9999'  
WHERE id = uuid() AND idade = 30;

-- Remover um par chave-valor da coluna de mapa
DELETE informacoes['telefone'] 
FROM tabela_1 
WHERE id = uuid() AND idade = 30;

-- Adicionar um par chave-valor à coluna de mapa
UPDATE tabela_1 
SET informacoes['celular'] = '123-456-4321'  
WHERE id = uuid() AND idade = 30;


-- SELECTs
-- Selecionar todas as entidades da tabela 1 com idade superior a 25 
SELECT * FROM tabela_1
WHERE idade > 25 ALLOW FILTERING;

-- Selecionar todas as entidades da tabela 1 com determinado ID e ordenar por idade em ordem crescente
SELECT * FROM tabela_1 
WHERE id = uuid(); 
ORDER BY idade;

-- Selecionar todas as entidades da tabela 1 com base em um valor específico em uma coluna de lista usando ALLOW FILTERING
SELECT * FROM tabela_1
WHERE interesses CONTAINS 'Esportes'
ALLOW FILTERING;

-- INDEX
-- Create a secondary index on the "idade" column
CREATE INDEX IF NOT EXISTS idx_idade ON tabela_1 (idade);
CREATE INDEX IF NOT EXISTS idx_publicacao ON tabela_2 (publicacao);