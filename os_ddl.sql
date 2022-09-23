DROP DATABASE IF EXISTS oficina;
CREATE DATABASE oficina;
use oficina;

CREATE TABLE IF NOT EXISTS clientes(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    CPF varchar(11) NOT NULL,
    endereco TEXT NOT NULL,
    telefone VARCHAR(14),
    CONSTRAINT cpf_unique_constraint UNIQUE(CPF)
);

CREATE TABLE IF NOT EXISTS veiculos(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(45) NOT NULL,
    marca VARCHAR(45) NOT NULL,
    numero_placa VARCHAR(20) UNIQUE,
    ano YEAR(4)
);

CREATE TABLE IF NOT EXISTS servicos(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    descricao TEXT,
    valor DOUBLE DEFAULT 1.00
);

CREATE TABLE IF NOT EXISTS pecas (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    descricao TEXT,
    valor DOUBLE DEFAULT 1.00,
    qtde INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS equipes(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    setor VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS mecanicos(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    endereco TEXT NOT NULL,
    telefone VARCHAR(14),
    COD VARCHAR(30) NOT NULL UNIQUE,
    especialidade ENUM('Mecânico Geral', 'Elétrico', 'Borracheiro', 'Lanternagem') DEFAULT 'Mecânico Geral',
    equipe_id INTEGER NOT NULL
);


# relacoes n para n
CREATE TABLE IF NOT EXISTS clientes_veiculos(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    veiculo_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS ordens_servicos (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    data_prevista DATE NOT NULL,
    data_entregue TIMESTAMP,
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aguardando aprovação', 'Concluída', 'Cancelada', 'Em Avaliação', 'Pendente Avaliacao'),
    equipe_id INTEGER NOT NULL,
    cliente_veiculo_id INTEGER NOT NULL,
    valor DOUBLE DEFAULT 0.0,
    tipo ENUM('Revisão', 'Conserto') DEFAULT 'Conserto'
);

CREATE TABLE IF NOT EXISTS servico_os(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    os_cod INTEGER NOT NULL,
    servico_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS pecas_os (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    os_cod INTEGER NOT NULL,
    peca_id INTEGER NOT NULL,
    qtde INTEGER DEFAULT 1
);
#restrições de refência
ALTER TABLE mecanicos 
    ADD CONSTRAINT FK_mecanicos_equipes 
        FOREIGN KEY (equipe_id) REFERENCES equipes(id);

ALTER TABLE clientes_veiculos 
    ADD CONSTRAINT `FK_clientesVeiculos_clientes` 
        FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    ADD CONSTRAINT `FK_clientesVeiculos_veiculos` 
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id);

ALTER TABLE pecas_os 
    ADD CONSTRAINT `FK_pecasOs_peca`
        FOREIGN KEY (peca_id) REFERENCES pecas(id),
    ADD CONSTRAINT `FK_pecasOs_os`
        FOREIGN KEY (os_cod) REFERENCES ordens_servicos(id);

ALTER TABLE servico_os 
    ADD CONSTRAINT `FK_servicoOs_servico`
        FOREIGN KEY (servico_id) REFERENCES servicos(id),
    ADD CONSTRAINT `FK_servicoOs_os`
        FOREIGN KEY (os_cod) REFERENCES ordens_servicos(id)