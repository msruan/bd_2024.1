Crie os scripts SQL de criação e inserção de dados nas tabelas do banco de dados HOTEL. Em
seguida, escreva consultas SQL para os itens abaixo.
--------------------------------------------------------------------------------------------------------------

1. Categorias que possuam preços entre R$ 100,00 e R$ 200,00.
SELECT *
FROM CATEGORIA 
WHERE VALOR_DIA BETWEEN 100 AND 200;

--------------------------------------------------------------------------------------------------------------

2. Categorias cujos nomes possuam a palavra ‘Luxo’.
SELECT *
FROM CATEGORIA 
WHERE NOME ILIKE '%LUXO%';

--------------------------------------------------------------------------------------------------------------
3. Nomes de categorias de apartamentos que foram ocupados há mais de 5 anos.
SELECT * 
FROM APARTAMENTO AP 
NATURAL JOIN HOSPEDAGEM
WHERE DT_ENT <= NOW() - INTERVAL '5 YEARS';
--------------------------------------------------------------------------------------------------------------
4. Apartamentos que estão ocupados, ou seja, a data de saída está vaziaSELECT * 
FROM APARTAMENTO AP 
NATURAL JOIN HOSPEDAGEM
WHERE DT_SAI IS NULL;

--------------------------------------------------------------------------------------------------------------

5. Apartamentos cuja categoria tenha código 1, 2, 3, 11, 34, 54, 24, 12.
SELECT * FROM APARTAMENTO WHERE COD_CAT IN (1,2,3,11,34,54,24,12)

--------------------------------------------------------------------------------------------------------------
6. Apartamentos cujas categorias iniciam com a palavra ‘Luxo’.
SELECT *
FROM APARTAMENTO AP
NATURAL JOIN CATEGORIA
WHERE NOME ILIKE 'LUXO%'
--------------------------------------------------------------------------------------------------------------

7. Quantidade de apartamentos cadastrados no sistema.
SELECT COUNT(*)
FROM APARTAMENTO;

--------------------------------------------------------------------------------------------------------------
8. Somatório dos preços das categorias.
SELECT SUM(VALOR_DIA)
FROM CATEGORIA;

-----------------------------------------------------------------------------------------------------------------

9. Média de preços das categorias.
SELECT AVG(VALOR_DIA)
FROM CATEGORIA;

-----------------------------------------------------------------------------------------------------------------

10. Maior preço de categoria.
SELECT MAX(VALOR_DIA)
FROM CATEGORIA;

-----------------------------------------------------------------------------------------------------------------

11. Menor preço de categoria.
SELECT MIN(VALOR_DIA)
FROM CATEGORIA;

-----------------------------------------------------------------------------------------------------------------


12. O preço média das diárias dos apartamentos ocupados por cada hóspede.
SELECT NOME, MEDIA FROM 
	(SELECT COD_HOSP, AVG(VALOR_DIA) MEDIA
	FROM HOSPEDAGEM H
	NATURAL JOIN APARTAMENTO A
	NATURAL JOIN CATEGORIA C
	GROUP BY H.COD_HOSP) RESPOSTA
NATURAL JOIN HOSPEDE


-----------------------------------------------------------------------------------------------------------------

13. Quantidade de apartamentos para cada categoria.
SELECT C.*, COUNT(*) QUANTIDADE
FROM CATEGORIA C
LEFT JOIN APARTAMENTO A
ON C.COD_CAT = A.COD_CAT
GROUP BY C.COD_CAT

-- UNION
-- (
--     (SELECT *
--     FROM CATEGORIA C 

--     EXCEPT

--     SELECT C.*
--     FROM CATEGORIA C
--     NATURAL JOIN apartamento A) CSEMAPTO
    
-- )
--obs: NAO PEGA categorias sem aptos
-----------------------------------------------------------------------------------------------------------------

14. Categorias que possuem pelo menos 2 apartamentos.
SELECT C.*, COUNT(*) QUANTIDADE
FROM CATEGORIA C
NATURAL JOIN APARTAMENTO A
GROUP BY COD_CAT
HAVING COUNT(*) >= 2

-----------------------------------------------------------------------------------------------------------------

15. Nome dos hóspedes que nasceram após 1° de janeiro de 1970.
SELECT NOME
FROM HOSPEDE
WHERE DT_NASC > '1970-01-01';
-----------------------------------------------------------------------------------------------------------------

