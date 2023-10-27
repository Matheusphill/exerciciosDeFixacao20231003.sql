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

