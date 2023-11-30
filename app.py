#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
import pymysql.cursors
import os
from dotenv import load_dotenv


app = Flask(__name__)
app.secret_key = 'une cle(token) : grain de sel(any random string)'


def get_db():
    load_dotenv()

    if 'db' not in g:
        g.db = pymysql.connect(
            host=os.environ.get("HOST"),
            user=os.environ.get("LOGIN"),
            password=os.environ.get("PASSWORD"),
            database=os.environ.get("DATABASE"),
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor
        )
    return g.db


@app.teardown_appcontext
def teardown_db(exception):
    db = g.pop('db', None)
    if db is not None:
        db.close()


@app.route("/")
def show_accueil():
    cursor = get_db().cursor()
    sql = '''
        SELECT libelle_seance, AVG(tarif) AS prix_moyen
        FROM Seance
        GROUP BY libelle_seance; 
    '''
    cursor.execute(sql)
    tarifs = cursor.fetchall()
    return render_template("index.html", tarifs=tarifs)


@app.route("/seance/show")
def show_seance():
    cursor = get_db().cursor()
    sql = '''
    SELECT Seance.*, Seance.tarif, Lieu.nom_lieu, Lieu.ville_lieu, Atelier.libelle_atelier  
    FROM Seance
    JOIN Lieu
    ON Lieu.id_lieu = Seance.id_lieu
    JOIN Atelier
    ON Atelier.code_atelier = Seance.code_atelier;
    '''
    cursor.execute(sql)
    seances = cursor.fetchall()
    return render_template("seance/show_seance.html", seances=seances)


@app.route("/seance/edit", methods=["GET"])
def edit_seance():
    identifiant = int(request.args.get('id', '0'))
    cursor = get_db().cursor()
    sql = f'''
        SELECT Seance.*, Lieu.nom_lieu, Lieu.ville_lieu, Atelier.libelle_atelier
        FROM Seance
        JOIN Lieu
        ON Lieu.id_lieu = Seance.id_lieu
        JOIN Atelier
        ON Atelier.code_atelier = Seance.code_atelier
        WHERE Seance.id_seance = {identifiant};
        '''
    cursor.execute(sql)
    seance = cursor.fetchall()

    sql = f'''
            SELECT Atelier.libelle_atelier, Atelier.code_atelier
            FROM Atelier;
            '''
    cursor.execute(sql)
    ateliers = cursor.fetchall()

    sql = f'''
                SELECT Lieu.nom_lieu, Lieu.id_lieu
                FROM Lieu;
                '''
    cursor.execute(sql)
    lieux = cursor.fetchall()
    return render_template("seance/edit_seance.html", seance=seance, ateliers=ateliers, lieux=lieux)


@app.route("/seance/edit", methods=["POST"])
def edit_seance_post():
    libelle_seance = request.form.get("libelle_seance")
    date_seance = request.form.get("date_seance")
    place_seance = int(request.form.get("place_seance"))
    tarif = float(request.form.get("tarif"))
    code_atelier = int(request.form.get("code_atelier"))
    id_lieu = int(request.form.get("id_lieu"))
    id_seance = int(request.form.get("id_seance"))
    cursor = get_db().cursor()
    sql = '''
    UPDATE Seance
    SET
        libelle_seance = %s,
        date_heure_seance = %s,
        nombre_places = %s,
        tarif = %s,
        code_atelier = %s,
        id_lieu = %s
    WHERE Seance.id_seance = %s;
    '''
    cursor.execute(sql, (libelle_seance, date_seance, place_seance, tarif, code_atelier, id_lieu, id_seance))
    get_db().commit()
    flash(f"Séance {libelle_seance} éditée avec succès", "sucess")
    return redirect("/seance/show")


@app.route("/seance/delete", methods=["GET"])
def delete_seance():
    identifiant = int(request.args.get('id', '0'))
    cursor = get_db().cursor()
    sql = '''
    SELECT Seance.libelle_seance
    FROM Seance
    WHERE Seance.id_seance = %s;
    '''
    cursor.execute(sql, tuple([identifiant]))
    seance = cursor.fetchone()
    sql = '''
    DELETE FROM Seance
    WHERE Seance.id_seance = %s
    '''
    cursor.execute(sql, identifiant)
    get_db().commit()
    flash(f"Séance \"{seance['libelle_seance']}\" supprimée avec succès", "danger")
    return redirect("/seance/show")


@app.route("/embauche/show")
def show_embauche():
    cursor = get_db().cursor()
    sql = '''
    SELECT Embauche.*, Profession.code_profession, Animateur.id_animateur
    FROM Embauche
    JOIN Profession
    ON Embauche.code_profession = Profession.code_profession
    JOIN Animateur
    ON Embauche.id_animateur = Animateur.id_animateur
    ;
    '''
    cursor.execute(sql)
    embauches = cursor.fetchone()
    return render_template("embauche/show_embauche.html", embauches=embauches)


@app.route("/seance/add", methods=["GET"])
def add_seance():
    cursor = get_db().cursor()
    sql = f'''
    SELECT Atelier.libelle_atelier, Atelier.code_atelier
    FROM Atelier;
    '''
    cursor.execute(sql)
    ateliers = cursor.fetchall()

    sql = f'''
    SELECT Lieu.nom_lieu, Lieu.id_lieu
    FROM Lieu;
    '''
    cursor.execute(sql)
    lieux = cursor.fetchall()
    return render_template("seance/add_seance.html", ateliers=ateliers, lieux=lieux)


