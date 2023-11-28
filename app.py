#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
import pymysql.cursors
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.secret_key = 'une cle(token) : grain de sel(any random string)'


def get_db():
    if 'db' not in g:
        g.db = pymysql.connect(
            host="localhost",                 # à modifier
            user="root",                     # à modifier
            password=os.environ.get("PASSWORD"),                # à modifier
            database="SAE_104",        # à modifier
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
    SELECT Seance.libelle_seance, Seance.tarif, Lieu.nom_lieu, Lieu.ville_lieu
    FROM Seance
    JOIN Lieu
    ON Lieu.id_lieu = Seance.id_lieu;
    '''
    cursor.execute(sql)
    seances = cursor.fetchall()
    return render_template("seance/show_seance.html", seances=seances)


if __name__ == '__main__':
    app.run()
