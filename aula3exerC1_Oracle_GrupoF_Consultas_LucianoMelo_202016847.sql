-- =====     << Exercício Colaborativo 1 da Aula 3 - Evolução 2 (Oracle) >>     =====
--
--                    SCRIPT DE CONSULTA (DML)
--
-- Data Criacao ...........: 07/07/2025
-- Autor(es) ..............: Luciano de Freitas Melo, Maria Eduarda dos Santos Abritta Ferreira, Matheus Henrique dos Santos
-- Banco de Dados .........: ORACLE
-- Base de Dados (nome) ...: VRVR
--
-- PROJETO => 01 Base de Dados
--         => 07 Tabelas
--         => 05 Sequencias
--         => 01 View
--         => 02 Índices
-- 
-- 
-- ULTIMAS ATUALIZACOES
--
-- ---------------------------------------------------------


-- 1) Indicar todos os plantonistas por um setor específico fornecido pelo usuário da consulta, 
--    que será apresentada em ordem decrescente de horário para todas as alas;

    -- Substituir :ID_SETOR pelo valor desejado
SELECT 
    p.MATRICULA,
    p.NOME_COMPLETO,
    s.NOME_SETOR,
    h.HORA_INICIO,
    h.HORA_FIM
FROM GF_ALOCACAO al
INNER JOIN GF_PLANTONISTA p ON al.MATRICULA_PLANTONISTA = p.MATRICULA
INNER JOIN GF_SETOR s ON al.ID_SETOR = s.ID_SETOR
INNER JOIN GF_HORARIO h ON al.ID_HORARIO = h.ID_HORARIO
WHERE 
   s.ID_SETOR = :ID_SETOR
ORDER BY 
    h.HORA_INICIO DESC;


-- 2) Mostrar todos os plantonistas em uma data fornecida pelo usuário em ordem crescente de data 
--    (consulta no padrão DE__  ATÉ__  para datas), em que o intervalo DE e ATÉ serão fornecidos pelo usuário, 
--    podendo serem iguais, ou seja, para consultar todos os plantões em um único dia;
    
    -- Substituir :DATA_INICIO e :DATA_FIM pelos valores desejados
SELECT 
    p.MATRICULA AS MATRICULA_PLANTONISTA,
    p.NOME_COMPLETO AS NOME_PLANTONISTA,
    h.HORA_INICIO AS INICIO_PLANTAO,
    h.HORA_FIM AS FIM_PLANTAO
FROM GF_ALOCACAO al
JOIN GF_PLANTONISTA p ON p.MATRICULA = al.MATRICULA_PLANTONISTA
JOIN GF_HORARIO h ON h.ID_HORARIO = al.ID_HORARIO

WHERE 
     TRUNC(h.HORA_INICIO) BETWEEN TO_DATE(:DATA_INICIO, 'DD/MM/YYYY') 
                             AND TO_DATE(:DATA_FIM, 'DD/MM/YYYY')

ORDER BY 
    h.HORA_INICIO ASC;


-- 3) Consulta os plantonistas por parte do nome e mostrar todos os seus dados pessoais cadastrados e em qual setor 
--    (ou setores e alas) ele realiza atividades, mostrando somente o nome do setor, os dados da(s) ala(s) e os dados pessoais do plantonista;

    -- Substituir :NOME_PLANTONISTA com parte do nome desejado
SELECT
    p.MATRICULA AS MATRICULA_PLANTONISTA,
    p.NOME_COMPLETO AS NOME_PLANTONISTA,
    p.SEXO AS SEXO_PLANTONISTA,
    s.NOME_SETOR AS SETOR_ATUACAO,
    a.NOME_ALA AS ALA_ATUACAO,
    a.QTDE_QUARTOS AS QTDE_QUARTOS_ALA,
    a.QTDE_SALAS_CIRURGIA AS QTDE_SALAS_CIRURGIA_ALA,
    a.QTDE_ENFERMARIAS AS QTDE_ENFERMARIAS_ALA,
    a.QTDE_PROFISSIONAIS AS QTDE_PROFISSIONAIS_ALA
FROM 
    GF_PLANTONISTA p
JOIN GF_ALOCACAO al ON p.MATRICULA = al.MATRICULA_PLANTONISTA
JOIN GF_SETOR s ON al.ID_SETOR = s.ID_SETOR
JOIN GF_ALA a ON s.ID_SETOR = a.ID_SETOR
WHERE 
    UPPER(p.NOME_COMPLETO) LIKE UPPER('%' || :NOME_PLANTONISTA || '%')
ORDER BY 
    p.MATRICULA;

-- 4) Apresentar todas as especialidades e quantos plantonistas têm para cada uma destas especialidades cadastradas na base de dados, 
--    inclusive as que NÃO tiverem plantonista no momento (zero plantonista na especialidade, mas apresentar para o usuário saber qual área 
--    está sem plantonista pela indicação do nome e o valor zero na quantidade);

    -- Proposta inicial da VIEW
CREATE OR REPLACE VIEW GF_EspecialidadesPlantonistas_VIEW AS
SELECT 
    e.NOME_ESPECIALIDADE,
    COUNT(t.MATRICULA_PLANTONISTA) AS QTD_PLANTONISTAS
