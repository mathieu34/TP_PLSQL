-- Âge moyen des personnes ayant noté au moins un livre
/*
CREATE OR REPLACE FUNCTION get_age_moyen
RETURN NUMBER
IS
    v_age NUMBER;
BEGIN
    SELECT AVG(age)
    INTO v_age
    FROM users
    WHERE user_id IN (
        SELECT DISTINCT user_id
        FROM ratings
    );

    RETURN v_age;
END;
/
*/

SELECT get_age_moyen FROM dual;