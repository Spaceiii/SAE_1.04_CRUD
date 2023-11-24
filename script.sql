DROP TABLE peut_animer, dirige, est_utilise, est_inscrit, Evaluation, Seance, Embauche, Lieu, Profession, Materiel, Atelier, Participant, Animateur;

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
   note_animation BYTE,
   note_qualite BYTE,
   note_interet BYTE,
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
   present LOGICAL,
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

