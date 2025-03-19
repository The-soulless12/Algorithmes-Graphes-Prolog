% Définition du graphe orienté
sommet(a).
sommet(b).
sommet(c).
sommet(d).
sommet(e).

arc(a, b, 4).
arc(a, c, 2).
arc(a, e, 2).
arc(b, c, 5).
arc(b, d, 6).
arc(b, e, 4).
arc(c, d, 3).
arc(d, e, 3).

% Fonctions de base
degre_sortant(Sommet, D) :- 
    findall(_, arc(Sommet, _, _), L), 
    length(L, D).

degre_entrant(Sommet, D) :- 
    findall(_, arc(_, Sommet, _), L), 
    length(L, D).

degre(Sommet, D) :-
    degre_sortant(Sommet, D1),
    degre_entrant(Sommet, D2),
    D is D1 + D2.

voisins(Sommet, Voisins) :-
    findall(V, arc(Sommet, V, _), Voisins).

tous_les_sommets(Sommets) :-
    findall(S, sommet(S), Sommets).

% Les algorithmes de coloration
%Algo01 : Welsh-Powell

tri_decroissant(Sommets, SommetsTries) :-
    findall(D-S, (member(S, Sommets), degre(S, D)), Paires), 
    sort(0, @>=, Paires, Triees),
    findall(S, member(_-S, Triees), SommetsTries).         

couleur_valide(Sommet, Couleur, Attributions) :-
    \+ (arc(Sommet, Voisin, _), member(Voisin-Couleur, Attributions)),
    \+ (arc(Voisin, Sommet, _), member(Voisin-Couleur, Attributions)).

assigner_couleur([], _, []). % Si la liste des sommets est vide, la coloration l est aussi
assigner_couleur([S|Reste], Attributions, [(S-Couleur)|Autres]) :-
    between(1, 100, Couleur),
    couleur_valide(S, Couleur, Attributions),
    assigner_couleur(Reste, [(S-Couleur)|Attributions], Autres), !.

welsh_powell(Coloration) :-
    tous_les_sommets(Sommets),
    tri_decroissant(Sommets, SommetsTries),
    assigner_couleur(SommetsTries, [], Coloration).