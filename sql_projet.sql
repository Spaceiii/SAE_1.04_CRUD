ROP TABLE IF EXISTS
    peut_animer, dirige, est_utilise, est_inscrit, Evaluation, Seance,
    Embauche, Lieu, Profession, Materiel, Atelier, Participant, Animateur;

CREATE TABLE Animateur(
   id_animateur INT,
   nom_animateur VARCHAR(50) NOT NULL,
   tel_animateur VARCHAR(10),
   prenom_animateur VARCHAR(50),
   adresse_animateur VARCHAR(50),
   mail_animateur VARCHAR(50),
   PRIMARY KEY(id_animateur)
);

CREATE TABLE Participant(
   id_participant INT,
   prenom_participant VARCHAR(50),
   nom_participant VARCHAR(50),
   tel_participant VARCHAR(10),
   mail_participant VARCHAR(50),
   PRIMARY KEY(id_participant)
);

CREATE TABLE Atelier(
   code_atelier INT,
   libelle_atelier VARCHAR(50),
   PRIMARY KEY(code_atelier)
);

CREATE TABLE Materiel(
   id_materiel INT,
   libelle_materiel VARCHAR(50),
   PRIMARY KEY(id_materiel)
);

CREATE TABLE Profession(
   code_profession INT,
   libelle_profession VARCHAR(50),
   PRIMARY KEY(code_profession)
);

CREATE TABLE Lieu(
   id_lieu INT,
   nom_lieu VARCHAR(50),
   ville_lieu VARCHAR(50),
   adresse_lieu VARCHAR(50),
   PRIMARY KEY(id_lieu)
);

CREATE TABLE Embauche(
   id_embauche INT,
   date_embauche DATE,
   salaire DECIMAL(15,2),
   code_profession INT NOT NULL,
   id_animateur INT NOT NULL,
   PRIMARY KEY(id_embauche),
   FOREIGN KEY(code_profession) REFERENCES Profession(code_profession),
   FOREIGN KEY(id_animateur) REFERENCES Animateur(id_animateur)
);

CREATE TABLE Seance(
   id_seance INT,
   date_heure_seance DATETIME NOT NULL,
   libelle_seance VARCHAR(50),
   nombre_places INT,
   tarif DECIMAL(6,2),
   id_lieu INT,
   code_atelier INT NOT NULL,
   PRIMARY KEY(id_seance),
   FOREIGN KEY(id_lieu) REFERENCES Lieu(id_lieu),
   FOREIGN KEY(code_atelier) REFERENCES Atelier(code_atelier)
);

CREATE TABLE Evaluation(
   id_evaluation INT,
   note_animation SMALLINT,
   note_qualite SMALLINT,
   note_interet SMALLINT,
   commentaire TEXT,
   id_seance INT NOT NULL,
   id_participant INT NOT NULL,
   PRIMARY KEY(id_evaluation),
   FOREIGN KEY(id_seance) REFERENCES Seance(id_seance),
   FOREIGN KEY(id_participant) REFERENCES Participant(id_participant)
);

CREATE TABLE est_inscrit(
   id_seance INT,
   id_participant INT,
   present BOOLEAN,
   PRIMARY KEY(id_seance, id_participant),
   FOREIGN KEY(id_seance) REFERENCES Seance(id_seance),
   FOREIGN KEY(id_participant) REFERENCES Participant(id_participant)
);

CREATE TABLE est_utilise(
   id_seance INT,
   id_materiel INT,
   PRIMARY KEY(id_seance, id_materiel),
   FOREIGN KEY(id_seance) REFERENCES Seance(id_seance),
   FOREIGN KEY(id_materiel) REFERENCES Materiel(id_materiel)
);



CREATE TABLE dirige(
   id_animateur INT,
   id_seance INT,
   PRIMARY KEY(id_animateur, id_seance),
   FOREIGN KEY(id_animateur) REFERENCES Animateur(id_animateur),
   FOREIGN KEY(id_seance) REFERENCES Seance(id_seance)
);

CREATE TABLE peut_animer(
   id_animateur INT,
   code_atelier INT,
   PRIMARY KEY(id_animateur, code_atelier),
   FOREIGN KEY(id_animateur) REFERENCES Animateur(id_animateur),
   FOREIGN KEY(code_atelier) REFERENCES Atelier(code_atelier)
);

-- Insertion dans la table Animateur
INSERT INTO Animateur (id_animateur, nom_animateur, tel_animateur, prenom_animateur, adresse_animateur, mail_animateur) VALUES
(1, 'Durand', '0123456789', 'Julie', '123 rue de l’Écologie', 'julie.durand@ecologie.org'),
(2, 'Petit', '0123456790', 'Thomas', '124 rue de l’Écologie', 'thomas.petit@ecologie.org'),
(3, 'Martin', '0123456791', 'Sophie', '125 rue de l’Écologie', 'sophie.martin@ecologie.org'),
(4, 'Bernard', '0123456792', 'Lucas', '126 rue de l’Écologie', 'lucas.bernard@ecologie.org'),
(5, 'Dubois', '0123456793', 'Émilie', '127 rue de l’Écologie', 'emilie.dubois@ecologie.org');

