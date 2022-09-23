USE oficina;

DELIMITER //
CREATE PROCEDURE insere_dados()
BEGIN
DECLARE erro_sql TINYINT DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;
START TRANSACTION;


    INSERT INTO clientes(id, nome, endereco, telefone,cpf ) VALUES(1, 'Eduardo', 'Ali 1', '557556', '456789');
    INSERT INTO clientes(id, nome, endereco, telefone,cpf ) VALUES(2, 'Lucinaldo', 'Ali 2', '557556', '456790');
    INSERT INTO clientes(id, nome, endereco, telefone,cpf ) VALUES(3, 'Jefferson', 'Ali 3', '557556', '456791');

    INSERT INTO veiculos(id, marca, modelo, ano, numero_placa) VALUES(1, 'Fiat', 'Uno Way', '2004', 'ABZ541');
    INSERT INTO veiculos(id, marca, modelo, ano, numero_placa) VALUES(2, 'Citroen', 'C3', '2022', 'FBZ741');
    INSERT INTO veiculos(id, marca, modelo, ano, numero_placa) VALUES(3, 'Ford', 'Ranger', '2012', 'ZAZ541');
    INSERT INTO veiculos(id, marca, modelo, ano, numero_placa) VALUES(4, 'Fiat', '', '2004', 'PBC541');
    INSERT INTO veiculos(id, marca, modelo, ano, numero_placa) VALUES(5, 'Fiat', 'Palio', '2019', 'JFZ741');

    #cliente com mais de um veiculo
    INSERT INTO clientes_veiculos(id, cliente_id, veiculo_id) VALUES(1, 1, 1 );
    INSERT INTO clientes_veiculos(id, cliente_id, veiculo_id) VALUES(2, 1, 2 );

    INSERT INTO clientes_veiculos(id, cliente_id, veiculo_id) VALUES(3, 2, 3 );
    #cliente 3 é próximo do cliente 1
    INSERT INTO clientes_veiculos(id, cliente_id, veiculo_id) VALUES(4, 3, 4 );
    INSERT INTO clientes_veiculos(id, cliente_id, veiculo_id) VALUES(5, 3, 1 );

    INSERT INTO clientes_veiculos(id, cliente_id, veiculo_id) VALUES(6, 2, 5 );

    INSERT INTO equipes(id, setor) VALUES(1, 'Mecânica');
    INSERT INTO equipes(id, setor) VALUES(2, 'Revisão');
    INSERT INTO equipes(id, setor) VALUES(3, 'Elétrica');
    INSERT INTO equipes(id, setor) VALUES(4, 'Borracharia');
    INSERT INTO equipes(id, setor) VALUES(5, 'Laternagem');

    INSERT INTO mecanicos(id, equipe_id,nome, COD, endereco ) VALUES(1, 1, 'Adalberto', 'AFGSA46542', 'Bem perto');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(2, 1, 'Adalberto', 'Mecânico Geral', "LPSAD44", 'Bem perto 2');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(3, 3, 'Gilberto', 'Elétrico', "ASJKDDASWJ", 'Bem perto 3');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(4, 4, 'Augusto Adalberto', 'Borracheiro', "MWCsa44", 'Bem perto 4');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(5, 1, 'Elicinaldo', 'Mecânico Geral', "ASjkasd541", 'Bem perto 4');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(6, 5, 'Jose', 'Lanternagem', "454asdd", 'Bem perto 5');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(7, 2, 'Amanda', 'Mecânico Geral', "AHAKD5454vg", 'Bem perto 9');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(8, 2, 'Samara', 'Mecânico Geral', "ASDÒFD5454", 'Bem perto 4');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(9, 4, 'Eduardo', 'Borracheiro', "AJUH5454", 'Bem perto 8');
    INSERT INTO mecanicos(id, equipe_id,nome, especialidade, COD, endereco ) VALUES(10, 3, 'Alessandra', 'Elétrico', 'PPKSDF5', 'Bem perto 10');
    

    INSERT INTO servicos(id, nome, valor) VALUES(1, 'Avaliação Geral', 50.0);
    INSERT INTO servicos(id, nome, valor) VALUES(2, 'Troca de Óleo', 25.0);
    INSERT INTO servicos(id, nome, valor) VALUES(3, 'Manutenção em Pneu', 50.0);
    INSERT INTO servicos(id, nome, valor) VALUES(4, 'Troca de peça', 100.0);
    INSERT INTO servicos(id, nome, valor) VALUES(5, 'Desamassar', 250.0);

    INSERT INTO pecas(id, nome, valor) VALUES(1, 'Pneu', 600.0);   
    INSERT INTO pecas(id, nome, valor) VALUES(2, 'Farol', 125.0);   
    INSERT INTO pecas(id, nome, valor) VALUES(3, 'Oleo 500ml', 14.5);   
    INSERT INTO pecas(id, nome, valor) VALUES(4, 'Injeção Eletrica', 600.0);   
    INSERT INTO pecas(id, nome, valor) VALUES(5, 'Lampada 30w', 15.0);   

    #OS 1
    INSERT INTO ordens_servicos(id, data_prevista, data_entregue, status, equipe_id, cliente_veiculo_id, tipo) 
        VALUES( 1, '2022-10-10', NULL, 'Pendente Avaliacao', 1, 1, 'Revisão' );
    INSERT INTO pecas_os(id, peca_id, os_cod, qtde) VALUES(1, 3, 1, 1);
    INSERT INTO servico_os(id, servico_id, os_cod ) VALUES(1, 2, 1);
    UPDATE ordens_servicos AS os_1
     SET os_1.valor = (
         SELECT SUM( s.valor ) FROM servico_os AS s_os 
         	INNER JOIN servicos as s ON s.id = s_os.servico_id
            GROUP BY s_os.os_cod HAVING s_os.os_cod = 1 ) + (
         SELECT SUM( p.valor * p_os.qtde ) FROM pecas_os AS p_os 
         	INNER JOIN pecas as p ON p.id = p_os.peca_id
            GROUP BY p_os.os_cod HAVING p_os.os_cod = 1
        ), 
     os_1.status = 'Aguardando aprovação'
     WHERE os_1.id = 1;
    #OS 2
    INSERT INTO ordens_servicos(id, data_prevista, data_entregue, status, equipe_id, cliente_veiculo_id) VALUES( 2, '2022-10-12', NULL, 'Pendente Avaliacao', 1, 1 );
    INSERT INTO pecas_os(id, peca_id, os_cod, qtde) VALUES(2, 2, 2, 2);
    INSERT INTO pecas_os(id, peca_id, os_cod, qtde) VALUES(3, 5, 2, 2);
    INSERT INTO servico_os(id, servico_id, os_cod ) VALUES(2, 4, 2);

    UPDATE ordens_servicos AS os_2
     SET os_2.valor = (
         SELECT SUM( s.valor ) FROM servico_os AS s_os 
         	INNER JOIN servicos as s ON s.id = s_os.servico_id
            GROUP BY s_os.os_cod HAVING s_os.os_cod = 2 ) + (
         SELECT SUM( p.valor * p_os.qtde ) FROM pecas_os AS p_os 
         	INNER JOIN pecas as p ON p.id = p_os.peca_id
            GROUP BY p_os.os_cod HAVING p_os.os_cod = 2
        ), 
     os_2.status = 'Concluída', os_2.data_entregue = '2022-10-11 17:35:00'
     WHERE os_2.id = 2;



  IF erro_sql = FALSE THEN
    COMMIT;
    SELECT 'Transação efetivada com sucesso.' AS Resultado;
  ELSE
    ROLLBACK;
    SELECT 'Erro na transação' AS Resultado;
  END IF;
END//
DELIMITER ;

CALL insere_dados();