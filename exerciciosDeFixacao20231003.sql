DELIMITER //
CREATE FUNCTION total_livros_por_genero(genero_nome VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE total INT;
    SET total = 0;
    
    DECLARE done INT DEFAULT 0;
    DECLARE genero_id INT;
    
    DECLARE cur CURSOR FOR 
        SELECT id FROM Genero WHERE nome_genero = genero_nome;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO genero_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SELECT COUNT(*) INTO total FROM Livro WHERE id_genero = genero_id;
    END LOOP;
    
    CLOSE cur;
    
    RETURN total;
END//
DELIMITER ;

SELECT total_livros_por_genero('História');




DELIMITER //
CREATE FUNCTION listar_livros_por_autor(
    primeiro_nome_autor VARCHAR(255),
    ultimo_nome_autor VARCHAR(255)
)
RETURNS VARCHAR(255)
BEGIN
    DECLARE lista_de_livros VARCHAR(4000);
    SET lista_de_livros = '';
    
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE livro_titulo VARCHAR(255);
    
    DECLARE cur CURSOR FOR 
        SELECT LA.id_livro, L.titulo
        FROM Livro_Autor AS LA
        INNER JOIN Livro AS L ON LA.id_livro = L.id
        INNER JOIN Autor AS A ON LA.id_autor = A.id
        WHERE A.primeiro_nome = primeiro_nome_autor
        AND A.ultimo_nome = ultimo_nome_autor;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO livro_id, livro_titulo;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET lista_de_livros = CONCAT(lista_de_livros, livro_titulo, ', ');
    END LOOP;
    
    CLOSE cur;
    
    SET lista_de_livros = SUBSTRING(lista_de_livros, 1, LENGTH(lista_de_livros) - 2);
    
    RETURN lista_de_livros;
END//
DELIMITER ;
SELECT listar_livros_por_autor('Maria', 'Fernandes');




DELIMITER //
CREATE FUNCTION atualizar_resumos()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE livro_resumo TEXT;
    
    DECLARE cur CURSOR FOR 
        SELECT id, resumo FROM Livro;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    update_loop: LOOP
        FETCH cur INTO livro_id, livro_resumo;
        IF done THEN
            LEAVE update_loop;
        END IF;
        
        
        SET livro_resumo = CONCAT(livro_resumo, ' é um bom livro');
        
        UPDATE Livro SET resumo = livro_resumo WHERE id = livro_id;
    END LOOP;
    
    CLOSE cur;
END//
DELIMITER ;
CALL atualizar_resumos();