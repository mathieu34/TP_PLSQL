CREATE OR REPLACE PROCEDURE noter_livre (
    p_user_id      IN NUMBER,
    p_isbn         IN VARCHAR2,
    p_book_rating  IN NUMBER
) IS
    v_count NUMBER;
BEGIN
    ------------------------------------------------------------------
    -- 1. Vérifier que l’usager existe
    ------------------------------------------------------------------
    SELECT COUNT(*)
    INTO v_count
    FROM users
    WHERE user_id = p_user_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Usager inexistant (user_id inconnu).');
    END IF;

    ------------------------------------------------------------------
    -- 2. Vérifier que le livre existe
    ------------------------------------------------------------------
    SELECT COUNT(*)
    INTO v_count
    FROM books
    WHERE isbn = p_isbn;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Livre inexistant (ISBN inconnu).');
    END IF;

    ------------------------------------------------------------------
    -- 3. Insérer ou mettre à jour la note (on écrase si déjà existante)
    ------------------------------------------------------------------
    MERGE INTO ratings r
    USING (
        SELECT 
            p_user_id     AS user_id,
            p_isbn        AS isbn,
            p_book_rating AS book_rating
        FROM dual
    ) src
    ON (r.user_id = src.user_id AND r.isbn = src.isbn)
    WHEN MATCHED THEN
        UPDATE SET 
            r.book_rating = src.book_rating
    WHEN NOT MATCHED THEN
        INSERT (user_id, isbn, book_rating)
        VALUES (src.user_id, src.isbn, src.book_rating);

END noter_livre;
/
