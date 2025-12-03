/*CREATE TABLE RATINGS (
    USER_ID NUMBER NOT NULL,
    ISBN VARCHAR2(50) NOT NULL,
    BOOK_RATING NUMBER,
    CONSTRAINT RATINGS_PK PRIMARY KEY (USER_ID, ISBN),
    CONSTRAINT RATINGS_FK_USER FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    CONSTRAINT RATINGS_FK_BOOK FOREIGN KEY (ISBN) REFERENCES BOOKS(ISBN)
);
*/


/*
CREATE TABLE BOOKS (
    ISBN VARCHAR2(50) PRIMARY KEY,
    BOOK_TITLE VARCHAR2(500),
    BOOK_AUTHOR VARCHAR2(200),
    YEAR_OF_PUBLICATION NUMBER,
    PUBLISHER VARCHAR2(200),
    IMAGE_URL_S VARCHAR2(500),
    IMAGE_URL_M VARCHAR2(500),
    IMAGE_URL_L VARCHAR2(500)
);
*/


CREATE OR REPLACE PROCEDURE noter_livre (
    p_user_id     IN NUMBER,
    p_isbn        IN VARCHAR2,
    p_book_rating IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    ------------------------------------------------------------------
    -- 1. Vérifier que l’utilisateur existe dans USERS
    ------------------------------------------------------------------
    SELECT COUNT(*)
    INTO v_count
    FROM USERS
    WHERE USER_ID = p_user_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Utilisateur inexistant.');
    END IF;


    ------------------------------------------------------------------
    -- 2. Vérifier que le livre existe dans BOOKS
    ------------------------------------------------------------------
    SELECT COUNT(*)
    INTO v_count
    FROM BOOKS
    WHERE ISBN = p_isbn;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Livre inexistant (ISBN inconnu).');
    END IF;


    ------------------------------------------------------------------
    -- 3. Insérer ou mettre à jour la note dans RATINGS
    --    Règle : on écrase l’ancienne note s’il y en a une
    ------------------------------------------------------------------
    MERGE INTO RATINGS r
    USING (
        SELECT p_user_id     AS user_id,
               p_isbn        AS isbn,
               p_book_rating AS book_rating
        FROM dual
    ) src
    ON (r.user_id = src.user_id AND r.isbn = src.isbn)
    WHEN MATCHED THEN
        UPDATE SET r.book_rating = src.book_rating
    WHEN NOT MATCHED THEN
        INSERT (user_id, isbn, book_rating)
        VALUES (src.user_id, src.isbn, src.book_rating);

END noter_livre;
/

