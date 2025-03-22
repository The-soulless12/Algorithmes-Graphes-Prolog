% Définition du graphe (sommets & arcs)
sommet(a). sommet(b). sommet(c).
sommet(d). sommet(e). sommet(f).

arc(a, b, 4). arc(a, c, 3). arc(a, f, 5).
arc(b, d, 1). arc(b, e, 2). 
arc(c, d, 3). arc(c, f, 4).
arc(d, e, 2). arc(d, f, 3).
arc(f, b, 1). 

% Règles de base
degre(Sommet, Degre) :-
    findall(1, (arc(Sommet, _, _); arc(_, Sommet, _)), L),
    length(L, Degre).

voisins(Sommet, Voisins) :-
    findall(V, (arc(Sommet, V, _); arc(V, Sommet, _)), ListeVoisins),
    sort(ListeVoisins, Voisins).

get_sommets(Sommets) :-
    findall(S, sommet(S), Sommets).

% Les algorithmes de coloration de graphe
%Algo01 : Welsh-Powell
tri_decroissant_WP(Sommets, SommetsTries) :-
    findall(D-S, (member(S, Sommets), degre(S, D)), Paires), 
    sort(0, @>=, Paires, Triees),
    findall(S, member(_-S, Triees), SommetsTries).         

couleur_valide(Sommet, Couleur, Affectations) :-
    voisins(Sommet, Voisins),
    \+ (member(V, Voisins), member(V-Couleur, Affectations)).

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
    couleur_valide(S, C, Affectations),
    select(S, Sommets, NouveauxSommets), % On retire S de la liste des sommets
    assigner_couleur_DS(NouveauxSommets, [(S-C)|Affectations], Autres), !.

d_satur(Coloration) :-
    get_sommets(Sommets),
    assigner_couleur_DS(Sommets, [], Coloration), !. 

% Les algorithmes de recherche d arbres couvrants de poids minimal
%Algo03 : Prim
prim_recursif(SommetsVisites, Arbres, Arbres) :- % Si tous les sommets sont couverts
    get_sommets(Tous),
    subset(Tous, SommetsVisites). % On verifie si tous les sommets ont dejà ete visites

prim_recursif(SommetsVisites, ArbresActuels, Arbre) :- % Sinon il faut ajouter l arete de poids minimal
    % On retourne toutes les aretes reliant un sommet dejà visite à un sommet non visite
    findall(Poids-U-V,
        (member(U, SommetsVisites),
         (arc(U, V, Poids) ; arc(V, U, Poids)), % On prend en compte les deux sens de l arc
         \+ member(V, SommetsVisites)),
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

%Algo04 : Kruskal
trouver_racine(X, Parents, Rep) :-
    member(X-Y, Parents), !, 
    trouver_racine(Y, Parents, Rep).
trouver_racine(X, _, X).  % Si X n a pas de parent, il est sa propre racine

fusion(X, Y, Parents, [RepX-RepY | Parents]) :-
    trouver_racine(X, Parents, RepX),
    trouver_racine(Y, Parents, RepY),
    RepX \= RepY.
fusion(_, _, Parents, Parents).

kruskal_recursif([], _, Arbre, Arbre).
kruskal_recursif([Poids-U-V | Arcs], Parents, ArbreActuel, ArbreFinal) :-
    trouver_racine(U, Parents, RepU),
    trouver_racine(V, Parents, RepV),
    RepU \= RepV, !,
    fusion(U, V, Parents, Nouveau),
    kruskal_recursif(Arcs, Nouveau, [arc(U, V, Poids) | ArbreActuel], ArbreFinal).
kruskal_recursif([_ | Arcs], Parents, ArbreActuel, ArbreFinal) :-
    kruskal_recursif(Arcs, Parents, ArbreActuel, ArbreFinal).

kruskal(Arbre, Cout) :-
    findall(Poids-U-V, (arc(U, V, Poids) ; arc(V, U, Poids)), Arcs),
    sort(Arcs, ArcsTries),
    kruskal_recursif(ArcsTries, [], [], Arbre),
    cout_total(Arbre, Cout), !. % On ne retourne que la solution optimale

% L algorithme de recherche du plus court chemin
%Algo05 : Dijkstra
init_distances([], _, []).
init_distances([S|R], Depart, [(S, 0)|Distances]) :- S == Depart, !, init_distances(R, Depart, Distances).
init_distances([S|R], Depart, [(S, inf)|Distances]) :- init_distances(R, Depart, Distances).

maj_distances([], _, _, []).
maj_distances([(S, D)|Rest], Sommet, Cout, [(S, ND)|NewRest]) :-
    (  arc(Sommet, S, Poids) ; arc(S, Sommet, Poids) ),
    ND is min(D, Cout + Poids), 
    maj_distances(Rest, Sommet, Cout, NewRest).
maj_distances([(S, D)|Rest], Sommet, Cout, [(S, D)|NewRest]) :-
    maj_distances(Rest, Sommet, Cout, NewRest).

dijkstra_recursif([(Arrivee, Cout, Chemin)|_], _, Arrivee, Chemin, Cout) :- !.
dijkstra_recursif([(Sommet, Cout, Chemin)|Restes], Distances, Arrivee, FinalChemin, FinalCout) :-
    findall((Voisin, NouveauCout, [Voisin|Chemin]),
            (   (arc(Sommet, Voisin, Poids) ; arc(Voisin, Sommet, Poids)),
                \+ member(Voisin, Chemin),
                NouveauCout is Cout + Poids
            ),
            Nouveaux),
    maj_distances(Distances, Sommet, Cout, NouvellesDistances),
    append(Restes, Nouveaux, Tous),
    sort(2, @=<, Tous, Tri), 
    dijkstra_recursif(Tri, NouvellesDistances, Arrivee, FinalChemin, FinalCout).

dijkstra(Depart, Arrivee, Chemin, Cout) :-
    get_sommets(Sommets),
    init_distances(Sommets, Depart, Distances),
    dijkstra_recursif([(Depart, 0, [Depart])], Distances, Arrivee, Chemin, Cout), !.