-- Insertion dans la table Participant
INSERT INTO Participant (id_participant, prenom_participant, nom_participant, tel_participant, mail_participant) VALUES
(1, 'Maxime', 'Lefevre', '0987654321', 'maxime.lefevre@exemple.com'),
(2, 'Claire', 'Simon', '0987654322', 'claire.simon@exemple.com'),
(3, 'Nicolas', 'Michel', '0987654323', 'nicolas.michel@exemple.com'),
(4, 'Sarah', 'Leroy', '0987654324', 'sarah.leroy@exemple.com'),
(5, 'Alexandre', 'Roux', '0987654325', 'alexandre.roux@exemple.com');

-- Insertion dans la table Atelier
INSERT INTO Atelier (code_atelier, libelle_atelier) VALUES
(1, 'Recyclage 101'),
(2, 'Compostage domestique'),
(3, 'Jardinage urbain'),
(4, 'Réduction des déchets'),
(5, 'Atelier DIY produits ménagers');

-- Insertion dans la table Materiel
INSERT INTO Materiel (id_materiel, libelle_materiel) VALUES
(1, 'Pelle'),
(2, 'Seau de compost'),
(3, 'Kit de recyclage'),
(4, 'Sacs réutilisables'),
(5, 'Éponges écologiques');

-- Insertion dans la table Profession
INSERT INTO Profession (code_profession, libelle_profession) VALUES
(1, 'Éducateur environnemental'),
(2, 'Chercheur en écologie'),
(3, 'Coordinateur de projets'),
(4, 'Agent de développement durable'),
(5, 'Animateur nature');

-- Insertion dans la table Lieu
INSERT INTO Lieu (id_lieu, nom_lieu, ville_lieu, adresse_lieu) VALUES
(1, 'La Maison Verte', 'Écoville', '1 place de la Terre'),
(2, 'Le Jardin Partagé', 'Écoville', '2 avenue de la Prairie'),
(3, 'Centre Éco-Citoyen', 'Écoville', '3 boulevard des Fleurs'),
(4, 'Le Parc Bio', 'Écoville', '4 rue du Développement Durable'),
(5, 'La Ferme Urbaine', 'Écoville', '5 chemin du Compost');

-- Insertion dans la table Embauche
INSERT INTO Embauche (id_embauche, date_embauche, salaire, code_profession, id_animateur) VALUES
(1, '2023-01-10', 2500.00, 1, 1),
(2, '2023-01-11', 2600.00, 2, 2),
(3, '2023-01-12', 2700.00, 3, 3),
(4, '2023-01-13', 2800.00, 4, 4),
(5, '2023-01-14', 2900.00, 5, 5);

-- Insertion dans la table Seance
INSERT INTO Seance (id_seance, date_heure_seance, libelle_seance, nombre_places, tarif, id_lieu, code_atelier) VALUES
(1, '2023-06-15 10:00', 'Initiation au compostage', 20, 15.00, 1, 2),
(2, '2023-06-16 14:00', 'Atelier recyclage avancé', 15, 20.00, 2, 1),
(3, '2023-06-17 09:00', 'Jardinage pour débutants', 10, 10.00, 3, 3),
(4, '2023-06-18 11:00', 'Zéro déchet', 25, 25.00, 4, 4),
(5, '2023-06-19 13:00', 'Fabrication de produits ménagers', 30, 30.00, 5, 5);

-- Insertion dans la table Evaluation
INSERT INTO Evaluation (id_evaluation, note_animation, note_qualite, note_interet, commentaire, id_seance, id_participant) VALUES
(1, 4, 5, 5, 'Très instructif et amusant', 1, 1),
(2, 3, 4, 4, 'Intéressant mais un peu court', 2, 2),
(3, 5, 5, 5, 'Parfait pour les débutants', 3, 3),
(4, 5, 4, 4, 'De bonnes idées à reprendre', 4, 4),
(5, 4, 4, 5, 'Atelier créatif et utile', 5, 5);

-- Insertion dans la table est_inscrit
INSERT INTO est_inscrit (id_seance, id_participant, present) VALUES
(1, 1, TRUE),
(1, 2, TRUE),
(1, 3, FALSE),
(2, 4, TRUE),
(2, 5, TRUE);

-- Insertion dans la table est_utilise
INSERT INTO est_utilise (id_seance, id_materiel) VALUES
(1, 2),
(2, 3),
(3, 1),
(4, 4),
(5, 5);

-- Insertion dans la table dirige
INSERT INTO dirige (id_animateur, id_seance) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insertion dans la table peut_animer
INSERT INTO peut_animer (id_animateur, code_atelier) VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 4),
(5, 5);
