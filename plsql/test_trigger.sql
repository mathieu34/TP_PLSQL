SELECT isbn, nb_notes, note_moyenne
FROM BOOKS
WHERE isbn = '0195153448';

INSERT INTO RATINGS (user_id, isbn, book_rating)
VALUES (7, '0195153448', 5);

SELECT isbn, nb_notes, note_moyenne
FROM BOOKS
WHERE isbn = '0195153448';
