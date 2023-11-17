# Lab 05: Neo4J  

## Environment preparation (TODO)

## Exercices

### 1. Follow [script execution](https://neo4j.com/graphgists/cypher-introduction-social-movie-database/)


``` cypher
MATCH (n)
RETURN "Hello Graph with "+count(*)+" Nodes!"
as welcome;
```

![1_0](imgs/1_0.png)

```
MATCH (movie:Movie {title:"The Matrix"})
RETURN movie;
```

![1_1](imgs/1_1.png)


```
MATCH (movie:Movie {title:"The Matrix"})
RETURN movie.id, movie.title;
```
![1_2](imgs/1_2.png)
```
MATCH (m:Movie {title:"The Matrix"})<-[:ACTED_IN]-(actor)
RETURN actor;
```
![1_3](imgs/1_3.png)
```
MATCH (m:Movie {title:"The Matrix"})<-[:ACTED_IN]-(actor)
RETURN actor.name order by actor.name;
```
![1_4](imgs/1_4.png)
```
MATCH (m:Movie {title:"The Matrix"})<-[:ACTED_IN]-(actor)
RETURN count(*);
```
![1_5](imgs/1_5.png)
```
MATCH (m:Movie {title:"The Matrix"})<-[:ACTED_IN]-(actor)
WHERE actor.name =~ ".*s$"
RETURN actor.name;
```
![1_6](imgs/1_6.png)
```
MATCH (n)
RETURN count(*);
```
![1_7](imgs/1_7.png)
```
MATCH (n)-[r]->()
RETURN type(r), count(*);
```
![1_8](imgs/1_8.png)
```
MATCH (n)-[r]->(m)
RETURN n as from, r as `->`, m as to;
```
![1_9](imgs/1_9.png)


### 2. Run and [send commands](https://lvdamacenoblog.wordpress.com/2018/06/29/first-steps-neo4j/)


```
CREATE(dylan:Musico{nome:'Bob Dylan', data_de_nascimento: '1941-05-24'})
```
![2_0](imgs/2_0.png)
```
CREATE(hendrix:Musico{nome:'Jimi Hendrix'})
```
![2_1](imgs/2_1.png)
```
CREATE(al_along:Musica{nome:'All Along The Watchtower'})
```
![2_2](imgs/2_2.png)
```
MATCH (hendrix:Musico{nome:'Jimi Hendrix'}),(al_along:Musica{nome:'All Along The Watchtower'})
CREATE (hendrix)-[r:gravou]->(al_along)
```
![2_3](imgs/2_3.png)
```
MATCH (bob:Musico {nome: 'Bob Dylan'}), (al_along:Musica {nome: 'All Along The Watchtower'})
CREATE (bob)-[r:gravou]->(al_along)
CREATE (bob)-[s:compos]->(al_along)
```
![2_4](imgs/2_4.png)
```
MATCH (m:Musico)
RETURN m.nome
```
![2_5](imgs/2_5.png)
```
MATCH (m:Musico)
RETURN m
```
![2_6](imgs/2_6.png)
```
MATCH (m)
RETURN m
```
![2_7](imgs/2_7.png)
```
MATCH (m:Musico)
WHERE m.nome='Bob Dylan'
RETURN m
```
![2_8](imgs/2_8.png)
```
MATCH(m:Musico {nome: 'Bob Dylan'})
RETURN m
```
![2_9](imgs/2_9.png)
```
MATCH (n1)<-[]-()
RETURN n1
```
![2_10](imgs/2_10.png)
```
MATCH (n1)-[]->()
RETURN n1
```
![2_11](imgs/2_11.png)

```
MATCH (n1:Musico)-[r]->(n2:Musica)
RETURN n1, type(r), n2
```
![2_12](imgs/2_12.png)
```
MATCH (n1:Musico)-[r:gravou]->(n2:Musica)
RETURN n1, type(r), n2
```
![2_13](imgs/2_13.png)
```
MATCH (hendrix:Musico {nome: 'Jimi Hendrix'})
SET hendrix.data_de_nascimento = '1942-11-27'
```
![2_14](imgs/2_14.png)
```
MATCH (hendrix:Musico {nome: 'Jimi Hendrix'})
SET hendrix.data_de_nascimento = null
```
![2_15](imgs/2_15.png)
```
MATCH (hendrix:Musico {nome: 'Jimi Hendrix'})-[r]-()
DELETE r
```
![2_16](imgs/2_16.png)
```
MATCH (hendrix:Musico {nome: 'Jimi Hendrix'})
DELETE hendrix
```
![2_17](imgs/2_17.png)
```
MATCH (n) 
OPTIONAL MATCH (n)-[rel]-() 
DELETE rel, n 
```
![2_18](imgs/2_18.png)
```
MERGE (n1:Musico {nome: 'Bob Dylan'})
MERGE (n2:Musico {nome: 'Bob Dylan'})
```
![2_19](imgs/2_19.png)
```
LOAD CSV WITH HEADERS
FROM "file:///nome_do_arquivo.csv"
AS linha 
MERGE (compositor:Musico {nome: linha.compositor})
MERGE (musica:Musica {nome: linha.musica})
MERGE (compositor)-[:compos]->(musica)
```
![2_20](imgs/2_20.png)
```
MATCH (i:Musico)-[g:GRAVOU]->(m:Musica)
RETURN i, m
```
![2_21](imgs/2_21.png)
```
MATCH (musico:Musico)-[g:GRAVOU]->(musica:Musica)
RETURN musica, musica
```
![2_22](imgs/2_22.png)
```
MATCH (interprete:Musico)-[gravou:GRAVOU]->(musica:Musica)
MATCH (compositor:Musico)-[compos:COMPOS]->(musica:Musica)
RETURN interprete, musica, compositor
```
![2_23](imgs/2_23.png)
```
MATCH (interprete:Musico)-[gravou:GRAVOU]->(musica:Musica)
MATCH (compositor:Musico)-[compos:COMPOS]->(musica:Musica)
WHERE interprete.nome = 'Jon Bon Jovi'
RETURN interprete, musica, compositor
```
![2_24](imgs/2_24.png)
