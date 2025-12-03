--Meilleure note donnée dans RATINGS

CREATE OR REPLACE FUNCTION get_meilleure_note
RETURN NUMBER
IS
    v_max NUMBER;
BEGIN
    SELECT MAX(book_rating)
    INTO v_max
    FROM ratings;

    RETURN v_max;
END;
/
