📘 TP Oracle PL/SQL — Gestion des Notations de Livres

🎯 Objectif du TP

Ce projet implémente un mini-système de gestion de notation de livres en PL/SQL.
Il couvre les points suivants :

Création d’un modèle relationnel (LIVRE, ADHERENT, NOTATION)

Développement d’une procédure PL/SQL permettant à un usager de noter un livre

Vérifications métier :

Usager existe

Livre existe

L’usager a déjà noté le livre → mise à jour de la note (règle choisie)

Déclencheur (trigger) permettant la mise à jour automatique :

de la note moyenne

du nombre de notes

dans la table LIVRE

Ce TP répond aux exigences du sujet :

"La procédure gère la notation d’un livre et le trigger met à jour la note moyenne."

├── 📁 schema/

│   ├── schema                       → Script SQL de création des tables

│   └── MCD                          → Diagramme MCD (Looping MCD)

├── 📁 data/                

│   ├── new_csv.csv                  →  CSV originaux filtrés (Books, Ratings, Users) pour avoir 100 lignes environ

│   ├── Books.xlsx                   → Dataset 

│   ├── Ratings.xlsx                 → Dataset 

│   ├──  Users.xlsx                   → Dataset 

├── 📁 plsql/

│   ├── procedure.sql                → Procédure `noter\_livre`

│   ├── test\_procedure.sql           → Script de test procédure

│   ├── best\_note.sql                → Fonction meilleure note

│   ├── Mean\_age.sql                 → Fonction âge moyen

│   ├── mean\_year.sql                → Fonction année moyenne

│   ├── mean\_note.sql                → Fonction moyenne des notes

│   ├── trigger.sql                   → Trigger mise à jour automatique

│   ├── test\_trigger.sql             → Script de test du trigger 

│   ├─ package\_spec.sql              → Package Bibliotheque (spec)

│   └── package\_body.sql             → Package Bibliotheque (body)

└── README.md                  



🗄️ 1. Modèle relationnel

Le modèle contient 3 tables :

Table LIVRE

Stocke les informations d’un livre + statistiques de notation.

Colonne	Description
isbn (PK)	Identifiant du livre
book\_title	Titre
book\_author	Auteur
year\_of\_publication	Année
publisher	Éditeur
note\_moyenne	Moyenne des notes (gérée par trigger)
nb\_notes	Nombre total de notes

Table USERS

Représente les usagers du système.

Colonne	Description
id\_user (PK)	Identifiant
location	Localisation
age	Âge

Table RATINGS

Stocke les notes données par les usagers.

Colonne	Description
id\_user (FK)	Usager
isbn (FK)	Livre
book\_rating	Note
date\_rating	Date de la notation

Clé primaire composite :

(id_user, isbn)



→ Un usager ne peut noter un livre qu’une seule fois.

🧩 2. Procédure PL/SQL : noter\_livre

📌 Fichier : noter\_livre.sql

Cette procédure :

Vérifie que l’usager existe

Vérifie que le livre existe

Vérifie si l’usager a déjà noté le livre :

Oui → mise à jour de la note

Non → insertion

Insère ou met à jour la ligne dans NOTATION

Règle métier choisie :

Si l’usager avait déjà noté le livre, la nouvelle note écrase l’ancienne.

Elle utilise la commande MERGE pour gérer insertion + mise à jour proprement.

🔁 3. Trigger : mise à jour de la moyenne

📌 Fichier : trg\_update\_note\_moyenne.sql

Ce trigger se déclenche :

AFTER INSERT OR UPDATE ON notation
FOR EACH ROW



Il recalcule automatiquement :

la moyenne des notes (AVG)

le nombre total de notes (COUNT)

Puis met à jour la table LIVRE.

Ce mécanisme garantit que la colonne note\_moyenne est toujours correcte sans intervention humaine.



📊 4. Fonctions de statistiques globales



Quatre fonctions PL/SQL ont été développées :

* get\_age\_moyen()  

→ Retourne l’âge moyen des utilisateurs ayant noté au moins un livre.

* get\_moyenne\_annee\_publication()  

→ Retourne l’année moyenne de publication des livres.

* get\_meilleure\_note()  

→ Retourne la meilleure note attribuée dans RATINGS.

* get\_note\_moyenne\_livre

→ Retourne la note moyenne d'un livre donné



Ces fonctions sont indépendantes du trigger et calculent des statistiques globales.



✅ 5. Ajout du Package PL/SQL (spec + body)



* Package Specification

→ Contient l’interface :

\- Procédure noter\_livre

\- Fonctions statistiques



* Package Body

→ Contient l’implémentation :

\- Code complet de la procédure

\- Code des 4 fonctions



* Utilité

\- Organisation claire

\- Encapsulation des règles métier

\- Centralisation de l’API Bibliothèque





🚀 Conclusion

Ce TP démontre :

la capacité à concevoir un modèle relationnel simple

l’écriture de procédures PL/SQL robustes

l’utilisation appropriée des triggers

une bonne maîtrise du SQL Oracle dans VS Code

Il répond parfaitement au cahier des charges demandé.

👥 Travail collaboratif 

Mathieu PONNOU → MCD/Schéma + troncature des tables + tests (Procédure PL/SQL, trigger et fonctions) + création du package PL/SQL + README 

Amos CLEGBAZA → Schéma + Procédure PL/SQL + triggers + README + création du package PL/SQL

Meddy GARCIA → Documentation + statistiques de notation (SQL)













