CREATE OR REPLACE PACKAGE BODY pkg_global IS

    ---------------------------------------------------------------------
    -- 1. PROCEDURE noter_livre
    ---------------------------------------------------------------------
    PROCEDURE noter_livre (
        p_user_id     IN NUMBER,
        p_isbn        IN VARCHAR2,
        p_rating      IN NUMBER
    ) IS
        v_count NUMBER;
    BEGIN
        ------------------------------------------------------------------
        -- Vérifier que l’utilisateur existe
        ------------------------------------------------------------------
        SELECT COUNT(*)
        INTO v_count
        FROM users
        WHERE user_id = p_user_id;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Usager inexistant : ' || p_user_id);
        END IF;

        ------------------------------------------------------------------
        -- Vérifier que le livre existe
        ------------------------------------------------------------------
        SELECT COUNT(*)
        INTO v_count
        FROM books
        WHERE isbn = p_isbn;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Livre inexistant : ' || p_isbn);
        END IF;

        ------------------------------------------------------------------
        -- Insérer ou mettre à jour la note
        ------------------------------------------------------------------
        MERGE INTO ratings r
        USING (
            SELECT p_user_id AS user_id,
                   p_isbn    AS isbn,
                   p_rating  AS rating
            FROM dual
        ) src
        ON (r.user_id = src.user_id AND r.isbn = src.isbn)
        WHEN MATCHED THEN
            UPDATE SET r.book_rating = src.rating
        WHEN NOT MATCHED THEN
            INSERT (user_id, isbn, book_rating)
            VALUES (src.user_id, src.isbn, src.rating);

    END noter_livre;



    ---------------------------------------------------------------------
    -- 2. get_age_moyen
    ---------------------------------------------------------------------
    FUNCTION get_age_moyen
    RETURN NUMBER
    IS
        v_age NUMBER;
    BEGIN
        SELECT AVG(age)
        INTO v_age
        FROM users
        WHERE user_id IN (SELECT DISTINCT user_id FROM ratings);

        RETURN v_age;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_age_moyen;



    ---------------------------------------------------------------------
    -- 3. get_moyenne_annee_publication
    ---------------------------------------------------------------------
    FUNCTION get_moyenne_annee_publication
    RETURN NUMBER
    IS
        v_year NUMBER;
    BEGIN
        SELECT AVG(year_of_publication)
        INTO v_year
        FROM books;

        RETURN v_year;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_moyenne_annee_publication;



    ---------------------------------------------------------------------
    -- 4. get_note_moyenne_livre
    ---------------------------------------------------------------------
    FUNCTION get_note_moyenne_livre (
        p_isbn IN VARCHAR2
    ) RETURN NUMBER
    IS
        v_avg NUMBER;
    BEGIN
        SELECT AVG(book_rating)
        INTO v_avg
        FROM ratings
        WHERE isbn = p_isbn;

        RETURN v_avg;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_note_moyenne_livre;



    ---------------------------------------------------------------------
    -- 5. get_meilleure_note
    -- (depuis best_note.sql)
    ---------------------------------------------------------------------
    FUNCTION get_meilleure_note
    RETURN NUMBER
    IS
        v_max NUMBER;
    BEGIN
        SELECT MAX(book_rating)
        INTO v_max
        FROM ratings;

        RETURN v_max;
    END get_meilleure_note;

END pkg_global;
/
