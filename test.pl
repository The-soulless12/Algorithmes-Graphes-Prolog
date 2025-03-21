% Définition du graphe (sommets & arcs)
sommet(a).
sommet(b).
sommet(c).
sommet(d).
sommet(e).
sommet(f).

arc(a, b, 2). arc(a, c, 2). arc(a, f, 4).
arc(b, d, 2). arc(b, e, 2).
arc(c, d, 3). arc(c, f, 4).
arc(d, e, 2).
arc(f, b, 1).

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

get_sommets(Sommets) :-
    findall(S, sommet(S), Sommets).

% Les algorithmes de coloration
%Algo01 : Welsh-Powell
tri_decroissant_WP(Sommets, SommetsTries) :-
    findall(D-S, (member(S, Sommets), degre(S, D)), Paires), 
    sort(0, @>=, Paires, Triees),
    findall(S, member(_-S, Triees), SommetsTries).         

couleur_valide(Sommet, Couleur, Affectations) :-
    \+ (arc(Sommet, Voisin, _), member(Voisin-Couleur, Affectations)),
    \+ (arc(Voisin, Sommet, _), member(Voisin-Couleur, Affectations)).

assigner_couleur_WP([], _, []). % Si la liste des sommets est vide, la coloration l est aussi
assigner_couleur_WP([S|Reste], Affectations, [(S-Couleur)|Autres]) :-
    between(1, 100, Couleur),
    couleur_valide(S, Couleur, Affectations),
    assigner_couleur_WP(Reste, [(S-Couleur)|Affectations], Autres), !.

welsh_powell(Coloration) :-
    get_sommets(Sommets),
    tri_decroissant_WP(Sommets, SommetsTries),
    assigner_couleur_WP(SommetsTries, [], Coloration).

%Algo02 : D-SATUR
degre_saturation(S, Affectations, DS) :-
    voisins(S, Voisins),
    findall(C, (member(V, Voisins), member(V-C, Affectations)), Couleurs),
    sort(Couleurs, CouleursTriees),
    length(CouleursTriees, DS).

tri_decroissant_DS(Sommets, Affectations, SommetsTries) :-
    findall(DS-D-S, (member(S, Sommets), 
                     degre_saturation(S, Affectations, DS), 
                     degre(S, D)), Paires),
    sort(0, @>=, Paires, Triees),
    findall(S, member(_-_ - S, Triees), SommetsTries).

assigner_couleur_DS([], _, []).  % Si la liste des sommets est vide, la coloration l est aussi
assigner_couleur_DS(Sommets, Affectations, [(S-C)|Autres]) :-
    tri_decroissant_DS(Sommets, Affectations, [S|_]), 
    between(1, 100, C),
    couleur_valide(S, C, Affectations), !,
    select(S, Sommets, NouveauxSommets),
    assigner_couleur_DS(NouveauxSommets, [(S-C)|Affectations], Autres).

d_satur(Coloration) :-
    get_sommets(Sommets),
    assigner_couleur_DS(Sommets, [], Coloration), !. 

% Les algorithmes de recherche d arbres couvrants de poids minimal
%Algo03 : Prim
prim_recursif(SommetsVisites, Arbres, Arbres) :- % Si tous les sommets sont couverts
    get_sommets(Tous),
    subset(Tous, SommetsVisites). % On verifie si tous les sommets ont dejà ete visites

prim_recursif(SommetsVisites, ArbresActuels, Arbre) :- % Sinon il faut ajouter l arete de poids minimal
    % Retourne toutes les aretes reliant un sommet dejà visite à un sommet non visite
    findall(Poids-U-V,
            (member(U, SommetsVisites), arc(U, V, Poids), \+ member(V, SommetsVisites)),
            ArcsPossibles),
    sort(ArcsPossibles, [PoidsMin-Umin-Vmin|_]),
    prim_recursif([Vmin|SommetsVisites], [arc(Umin, Vmin, PoidsMin)|ArbresActuels], Arbre).

cout_total([], 0).  
cout_total([arc(_, _, Poids)|Reste], Somme) :-  
    cout_total(Reste, SommeReste),  
    Somme is Poids + SommeReste.

prim(Arbre, Cout) :-
    get_sommets([Depart|_]),
    prim_recursif([Depart], [], Arbre),
    cout_total(Arbre, Cout), !. % On ne retourne que la solution optimale