16. Quantidade de hóspedes.
SELECT COUNT(*)
FROM HOSPEDE;
-----------------------------------------------------------------------------------------------------------------

17. Apartamentos que foram ocupados pelo menos 2 vezes.
SELECT NUM, COUNT(*) Quantidade
FROM HOSPEDAGEM
GROUP BY NUM
HAVING COUNT(*) >= 2;
-----------------------------------------------------------------------------------------------------------------

18. Altere a tabela Hóspede, acrescentando o campo "Nacionalidade".
alter table hospede
add column nacionalidade varchar(50) null;
-----------------------------------------------------------------------------------------------------------------

19.Quantidade de hóspedes para cada nacionalidade.
SELECT NACIONALIDADE, COUNT (*)
FROM HOSPEDE
GROUP BY NACIONALIDADE
-----------------------------------------------------------------------------------------------------------------

20. A data de nascimento do hóspede mais velho.
SELECT MIN(DT_NASC) FROM HOSPEDE;

-----------------------------------------------------------------------------------------------------------------

21. A data de nascimento do hóspede mais novo.
SELECT MAX(DT_NASC) FROM HOSPEDE;

-----------------------------------------------------------------------------------------------------------------

22. Reajuste em 10% o valor das diárias das categorias.
UPDATE CATEGORIA SET VALOR_DIA = VALOR_DIA*10;

-----------------------------------------------------------------------------------------------------------------

23. O nome das categorias que não possuem apartamentos.
SELECT NOME
FROM CATEGORIA C
LEFT JOIN APARTAMENTO A 
ON C.COD_CAT = A.COD_CAT
WHERE A.NUM IS NULL;

-----------------------------------------------------------------------------------------------------------------

24. O número dos apartamentos que nunca foram ocupados.
SELECT A.NUM 
FROM APARTAMENTO A 
LEFT JOIN HOSPEDAGEM H 
ON A.NUM = H.NUM 
WHERE H.COD_HOSPEDA IS NULL;

-----------------------------------------------------------------------------------------------------------------

25. O número do apartamento mais caro ocupado pelo João.
SELECT NUM
FROM HOSPEDE H
NATURAL JOIN HOSPEDAGEM 
NATURAL JOIN APARTAMENTO A
JOIN CATEGORIA C
ON A.COD_CAT = C.COD_CAT
WHERE H.NOME ILIKE 'JOÃO%'
ORDER BY VALOR_DIA DESC LIMIT 1

-----------------------------------------------------------------------------------------------------------------

26. O nome dos hóspedes que nunca se hospedaram no apartamento 201.
SELECT NOME
FROM HOSPEDE 
EXCEPT
SELECT NOME
FROM HOSPEDE
NATURAL JOIN HOSPEDAGEM 
WHERE NUM=201

-----------------------------------------------------------------------------------------------------------------

SELECT *
FROM HOSPEDE
LEFT JOIN
HOSPEDAGEM H
ON HOSPEDE.COD_HOSP = H.COD_HOSP
WHERE NUM = 101

-----------------------------------------------------------------------------------------------------------------

27. O nome dos hóspedes que nunca se hospedaram em apartamentos da categoria LUXO.
SELECT NOME FROM
(
SELECT COD_HOSP
FROM HOSPEDE

EXCEPT

SELECT COD_HOSP
FROM HOSPEDE NATURAL JOIN HOSPEDAGEM 
NATURAL JOIN APARTAMENTO A JOIN CATEGORIA C ON 
A.COD_CAT = C.COD_CAT 
WHERE C.NOME ILIKE 'LUXO'
) RESPOSTA
NATURAL JOIN HOSPEDE;

-----------------------------------------------------------------------------------------------------------------

28. O nome dos hóspedes que se hospedaram ou reservaram apartamento do tipo LUXO.

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN HOSPEDAEM 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO'

UNION 

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN RESERVA R 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO';

-----------------------------------------------------------------------------------------------------------------

29. O nome dos hóspedes que se hospedaram mas nunca reservaram apartamentos do tipo
LUXO.

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN HOSPEDAEM 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO'

EXCEPT

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN RESERVA R 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO';

--2

(SELECT *
FROM HOSPEDAGEM H NATURAL JOIN APARTAMENTO NATURAL JOIN CATEGORIA
WHERE NOME ILIKE 'LUXO')
LEFT JOIN 
(SELECT *
FROM RESERVA R NATURAL JOIN APARTAMENTO NATURAL JOIN CATEGORIA
WHERE NOME ILIKE 'LUXO')
ON H.COD_HOSP = R.COD_HOSP 

