% Définition du graphe orienté
sommet(a).
sommet(b).
sommet(c).
sommet(d).

arc(a, b, 4).
arc(a, c, 2).
arc(a, d, 2).
arc(b, c, 5).
arc(b, d, 6).
arc(b, a, 4).
arc(c, d, 3).

% Calcul du degré d un sommet
degre_sortant(Sommet, D) :- 
    findall(_, arc(Sommet, _, _), L), 
    length(L, D).

degre_entrant(Sommet, D) :- 
    findall(_, arc(_, Sommet, _), L), 
    length(L, D).

% Recherche des voisins d un sommet
voisins(Sommet, Voisins) :-
    findall(V, arc(Sommet, V, _), Voisins).