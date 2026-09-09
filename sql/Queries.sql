-- =========================================================
-- QUERIES DE EXEMPLO
-- Demonstram a reconstituição da informação original
-- a partir do esquema normalizado, usando JOIN.
-- Compatível com MySQL / MariaDB (XAMPP / phpMyAdmin).
-- =========================================================

USE gestao_funcionarios;

-- ---------------------------------------------------------
-- Query 1: Reconstituir a "ficha" completa de cada funcionário
-- (dados pessoais + morada completa + cargo/função/posto),
-- tal como apareceria na tabela original 0FN, sem os grupos
-- repetitivos (filhos/telefones), que são N:1 nesta consulta.
-- ---------------------------------------------------------
SELECT
    f.nome,
    f.data_nascimento,
    f.nuit,
    f.bi,
    f.email,
    f.tipo_via || ' ' || f.nome_via || ', n.º ' || f.numero_porta || ', ' || f.bairro AS endereco,
    c.nome_cidade,
    p.nome_provincia,
    pa.nome_pais,
    ca.nome_cargo,
    fu.nome_funcao,
    pt.nome_posto,
    f.data_admissao
FROM funcionario f
JOIN cidade      c  ON f.id_cidade  = c.id_cidade
JOIN provincia   p  ON c.id_provincia = p.id_provincia
JOIN pais        pa ON p.id_pais    = pa.id_pais
JOIN cargo       ca ON f.cod_cargo  = ca.cod_cargo
JOIN funcao      fu ON f.cod_funcao = fu.cod_funcao
JOIN posto_trabalho pt ON f.id_posto = pt.id_posto
ORDER BY f.nome;

-- ---------------------------------------------------------
-- Query 2: Listar cada funcionário com todos os seus filhos
-- (reconstitui as colunas "Filho 1..3" como linhas, resolvendo
-- o grupo repetitivo original através de um JOIN 1:N).
-- ---------------------------------------------------------
SELECT
    f.nome AS funcionario,
    fi.nome_filho
FROM funcionario f
JOIN filho fi ON f.id_funcionario = fi.id_funcionario
ORDER BY f.nome, fi.id_filho;

-- ---------------------------------------------------------
-- Query 3: Listar cada funcionário com todos os seus contactos
-- telefónicos (reconstitui "Celular 1..3").
-- ---------------------------------------------------------
SELECT
    f.nome AS funcionario,
    t.numero_telefone
FROM funcionario f
JOIN telefone t ON f.id_funcionario = t.id_funcionario
ORDER BY f.nome, t.id_telefone;

-- ---------------------------------------------------------
-- Query 4 (extra): Número de funcionários por cargo, mostrando
-- que a normalização não perde capacidade analítica --
-- pelo contrário, facilita agregações deste tipo.
-- ---------------------------------------------------------
SELECT
    ca.nome_cargo,
    COUNT(*) AS total_funcionarios
FROM funcionario f
JOIN cargo ca ON f.cod_cargo = ca.cod_cargo
GROUP BY ca.nome_cargo
ORDER BY total_funcionarios DESC;

-- ---------------------------------------------------------
-- Query 5 (extra): Funcionários por província, com contagem
-- de filhos e telefones associados (mostra a robustez do
-- esquema para consultas multi-tabela).
-- ---------------------------------------------------------
SELECT
    p.nome_provincia,
    COUNT(DISTINCT f.id_funcionario) AS total_funcionarios,
    COUNT(DISTINCT fi.id_filho)      AS total_filhos,
    COUNT(DISTINCT t.id_telefone)    AS total_telefones
FROM funcionario f
JOIN cidade    c  ON f.id_cidade = c.id_cidade
JOIN provincia p  ON c.id_provincia = p.id_provincia
LEFT JOIN filho    fi ON f.id_funcionario = fi.id_funcionario
LEFT JOIN telefone t  ON f.id_funcionario = t.id_funcionario
GROUP BY p.nome_provincia
ORDER BY total_funcionarios DESC;