@app.route("/seance/add", methods=["POST"])
def add_seance_post():
    cursor = get_db().cursor()
    sql = '''
    SELECT Seance.id_seance
    FROM Seance;
    '''
    cursor.execute(sql)
    ids = cursor.fetchall()
    id_max = max([x['id_seance'] for x in ids])
    libelle_seance = request.form.get("libelle_seance")
    date_seance = request.form.get("date_seance")
    place_seance = int(request.form.get("place_seance"))
    tarif = float(request.form.get("tarif"))
    code_atelier = int(request.form.get("code_atelier"))
    id_lieu = int(request.form.get("id_lieu"))
    sql = '''
    INSERT INTO Seance(id_seance, date_heure_seance, libelle_seance, nombre_places, tarif, id_lieu, code_atelier)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    '''
    cursor.execute(sql, (id_max+1, date_seance, libelle_seance, place_seance, tarif, id_lieu, code_atelier))
    get_db().commit()
    flash(f"Séance {libelle_seance} ajoutée avec succès", "sucess")
    return redirect("/seance/show")

@app.route("/evaluation/show")
def show_evaluation():
    cursor = get_db().cursor()
    sql = '''
    SELECT Seance.libelle_seance, Evaluation.*, Participant.prenom_participant, Participant.nom_participant
    FROM Evaluation
    JOIN Seance ON Evaluation.id_seance = Seance.id_seance
    JOIN Participant ON Evaluation.id_participant = Participant.id_participant
    ORDER BY Seance.libelle_seance
    '''
    cursor.execute(sql)
    evaluations = cursor.fetchall()

    # Regrouper les évaluations par séance
    evaluations_grouped = {}
    for evaluation in evaluations:
        seance = evaluation['libelle_seance']
        if seance not in evaluations_grouped:
            evaluations_grouped[seance] = []
        evaluations_grouped[seance].append(evaluation)

    return render_template("evaluation/show_evaluation.html", evaluations_grouped=evaluations_grouped)


@app.route("/evaluation/edit", methods=["GET"])
def edit_evaluation():
    id_evaluation = int(request.args.get('id', '0'))
    cursor = get_db().cursor()
    sql = '''
        SELECT Evaluation.*, Seance.libelle_seance, Participant.prenom_participant, Participant.nom_participant
        FROM Evaluation
        JOIN Seance ON Evaluation.id_seance = Seance.id_seance
        JOIN Participant ON Evaluation.id_participant = Participant.id_participant
        WHERE Evaluation.id_evaluation = %s;
        '''
    cursor.execute(sql, (id_evaluation,))
    evaluation = cursor.fetchone()

    return render_template("evaluation/edit_evaluation.html", evaluation=evaluation)


@app.route("/evaluation/edit", methods=["POST"])
def edit_evaluation_post():
    id_evaluation = int(request.form.get("id_evaluation"))
    note_animation = int(request.form.get("note_animation"))
    note_qualite = int(request.form.get("note_qualite"))
    note_interet = int(request.form.get("note_interet"))
    commentaire = request.form.get("commentaire")

    cursor = get_db().cursor()
    sql = '''
    UPDATE Evaluation
    SET
        note_animation = %s,
        note_qualite = %s,
        note_interet = %s,
        commentaire = %s
    WHERE id_evaluation = %s;
    '''
    cursor.execute(sql, (note_animation, note_qualite, note_interet, commentaire, id_evaluation))
    get_db().commit()

    return redirect("/evaluation/show")


@app.route("/evaluation/delete", methods=["GET"])
def delete_evaluation():
    id_evaluation = int(request.args.get('id', '0'))

    # Obtention du curseur pour exécuter des commandes SQL
    cursor = get_db().cursor()

    # Préparation de la requête SQL pour supprimer une évaluation spécifique
    sql = 'DELETE FROM Evaluation WHERE id_evaluation = %s;'

    # Exécution de la requête SQL avec le paramètre id_evaluation
    cursor.execute(sql, (id_evaluation,))

    # Validation de la transaction pour appliquer la suppression
    get_db().commit()

    # Redirection vers la page d'affichage des évaluations
    return redirect("/evaluation/show")

@app.route("/evaluation/add", methods=["GET"])
def add_evaluation():
    cursor = get_db().cursor()

    # Récupérer les séances
    cursor.execute("SELECT id_seance, libelle_seance FROM Seance;")
    seances = cursor.fetchall()

    # Récupérer les participants
    cursor.execute("SELECT id_participant, nom_participant FROM Participant;")
    participants = cursor.fetchall()

    return render_template("evaluation/add_evaluation.html", seances=seances, participants=participants)


@app.route("/evaluation/add", methods=["POST"])
def add_evaluation_post():
    cursor = get_db().cursor()

    # Récupérer l'ID maximal existant dans Evaluation
    cursor.execute("SELECT MAX(id_evaluation) as max_id FROM Evaluation;")
    max_id_result = cursor.fetchone()
    max_id = max_id_result['max_id'] if max_id_result['max_id'] is not None else 0

    # Collecter les données du formulaire
    id_seance = int(request.form.get("libelle_seance"))
    id_participant = int(request.form.get("nom_participant"))
    note_animation = int(request.form.get("note_animation"))
    note_qualite = int(request.form.get("note_qualite"))
    note_interet = int(request.form.get("note_interet"))
    commentaire = request.form.get("commentaire")

    # Préparer la requête SQL pour insérer une nouvelle évaluation
    sql = '''
    INSERT INTO Evaluation (id_evaluation, id_seance, id_participant, note_animation, note_qualite, note_interet, commentaire)
    VALUES (%s, %s, %s, %s, %s, %s, %s);
    '''
    cursor.execute(sql, (max_id + 1, id_seance, id_participant, note_animation, note_qualite, note_interet, commentaire))
    get_db().commit()

    return redirect("/evaluation/show")





if __name__ == '__main__':
    app.run()
