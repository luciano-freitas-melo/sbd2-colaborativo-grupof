-- =====     << Exercício Colaborativo 1 da Aula 3 - Evolução 2 (Oracle) >>     =====
--
--                    SCRIPT DE APAGA (DDL)
--
-- Data Criacao ...........: 30/06/2025
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
-- 08/07/2025 => Remoção da tabela ALA
--            => Remoção da sequência ID_ALA
--            => Remoção da view EspecialidadesPlantonistas
--
-- 09/07/2025 => Remoção de índices
--
-- ------------------------------------------------------------------------------------------------------

DROP INDEX IDX_GF_TEM_ESPECIALIDADE;
DROP INDEX IDX_GF_ESPECIALIDADE_NOME;

DROP VIEW GF_EspecialidadesPlantonistas_VIEW;

DROP TABLE GF_ALOCACAO;
DROP TABLE GF_TEM;
DROP TABLE GF_ALA;
DROP TABLE GF_HORARIO;
DROP TABLE GF_SETOR;
DROP TABLE GF_PLANTONISTA;
DROP TABLE GF_ESPECIALIDADE;

DROP SEQUENCE GF_SEQ_ID_ALOCACAO;
DROP SEQUENCE GF_SEQ_ID_ALA;
DROP SEQUENCE GF_SEQ_ID_HORARIO;
DROP SEQUENCE GF_SEQ_ID_SETOR;
DROP SEQUENCE GF_SEQ_ID_ESPECIALIDADE;
