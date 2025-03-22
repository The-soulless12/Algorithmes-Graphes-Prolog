# Algorithmes-Graphes-Prolog
Implémentation d’algorithmes de graphes en Prolog, permettant de trouver le plus court chemin, de construire des arbres couvrants de poids minimal et de résoudre des problèmes de coloration.

# Fonctionnalités  
- Coloration d’un graphe en utilisant les algorithmes Welsh-Powell et Dsatur afin d’attribuer des couleurs aux sommets sans conflit.
- Construction d’un arbre couvrant de poids minimal à partir d’un graphe pondéré grâce aux algorithmes Prim et Kruskal.
- Recherche du plus court chemin entre deux sommets d’un graphe pondéré avec l’algorithme Dijkstra.

# Structure du projet  
- main.pl : Contient l’ensemble des faits et règles implémentant les algorithmes.

# Prérequis  
- SWI-Prolog.

# Note
- Pour exécuter le projet, ouvrez un terminal et saisissez `swipl` puis chargez le fichier avec la requête `[main].`. Lancez ensuite les requêtes suivantes avec : `welsh_powell(Coloration).`, `d_satur(Coloration).`, `prim(Arbre, Cout).`, `kruskal(Arbre, Cout).` et `dijkstra(Depart, Arrivee, Chemin, Cout).`.
- Les arguments **Coloration**, **Arbre**, **Cout** et **Chemin** peuvent être remplacés par des variables, qui doivent obligatoirement commencer par une majuscule. En revanche, **Depart** et **Arrivee** doivent être des sommets existants, représentés par des lettres minuscules parmi **{a, b, c, d, e, f}**.
- Pour quitter Prolog, saisissez `halt.` dans votre terminal.
