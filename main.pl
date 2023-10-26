% Definir as instruções do assembly
instrucao(add, R1, R2, R3) :- % R1 = R2 + R3
    valor(R2, V2),
    valor(R3, V3),
    V1 is V2 + V3,
    atribuir(R1, V1).

instrucao(sub, R1, R2, R3) :- % R1 = R2 - R3
    valor(R2, V2),
    valor(R3, V3),
    V1 is V2 - V3,
    atribuir(R1, V1).

instrucao(mul, R1, R2, R3) :- % R1 = R2 * R3
    valor(R2, V2),
    valor(R3, V3),
    V1 is V2 * V3,
    atribuir(R1, V1).

instrucao(div, R1, R2, R3) :- % R1 = R2 / R3
    valor(R2, V2),
    valor(R3, V3),
    V1 is V2 / V3,
    atribuir(R1, V1).

instrucao(load, R1, X) :- % R1 = X
    atribuir(R1 ,X).

instrucao(store ,X ,R1) :- % X = R1
    valor(R1 ,V),
    atribuir(X ,V).

instrucao(jump ,L) :- % Ir para o rótulo L
    programa(L ,I),
    executar(I).

instrucao(jumpz ,L) :- % Ir para o rótulo L se zero for verdadeiro
    zero(Z),
    Z == true,
    programa(L ,I),
    executar(I).

instrucao(jumpn ,L) :- % Ir para o rótulo L se negativo for verdadeiro
    negativo(N),
    N == true,
    programa(L ,I),
    executar(I).

% Importar a biblioteca csv
:- use_module(library(csv)).

% Definir o nome do arquivo csv
arquivo('dados.csv').

% Definir a função para obter o valor de um registrador ou variável
valor(Nome ,Valor) :-
    arquivo(Arquivo),
    csv_read_file(Arquivo ,Linhas),
    member(row(Nome ,Valor) ,Linhas).

% Definir a função para atribuir um valor a um registrador ou variável
atribuir(Nome ,Valor) :-
    arquivo(Arquivo),
    csv_read_file(Arquivo ,Linhas),
    maplist(atualizar(Nome ,Valor) ,Linhas ,NovasLinhas),
    csv_write_file(Arquivo ,NovasLinhas),
    atualizar_flags(Valor).

% Definir a função auxiliar para atualizar uma linha do arquivo csv
atualizar(Nome ,Valor ,row(Nome ,_) ,row(Nome ,Valor)) :- !.
atualizar(_ ,_ ,Linha ,Linha).

% Definir a função para atualizar os flags de zero e negativo
atualizar_flags(Valor) :-
    retract(zero(_)),
    retract(negativo(_)),
    (Valor == 0 -> assertz(zero(true)); assertz(zero(false))),
    (Valor < 0 -> assertz(negativo(true)); assertz(negativo(false))).

% Definir o programa com rótulos e instruções
programa(inicio,
         [load(r0, 10), % r0 = 10
          load(r1, 5), % r1 = 5
          sub(r2, r0 ,r1), % r2 = r0 - r1
          store(x ,r2), % x = r2
          jump(fim)]). % Ir para o fim

programa(fim,
         [store(y ,r0), % y = r0
          halt]). % Parar a execução

% Definir os flags de zero e negativo
:- dynamic(zero/1). % zero(Valor)
:- dynamic(negativo/1). % negativo(Valor)

zero(false).
negativo(false).

% Definir a função para executar uma instrução ou uma lista de instruções
executar([]).
executar([I|Is]) :-
    I =.. [Nome|Args],
    (Nome == halt -> true; % Parar se for halt
     instrucao(Nome ,Args), % Executar a instrução
     executar(Is)). % Executar as próximas instruções

executar(I) :-
    I =.. [Nome|Args],
    (Nome == halt -> true; % Parar se for halt
     instrucao(Nome ,Args)). % Executar a instrução

% Iniciar a execução do programa a partir do rótulo inicio
:- programa(inicio ,Is),
   executar(Is).
