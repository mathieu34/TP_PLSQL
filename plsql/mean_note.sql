--note moyenne d'un livre donné

CREATE OR REPLACE FUNCTION get_note_moyenne_livre(p_isbn IN VARCHAR2)
RETURN NUMBER
IS
    v_avg NUMBER;
BEGIN
    SELECT AVG(book_rating)
    INTO v_avg
    FROM ratings
    WHERE isbn = p_isbn;

    RETURN v_avg;
END;
/
