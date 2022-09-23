USE oficina;

#quantos mecânicos há em cada equipe?
SELECT COUNT(m.id) AS qtde_mecanicos, e.setor FROM equipes AS e 
INNER JOIN mecanicos AS m ON m.equipe_id = e.id GROUP BY m.equipe_id ORDER BY e.setor ASC;

#quantos carros cada cliente já fez levou para a oficina?
SELECT c.nome AS cliente, COUNT( v.id ) AS qtde, GROUP_CONCAT( numero_placa ) AS numero_placas FROM clientes_veiculos as cv
INNER JOIN clientes AS c ON c.id = cv.cliente_id
INNER JOIN veiculos AS v ON v.id = cv.veiculo_id
GROUP BY cv.cliente_id;