-----------------------------------------------------------------------------------------------------------------

30. O nome dos hóspedes que se hospedaram e reservaram apartamento do tipo LUXO
SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN HOSPEDAEM 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO'

INTERSECT 

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN RESERVA R 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO';

-----------------------------------------------------------------------------------------------------------------


1. Listagem dos hóspedes contendo nome e data de nascimento, ordenada em ordem
crescente por nome e decrescente por data de nascimento.
SELECT NOME, DT_NASC 
FROM HOSPEDE
ORDER BY NOME ASC, DT_NASC DESC

-----------------------------------------------------------------------------------------------------------------

2. Listagem contendo os nomes das categorias, ordenados alfabeticamente. A coluna de
nomes deve ter a palavra ‘Categoria’ como título.
SELECT NOME CATEGORIA
FROM CATEGORIA 
ORDER BY NOME ASC

-----------------------------------------------------------------------------------------------------------------

3. Listagem contendo os valores de diárias e os números dos apartamentos, ordenada em
ordem decrescente de valor.
SELECT VALOR_DIA, NUM 
FROM CATEGORIA NATURAL JOIN APARTAMENTO
ORDER BY VALOR_DIA DESC
-----------------------------------------------------------------------------------------------------------------

4. Categorias que possuem apenas um apartamento.
SELECT COD_cAT, COUNT(*) QUANTIDADE
FROM APARTAMENTO NATURAL JOIN CATEGORIA
GROUP BY COD_cAT HAVING COUNT(*) = 1

-----------------------------------------------------------------------------------------------------------------

5. Listagem dos nomes dos hóspedes brasileiros com mês e ano de nascimento, por ordem
decrescente de idade e por ordem crescente de nome do hóspede.

SELECT NOME, EXTRACT(MONTH FROM DT_NASC) MES, EXTRACT(YEAR FROM DT_NASC) ANO
FROM HOSPEDE
WHERE NACIONALIDADE ILIKE 'BRASILEIRO' OR NACIONALIDADE ILIKE 'BRASILEIRA' OR NACIONALIDADE ILIKE 'BRASIL'
ORDER BY DT_NASC DESC, NOME ASC
-----------------------------------------------------------------------------------------------------------------

6. Listagem com 3 colunas, nome do hóspede, número do apartamento e quantidade (número
de vezes que aquele hóspede se hospedou naquele apartamento), em ordem decrescente de
quantidade.

SELECT NOME, NUM, COUNT(*) QUANTIDADE
FROM HOSPEDE 
NATURAL JOIN HOSPEDAGEM
GROUP BY NOME, num
ORDER BY QUANTIDADE DESC;

-----------------------------------------------------------------------------------------------------------------

7. Categoria cujo nome tenha comprimento superior a 15 caracteres.
select *
from categoria
where nome ilike '________________%'

8. Número dos apartamentos ocupados no ano de 2017 com o respectivo nome da sua
categoria.
select num, nome
FROM APARTAMENTO A NATURAL JOIN CATEGORIA C NATURAL JOIN HOSPEDAGEM H 
WHERE EXTRACT(year from dt_ent) = 2017

---9. Título do livro, nome da editora que o publicou e a descrição do assunto.
10. Crie a tabela funcionário com as atributos: cod_func, nome, dt_nascimento e salário.
Depois disso, acrescente o cod_func como chave estrangeira nas tabelas hospedagem e
reserva.
create table FUNCIONARIO(
		cod_func int not null primary key,
		nome varchar(50) not null,
		dt_nasc date null,
		salario float not null,
	)

11. Mostre o nome e o salário de cada funcionário. Extraordinariamente, cada funcionário
receberá um acréscimo neste salário de 10 reais para cada hospedagem realizada.

-- update FUNCIONARIO F SET salario = salario + (
--     SELECT COUNT(*)
--     FROM HOSPEDAGEM 
--     GROUP BY(FUNCIONARIO)
--     WHERE FUNCIONARIO.COD_FUNC = F.COD_FUNC
-- ) * 10;

12. Listagem das categorias cadastradas e para aquelas que possuem apartamentos, relacionar
também o número do apartamento, ordenada pelo nome da categoria e pelo número do
apartamento.
SELECT *
FROM CATEGORIA C
LEFT JOIN APARTAMENTO A
ON C.COD_cAT = A.COD_CAT
ORDER BY NOME, NUM

