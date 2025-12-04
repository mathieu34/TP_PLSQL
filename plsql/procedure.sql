CREATE OR REPLACE PROCEDURE noter_livre (
    p_id_adherent   IN NUMBER,
    p_isbn          IN VARCHAR2,
    p_book_rating   IN NUMBER
) IS
    v_count NUMBER;
BEGIN
    ------------------------------------------------------------------
    -- 1. Vérifier que l’usager existe
    ------------------------------------------------------------------
    SELECT COUNT(*)
    INTO v_count
    FROM adherent
    WHERE id_adherent = p_id_adherent;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Usager inexistant (id_adherent inconnu).');
    END IF;

    ------------------------------------------------------------------
    -- 2. Vérifier que le livre existe
    ------------------------------------------------------------------
    SELECT COUNT(*)
    INTO v_count
    FROM livre
    WHERE isbn = p_isbn;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Livre inexistant (ISBN inconnu).');
    END IF;

    ------------------------------------------------------------------
    -- 3. Insérer ou mettre à jour la note (on écrase si déjà existante)
    ------------------------------------------------------------------
    MERGE INTO ratings r
    USING (
        SELECT p_id_adherent AS id_adherent,
               p_isbn        AS isbn,
               p_book_rating AS book_rating
        FROM dual
    ) src
    ON (r.id_adherent = src.id_adherent AND r.isbn = src.isbn)
    WHEN MATCHED THEN
        UPDATE SET r.book_rating  = src.book_rating,
                   r.date_notation = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (id_adherent, isbn, book_rating, date_notation)
        VALUES (src.id_adherent, src.isbn, src.book_rating, SYSDATE);

END noter_livre;
/
