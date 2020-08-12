:- set_prolog_flag(stack_limit, 10 000 000 000).
:- use_module(library(yaml/parser)).
:- use_module(library(yaml/util)).
:- use_module(library(yaml/serializer)).

jouer(Donnee) :-
	read_yaml(file('C:/Users/david/Documents/Stage/Programmes/liste.yaml'),DOM),
	parse(DOM,Donnee),
	parcours(Donnee),
	print_term(Donnee,[]).


parcours(Donnee) :-
        type(Donnee, caracteristique),
        print_term(Donnee,[]),
        format("Le heros possede la caracteristique suivante : \"~w\" ?\n", [Donnee.valeur]),
        read(X),
        parcours(Donnee.get(X)),!.

parcours(Donnee) :-
        type(Donnee,hero),
        print_term(Donnee,[]),
        format("Le heros est : \"~w\" ?\n", [Donnee.valeur]),
        read(X),
        parcours(Donnee.get(X)),!.

parcours(Donnee) :-
        Donnee == $,
        print_term(Donnee,[]),
        writeln("Ajouter un héros"),
        ajouter_heros(Donnee),!.

parcours(Donnee) :-
        Donnee == $$,
        print_term(Donnee,[]),
        writeln("FIN"),!.

ajouter_heros(Donnee):-
    writeln("A quel heros pensiez-vous ?"),
    read(NomHeros),
    writeln("Quelle caracteristique n'a pas votre hero et n'a pas ete citee"),
    read(Carac),
    Donnee = _{ non:($),
                       oui:_{non: $,oui: $$,type:hero,valeur:NomHeros},
                       type:caracteristique,
                       valeur:Carac}.


type(Donnee, Type) :- is_dict(Donnee), Donnee.type == Type.