13. Listagem das categorias cadastradas e para aquelas que possuem apartamentos, relacionar
também o número do apartamento, ordenada pelo nome da categoria e pelo número do
apartamento. Para aquelas que não possuem apartamentos associados, escrever "não possui
apartamento".
sELECT c.NOME AS nome_categoria, COALESCE(a.NUM::char, 'não possui apartamento') AS numero_apartamento
FROM CATEGORIA c
LEFT JOIN APARTAMENTO a ON c.COD_CAT = a.COD_CAT
ORDER BY c.NOME, a.NUM;


14. O nome dos funcionário que atenderam o João (hospedando ou reservando) ou que
hospedaram ou reservaram apartamentos da categoria luxo.

15. O código das hospedagens realizadas pelo hóspede mais velho que se hospedou no
apartamento mais caro.


SELECT COD_HOSPEDA FROM (
	SELECT COD_HOSP FROM
	(SELECT NUM
	FROM APARTAMENTO NATURAL JOIN CATEGORIA 
	ORDER BY VALOR_DIA DESC LIMIT 1) NUMDOMAISCARO
	NATURAL JOIN HOSPEDAGEM NATURAL JOIN HOSPEDE 
	ORDER BY DT_NASC ASC LIMIT 1
)CODIGOMAISVELHO NATURAL JOIN HOSPEDAGEM


16. Sem usar subquery, o nome dos hóspedes que nasceram na mesma data do hóspede de
código 2.
SELECT H2.NOME
FROM HOSPEDE H 
JOIN HOSPEDE H2
ON (H.COD_HOSP = 2 
AND H2.COD_HOSP != 2 )
WHERE H.DT_NASC = H2.DT_NASC


17. O nome do hóspede mais velho que se hospedou na categoria mais cara mo ano de 2017.
SELECT NOME FROM 
	(SELECT H.NOME, C.COD_CAT
	FROM HOSPEDE H NATURAL JOIN HOSPEDAGEM NATURAL JOIN APARTAMENTO A JOIN CATEGORIA C
	ON A.COD_cAT = C.COD_CAT
	WHERE EXTRACT(YEAR FROM DT_ENT) = 2017) HOSPEDAGENSDE2017
NATURAL JOIN (
	SELECT COD_CAT
	FROM CATEGORIA
	ORDER BY VALOR_DIA DESC LIMIT 1
	) CODCATMAISCARA
LIMIT 1;


18. O nome das categorias que foram reservadas pela Maria ou que foram ocupadas pelo João
quando ele foi atendido pelo Joaquim.

19. O nome e a data de nascimento dos funcionários, além do valor de diária mais cara
reservado por cada um deles.

SELECT F.NOME, F.DT_NASC, max(valor_Dia)
FROM FUNCIONARIO f
NATURAL JOIN HOSPEDAGEM 
NATURAL JOIN APARTAMENTO A
JOIN CATEGORIA C
ON A.COD_CAT = C.COD_CAT
group by f.cod_func



20. A quantidade de apartamentos ocupados por cada um dos hóspedes (mostrar o nome).
SELECT NOME, QUANTIDADE FROM (
    SELECT COD_HOSP, COUNT(NUM) QUANTIDADE
    FROM (SELECT DISTINCT COD_HOSP, NUM FROM HOSPEDAGEM 
        ) DISTINTOS
    GROUP BY COD_HOSP
) RESPOSTA
NATURAL JOIN HOSPEDE
---
SELECT NOME, QUANTIDADE FROM (
    SELECT COD_HOSP, COUNT(DISTINCT NUM) QUANTIDADE
    FROM  HOSPEDAGEM 
    GROUP BY COD_HOSP
) RESPOSTA
NATURAL JOIN HOSPEDE

21. A relação com o nome dos hóspedes, a data de entrada, a data de saída e o valor total
pago em diárias (não é necessário considerar a hora de entrada e saída, apenas as datas).


22. O nome dos hóspedes que já se hospedaram em todos os apartamentos do hotel.

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN HOSPEDAEM 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO'

UNION 

SELECT H.NOME 
FROM HOSPEDE H 
NATURAL JOIN RESERVA R 
NATURAL JOIN APARTAMENTO AP 
JOIN CATEGORIA C 
ON AP.COD_CAT = C.COD_CAT
WHERE C.NOME ILIKE 'LUXO';

create table FUNCIONARIO(
    cod_func int not null primary key,
    nome varchar(50) not null,
    dt_nasc date null,
    salario float not null,
)