FROM 
    GF_ESPECIALIDADE e
LEFT JOIN GF_TEM t ON e.ID_ESPECIALIDADE = t.ID_ESPECIALIDADE
GROUP BY 
    e.NOME_ESPECIALIDADE;

    -- Consulta para a proposta inical da view
SELECT *
FROM 
    GF_EspecialidadesPlantonistas_VIEW
WHERE 
    ROWNUM <= 5
ORDER BY 
    NOME_ESPECIALIDADE;

    -- EXPLAIN para a view
EXPLAIN PLAN FOR
SELECT 
    e.NOME_ESPECIALIDADE,
    COUNT(t.MATRICULA_PLANTONISTA) AS QTD_PLANTONISTAS
FROM 
    GF_ESPECIALIDADE e
LEFT JOIN GF_TEM t ON e.ID_ESPECIALIDADE = t.ID_ESPECIALIDADE
GROUP BY 
    e.NOME_ESPECIALIDADE;

    -- EXPLAIN para a consulta
EXPLAIN PLAN FOR
SELECT 
    NOME_ESPECIALIDADE,
    QTD_PLANTONISTAS
FROM 
    GF_EspecialidadesPlantonistas_VIEW
WHERE 
    ROWNUM <= 5
ORDER BY 
    NOME_ESPECIALIDADE;

    -- Para melhorar a performace foi criado índices nas tabelas GF_TEM e GF_ESPECIALIDADE, 
    -- além disso foi introduzido hints na criação da view e na consulta;

CREATE INDEX IDX_GF_TEM_ESPECIALIDADE ON GF_TEM(ID_ESPECIALIDADE);
CREATE INDEX IDX_GF_ESPECIALIDADE_NOME ON GF_ESPECIALIDADE(NOME_ESPECIALIDADE);

    -- View otimizada
CREATE OR REPLACE VIEW GF_EspecialidadesPlantonistas_VIEW AS
SELECT /*+ INDEX(t IDX_GF_TEM_ESPECIALIDADE) */
    e.NOME_ESPECIALIDADE,
    COUNT(t.MATRICULA_PLANTONISTA) AS QTD_PLANTONISTAS
FROM 
    GF_ESPECIALIDADE e
LEFT JOIN GF_TEM t ON e.ID_ESPECIALIDADE = t.ID_ESPECIALIDADE
GROUP BY 
    e.NOME_ESPECIALIDADE;

    -- Consulta otimizada
SELECT /*+ INDEX(v IDX_GF_ESPECIALIDADE_NOME) */
    NOME_ESPECIALIDADE,
    QTD_PLANTONISTAS
FROM 
    GF_EspecialidadesPlantonistas_VIEW
WHERE 
    ROWNUM <= 5
ORDER BY 
    NOME_ESPECIALIDADE;

-- 5) Mostrar todos os plantonistas por nome, sexo por extenso e a especialidades também só por extenso;

SELECT 
    p.NOME_COMPLETO AS NOME_PLANTONISTA,
    CASE p.SEXO
        WHEN 'M' THEN 'Masculino'
        WHEN 'F' THEN 'Feminino'
        ELSE 'Outro'
    END AS SEXO_PLANTONISTA,
    LISTAGG(e.NOME_ESPECIALIDADE, ', ') AS ESPECIALIDADES_PLANTONISTA
FROM 
    GF_PLANTONISTA p
LEFT JOIN GF_TEM t ON t.MATRICULA_PLANTONISTA = p.MATRICULA
LEFT JOIN GF_ESPECIALIDADE e ON e.ID_ESPECIALIDADE = t.ID_ESPECIALIDADE
GROUP BY 
    p.NOME_COMPLETO,
    p.SEXO
ORDER BY 
    p.NOME_COMPLETO;

-- 6) Pesquisar em um dia específico um intervalo de horas usando a opção DE e ATÉ 
--    para o intervalo de horas desejado pelo usuário no dia específico desejado pelo usuário.

-- Substituir :DATA, :HORA_INICIO, :HORA_FIM
SELECT 
    p.NOME_COMPLETO AS NOME_PLANTONISTA,
    s.NOME_SETOR,
    TO_CHAR(h.HORA_INICIO, 'DD/MM/YYYY HH24:MI') AS INICIO_PLANTAO,
    TO_CHAR(h.HORA_FIM, 'DD/MM/YYYY HH24:MI') AS FIM_PLANTAO
FROM 
    GF_ALOCACAO a
JOIN GF_HORARIO h ON a.ID_HORARIO = h.ID_HORARIO
JOIN GF_PLANTONISTA p ON p.MATRICULA = a.MATRICULA_PLANTONISTA
JOIN GF_SETOR s ON s.ID_SETOR = a.ID_SETOR
WHERE 
    h.HORA_FIM >= TO_TIMESTAMP(:DATA || ' ' || :HORA_INICIO, 'DD/MM/YYYY HH24:MI')
    AND h.HORA_INICIO <= TO_TIMESTAMP(:DATA || ' ' || :HORA_FIM, 'DD/MM/YYYY HH24:MI')
ORDER BY 
    h.HORA_INICIO;