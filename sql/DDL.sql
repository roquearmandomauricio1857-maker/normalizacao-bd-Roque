-- =========================================================
-- Universidade Licungo - Trabalho II - Normalizacao de BD
-- DDL completo: criacao da base de dados, das 9 tabelas
-- normalizadas (4FN) e insercao de todos os dados.
-- Compativel com MySQL / MariaDB (XAMPP / phpMyAdmin).
-- =========================================================

CREATE DATABASE IF NOT EXISTS gestao_funcionarios
    CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE gestao_funcionarios;

DROP TABLE IF EXISTS telefone;
DROP TABLE IF EXISTS filho;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS posto_trabalho;
DROP TABLE IF EXISTS funcao;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS cidade;
DROP TABLE IF EXISTS provincia;
DROP TABLE IF EXISTS pais;

-- ---------------------------------------------------------
-- Hierarquia geográfica (elimina dependências transitivas
-- Cidade -> Provincia -> Pais)
-- ---------------------------------------------------------
CREATE TABLE pais (
    id_pais      INT PRIMARY KEY AUTO_INCREMENT,
    nome_pais    VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE provincia (
    id_provincia INT PRIMARY KEY AUTO_INCREMENT,
    nome_provincia VARCHAR(60) NOT NULL,
    id_pais      INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais),
    UNIQUE (nome_provincia, id_pais)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cidade (
    id_cidade    INT PRIMARY KEY AUTO_INCREMENT,
    nome_cidade  VARCHAR(60) NOT NULL,
    id_provincia INT NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia),
    UNIQUE (nome_cidade, id_provincia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- Tabelas de referência de classificação profissional
-- (elimina dependência transitiva Cod_Cargo -> Cargo /
--  Cod_Funcao -> Funcao)
-- ---------------------------------------------------------
CREATE TABLE cargo (
    cod_cargo    VARCHAR(5) PRIMARY KEY,
    nome_cargo   VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE funcao (
    cod_funcao   VARCHAR(5) PRIMARY KEY,
    nome_funcao  VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE posto_trabalho (
    id_posto     INT PRIMARY KEY AUTO_INCREMENT,
    nome_posto   VARCHAR(80) NOT NULL UNIQUE,
    id_cidade    INT NOT NULL,
    FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- Entidade principal
-- ---------------------------------------------------------
CREATE TABLE funcionario (
    id_funcionario   INT PRIMARY KEY AUTO_INCREMENT,
    nome             VARCHAR(120) NOT NULL,
    data_nascimento  DATE NOT NULL,
    nuit             VARCHAR(15) NOT NULL UNIQUE,
    bi               VARCHAR(20) NOT NULL UNIQUE,
    email            VARCHAR(120) NOT NULL UNIQUE,
    tipo_via         VARCHAR(20),
    nome_via         VARCHAR(100),
    numero_porta     VARCHAR(10),
    bairro           VARCHAR(60),
    id_cidade        INT NOT NULL,
    cod_cargo        VARCHAR(5) NOT NULL,
    cod_funcao       VARCHAR(5) NOT NULL,
    id_posto         INT NOT NULL,
    data_admissao    DATE NOT NULL,
    FOREIGN KEY (id_cidade)  REFERENCES cidade(id_cidade),
    FOREIGN KEY (cod_cargo)  REFERENCES cargo(cod_cargo),
    FOREIGN KEY (cod_funcao) REFERENCES funcao(cod_funcao),
    FOREIGN KEY (id_posto)   REFERENCES posto_trabalho(id_posto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------
-- Grupos multivalorados independentes (4FN):
-- Filhos e Telefones são extraídos para tabelas próprias,
-- pois são multivalorados e mutuamente independentes.
-- ---------------------------------------------------------
CREATE TABLE filho (
    id_filho         INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario   INT NOT NULL,
    nome_filho       VARCHAR(120) NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE telefone (
    id_telefone      INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario   INT NOT NULL,
    numero_telefone  VARCHAR(15) NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- DADOS (gerados a partir da tabela original 0FN)
-- =========================================================


INSERT INTO pais (id_pais, nome_pais) VALUES
(1, 'Moçambique');


INSERT INTO provincia (id_provincia, nome_provincia, id_pais) VALUES
(1, 'Cabo Delgado', 1),
(2, 'Gaza', 1),
(3, 'Inhambane', 1),
(4, 'Manica', 1),
(5, 'Maputo Cidade', 1),
(6, 'Maputo Província', 1),
(7, 'Nampula', 1),
(8, 'Sofala', 1),
(9, 'Tete', 1),
(10, 'Zambézia', 1);


INSERT INTO cidade (id_cidade, nome_cidade, id_provincia) VALUES
(1, 'Beira', 8),
(2, 'Chimoio', 4),
(3, 'Chókwè', 2),
(4, 'Maputo', 5),
(5, 'Matola', 6),
(6, 'Maxixe', 3),
(7, 'Nampula', 7),
(8, 'Pemba', 1),
(9, 'Quelimane', 10),
(10, 'Tete', 9);


INSERT INTO cargo (cod_cargo, nome_cargo) VALUES
('C01', 'Técnico de Informática'),
('C02', 'Contabilista'),
('C03', 'Engenheiro Civil'),
('C04', 'Enfermeiro'),
('C05', 'Professor'),
('C06', 'Motorista'),
('C07', 'Gestor de Recursos Humanos'),
('C08', 'Assistente Administrativo');


INSERT INTO funcao (cod_funcao, nome_funcao) VALUES
('F01', 'Tecnologias de Informação'),
('F02', 'Finanças'),
('F03', 'Engenharia'),
('F04', 'Saúde'),
('F05', 'Educação'),
('F06', 'Logística'),
('F07', 'Recursos Humanos'),
('F08', 'Administração');


INSERT INTO posto_trabalho (id_posto, nome_posto, id_cidade) VALUES
(1, 'Delegação Beira', 1),
(2, 'Delegação Cabo Delgado', 8),
(3, 'Delegação Gaza', 3),
(4, 'Delegação Inhambane', 6),
(5, 'Delegação Manica', 2),
(6, 'Delegação Matola', 5),
(7, 'Delegação Nampula', 7),
(8, 'Delegação Tete', 10),
(9, 'Delegação Zambézia', 9),
(10, 'Sede Maputo', 4);


INSERT INTO funcionario (id_funcionario, nome, data_nascimento, nuit, bi, email, tipo_via, nome_via, numero_porta, bairro, id_cidade, cod_cargo, cod_funcao, id_posto, data_admissao) VALUES
(1, 'Amélia Fernanda Cossa', '1985-03-12', '100234567', '110100123456A', 'amelia.cossa@empresa.co.mz', 'Avenida', 'Julius Nyerere', '245', 'Sommerschield', 4, 'C01', 'F01', 10, '2015-02-05'),
(2, 'Bernardo Alfredo Machava', '1979-07-22', '100345678', '110100234567B', 'bernardo.machava@empresa.co.mz', 'Rua', 'da Resistência', '8', 'Polana Caniço8', 4, 'C02', 'F02', 10, '2010-09-14'),
(3, 'Celina Armando Sitoe', '1990-11-03', '100456789', '110200345678C', 'celina.sitoe@empresa.co.mz', 'Avenida', 'Samora Machel', '12', 'Fomento', 5, 'C08', 'F08', 6, '2018-06-01'),
(4, 'Domingos Paulo Nhantumbo', '1982-01-30', '100567890', '110300456789D', 'domingos.nhantumbo@empresa.co.mz', 'Rua', '3', '56', 'Chókwè-Sede', 3, 'C06', 'F06', 3, '2012-03-10'),
(5, 'Eugénia Marta Muchanga', '1988-05-18', '100678901', '110400567890E', 'eugenia.muchanga@empresa.co.mz', 'Avenida', 'Eduardo Mondlane', '301', 'Maxixe-Sede', 6, 'C04', 'F04', 4, '2016-08-20'),
(6, 'Fernando José Macuácua', '1975-09-25', '100789012', '110500678901F', 'fernando.macuacua@empresa.co.mz', 'Avenida', 'Poder Popular', '77', 'Macuti', 1, 'C03', 'F03', 1, '2008-01-15'),
(7, 'Graça Isabel Zunguze', '1992-12-07', '100890123', '110600789012G', 'graca.zunguze@empresa.co.mz', 'Rua', 'da Frescura', '19', 'Ponta Gêa', 1, 'C05', 'F05', 1, '2019-02-02'),
(8, 'Hélder António Cuamba', '1980-04-14', '100901234', '110700890123H', 'helder.cuamba@empresa.co.mz', 'Avenida', '25 de Setembro', '150', 'Alto Maé', 4, 'C07', 'F07', 10, '2011-11-11'),
(9, 'Ivete Sara Chirindza', '1995-06-29', '101012345', '110800901234I', 'ivete.chirindza@empresa.co.mz', 'Rua', 'do Bagamoyo', '5', 'Muhipiti', 7, 'C01', 'F01', 7, '2020-07-03'),
(10, 'João Baptista Nhaca', '1978-08-09', '101123456', '110900012345J', 'joao.nhaca@empresa.co.mz', 'Avenida', 'Josina Machel', '200', 'Namahera', 7, 'C02', 'F02', 7, '2009-05-25'),
(11, 'Lúcia Ermelinda Bila', '1991-02-16', '101234567', '111000123456K', 'lucia.bila@empresa.co.mz', 'Rua', 'da Base', '33', 'Chaimite', 1, 'C08', 'F08', 1, '2017-09-19'),
(12, 'Marcelino Inácio Tembe', '1983-10-21', '101345678', '111100234567L', 'marcelino.tembe@empresa.co.mz', 'Avenida', 'Kwame Nkrumah', '410', 'Coop', 4, 'C03', 'F03', 10, '2013-04-08'),
(13, 'Noémia Alzira Massingue', '1987-03-04', '101456789', '111200345678M', 'noemia.massingue@empresa.co.mz', 'Rua', 'de Chimoio', '67', 'Chingussura', 2, 'C04', 'F04', 5, '2014-12-12'),
(14, 'Osvaldo Simião Ubisse', '1976-07-27', '101567890', '111300456789N', 'osvaldo.ubisse@empresa.co.mz', 'Avenida', '7 de Setembro', '90', 'Matundo', 10, 'C06', 'F06', 8, '2006-10-30'),
(15, 'Paulina Fátima Uache', '1993-01-15', '101678901', '111400567890O', 'paulina.uache@empresa.co.mz', 'Rua', 'da Missão', '24', 'Chalaua', 9, 'C05', 'F05', 9, '2021-09-09'),
(16, 'Ricardo Manuel Come', '1981-06-02', '101789012', '111500678901P', 'ricardo.come@empresa.co.mz', 'Avenida', 'Franqueza', '18', 'Chuwaula', 8, 'C07', 'F07', 2, '2010-07-17');


INSERT INTO filho (id_filho, id_funcionario, nome_filho) VALUES
(1, 1, 'Cátia Cossa'),
(2, 2, 'Nelson Machava'),
(3, 2, 'Ivete Machava'),
(4, 2, 'Suzana Machava'),
(5, 4, 'Paulo Nhantumbo Jr'),
(6, 4, 'Alzira Nhantumbo'),
(7, 5, 'Marta Muchanga'),
(8, 6, 'José Macuácua'),
(9, 6, 'Beatriz Macuácua'),
(10, 6, 'Adriano Macuácua'),
(11, 8, 'António Cuamba Jr'),
(12, 8, 'Filomena Cuamba'),
(13, 10, 'Baptista Nhaca Jr'),
(14, 11, 'Ermelinda Bila'),
(15, 12, 'Inácio Tembe Jr'),
(16, 12, 'Rosa Tembe'),
(17, 14, 'Simião Ubisse Jr'),
(18, 14, 'Alcinda Ubisse'),
(19, 14, 'Custódio Ubisse'),
(20, 16, 'Manuel Come Jr');


INSERT INTO telefone (id_telefone, id_funcionario, numero_telefone) VALUES
(1, 1, '841234567'),
(2, 1, '821234567'),
(3, 2, '845678901'),
(4, 3, '861122334'),
(5, 4, '847890123'),
(6, 4, '878901234'),
(7, 5, '849012345'),
(8, 6, '823456789'),
(9, 6, '843456789'),
(10, 6, '863456789'),
(11, 7, '844567890'),
(12, 7, '824567890'),
(13, 8, '825678901'),
(14, 9, '846789012'),
(15, 10, '827890123'),
(16, 10, '847890124'),
(17, 11, '848901234'),
(18, 12, '829012345'),
(19, 12, '849012346'),
(20, 12, '869012347'),
(21, 13, '841122334'),
(22, 14, '822233445'),
(23, 14, '842233445'),
(24, 15, '843344556'),
(25, 16, '824455667'),
(26, 16, '844455667');