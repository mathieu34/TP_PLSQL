CREATE OR REPLACE PACKAGE pkg_global IS

    ---------------------------------------------------------------------
    -- 1. Procédure métier : noter un livre
    ---------------------------------------------------------------------
    PROCEDURE noter_livre (
        p_user_id     IN NUMBER,
        p_isbn        IN VARCHAR2,
        p_rating      IN NUMBER
    );

    ---------------------------------------------------------------------
    -- 2. Statistiques globales
    ---------------------------------------------------------------------

    -- Âge moyen des utilisateurs ayant noté au moins un livre
    FUNCTION get_age_moyen
    RETURN NUMBER;

    -- Année moyenne de publication des livres
    FUNCTION get_moyenne_annee_publication
    RETURN NUMBER;

    -- Note moyenne d’un livre donné
    FUNCTION get_note_moyenne_livre (
        p_isbn IN VARCHAR2
    ) RETURN NUMBER;

    -- Meilleure note donnée dans RATINGS (MAX)
    FUNCTION get_meilleure_note
    RETURN NUMBER;

END pkg_global;
/
