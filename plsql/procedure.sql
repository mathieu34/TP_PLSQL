CREATE OR REPLACE TRIGGER trg_update_note_moyenne
AFTER INSERT OR UPDATE ON notation
FOR EACH ROW
DECLARE
    v_avg   NUMBER;
    v_count NUMBER;
BEGIN
    -- Recalculer la moyenne et le nombre de notes pour ce livre
    SELECT AVG(book_rating),
           COUNT(*)
    INTO v_avg, v_count
    FROM notation
    WHERE isbn = :NEW.isbn;

    -- Mettre à jour la table LIVRE
    UPDATE livre
    SET note_moyenne = v_avg,
        nb_notes     = v_count
    WHERE isbn = :NEW.isbn;
END;

/
