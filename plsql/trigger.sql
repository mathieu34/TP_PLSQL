CREATE OR REPLACE TRIGGER trg_update_note_moyenne
AFTER INSERT OR UPDATE ON RATINGS
FOR EACH ROW
DECLARE
    v_nb_notes     BOOKS.nb_notes%TYPE;
    v_note_moyenne BOOKS.note_moyenne%TYPE;
BEGIN
    -- On récupère les valeurs actuelles sur le livre
    SELECT NVL(nb_notes, 0),
           NVL(note_moyenne, 0)
    INTO v_nb_notes, v_note_moyenne
    FROM BOOKS
    WHERE isbn = :NEW.isbn
    FOR UPDATE;

    IF INSERTING THEN
        -- Nouveau rating : on ajoute la note et on incrémente le compteur
        v_note_moyenne := (v_note_moyenne * v_nb_notes + :NEW.book_rating)
                          / (v_nb_notes + 1);
        v_nb_notes := v_nb_notes + 1;

    ELSIF UPDATING THEN
        -- On modifie une note existante : on retire l’ancienne, on ajoute la nouvelle
        IF v_nb_notes = 0 THEN
            -- Cas de sécurité (normalement n'arrive pas)
            v_note_moyenne := :NEW.book_rating;
            v_nb_notes := 1;
        ELSE
            v_note_moyenne := (v_note_moyenne * v_nb_notes
                               - :OLD.book_rating
                               + :NEW.book_rating)
                              / v_nb_notes;
        END IF;
    END IF;

    -- Mise à jour de BOOKS avec les nouvelles valeurs
    UPDATE BOOKS
    SET note_moyenne = v_note_moyenne,
        nb_notes     = v_nb_notes
    WHERE isbn = :NEW.isbn;
END;
/


