:- set_prolog_flag(stack_limit, 10 000 000 000).
:- set_prolog_flag(encoding,utf8).
:- use_module(library(yaml/parser)).
:- use_module(library(yaml/util)).
:- use_module(library(yaml/serializer)).

jouer :-
	read_yaml(file('C:/Users/david/Documents/Stage/Programmes/liste.yaml'),DOM),
	parse(DOM,Entree),
	parcours(Entree,Sortie),
	serialize(Sortie,DOM1),
	write_yaml('C:/Users/david/Documents/Stage/Programmes/liste.yaml',DOM1).

parcours(Entree,Sortie) :-
        type(Entree, caracteristique),
        format("Le heros possede la caracteristique suivante : \"~w\" ?\n", [Entree.valeur]),
        read(X),
        parcours(Entree,X,Sortie1),
        put_dict(X,Entree,Sortie1,Sortie),!.

parcours(Entree,Sortie) :-
        type(Entree,hero),
        format("Le heros est : \"~w\" ?\n", [Entree.valeur]),
        read(X),
        parcours(Entree,X,Sortie1),
        put_dict(X,Entree,Sortie1,Sortie),!.

parcours(Entree,Choix,Sortie) :-
        type(Entree.get(Choix), caracteristique),
        format("Le heros possede la caracteristique suivante : \"~w\" ?\n", [Entree.get(Choix).valeur]),
        read(X),
        parcours(Entree.get(Choix),X,Sortie1),
        put_dict(X,Entree.get(Choix),Sortie1,Sortie),!.

parcours(Entree,Choix,Sortie) :-
        type(Entree.get(Choix),hero),
        format("Le heros est : \"~w\" ?\n", [Entree.get(Choix).valeur]),
        read(X),
        parcours(Entree.get(Choix),X,Sortie1),
        put_dict(X,Entree.get(Choix),Sortie1,Sortie),!.

parcours(Entree,Choix,Sortie) :-
        Entree.get(Choix) == $,
        writeln("Ajouter un heros"),
        ajouter_heros(Sortie),!.

parcours(Entree,Choix,Sortie) :-
        Entree.get(Choix) == $$,
        ansi_format([bold],"Vous pensiez a ~w !", [Entree.valeur]),!,
        copy_term(Entree.get(Choix),Sortie).

ajouter_heros(Sortie):-
    writeln("A quel heros pensiez-vous ?"),
    read(NomHeros),
    writeln("Donnez une caracteristique particuliere a votre heros :"),
    read(Carac),
    Sortie = _{valeur:Carac,
                                non:($),
                                oui:_{valeur:NomHeros,non: $,oui: $$,type:hero},
                                type:caracteristique},
    ansi_format([bold],"Le hero ~w a ete ajoute a la base avec la caracteristique ~w !", [NomHeros,Carac]).


type(Entree, Type) :- is_dict(Entree), Entree.type == Type.