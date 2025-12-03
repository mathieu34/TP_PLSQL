--Année moyenne de publication des livres

CREATE OR REPLACE FUNCTION get_moyenne_annee_publication
RETURN NUMBER
IS
    v_year NUMBER;
BEGIN
    SELECT AVG(year_of_publication)
    INTO v_year
    FROM books;

    RETURN v_year;
END;
/
