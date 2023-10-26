% Definições de registradores
reg(a0, 0).
reg(a1, 0).
reg(a2, 0).
reg(a3, 0).
reg(a4, 0).
reg(a5, 0).

% Implementação da instrução addi (adição imediata)
instrucao(addi, Dest, Src, Immediate) :-
    reg(Src, Valor),
    Soma is Valor + Immediate,
    retract(reg(Dest, _)),
    assert(reg(Dest, Soma)).

% Implementação da instrução add (adição)
instrucao(add, Dest, Src1, Src2) :-
    reg(Src1, Valor1),
    reg(Src2, Valor2),
    Soma is Valor1 + Valor2,
    retract(reg(Dest, _)),
    assert(reg(Dest, Soma)).

% Implementação da instrução jump (salto incondicional)
instrucao(jump, Destino) :-
    retract(program_counter(_)),  % Atualiza o contador de programa
    assert(program_counter(Destino)).

% Faltam mais algumas das básicas

% Função principal
main :-
    % Instruções do programa
    instrucao(addi, a0, a0, 3),
    instrucao(add, a1, a1, a0),
    instrucao(jump, fim),  % Salto para uma instrução chamada "fim"
    
    % Outras instruções do programa...

    halt.

% Definição de um ponto de parada
halt.

:- main.
