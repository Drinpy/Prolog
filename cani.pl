%-------------------------------------------------------------------------
% 			UNIFAL = Universidade Federal de Alfenas.
%			BACHARELADO EM CIÊNCIAS DA COMPUTAÇÃO.
%-------------------------------------------------------------------------
% Trabalho: Generização do problema dos missionários e canibais
% Professor: Luiz Eduardo da Silva
% Aluno: Pedro Henrique Borges Luiz 2020.1.08.036
% Data: 20/06/2025
%------------------------------------------------------------------------

seguro(M, C, TotalM, TotalC) :-
    M >= 0, C >= 0, M =< TotalM, C =< TotalC, % Garante que os números são válidos
    (M >= C ; M = 0), % Verifica a margem esquerda
    MR is TotalM - M,
    CR is TotalC - C,
    (MR >= CR ; MR = 0). % Verifica a margem direita

% Barco na margem esquerda (esquerda -> direita)
mover(estado(M, C, esquerda), CapacidadeBarco, estado(M_Novo, C_Novo, direita), descricao(M_Barco, C_Barco, esquerda_para_direita)) :-
    between(0, CapacidadeBarco, M_Barco), % Missionários no barco
    between(0, CapacidadeBarco, C_Barco), % Canibais no barco
    M_Barco + C_Barco >= 1, % Pelo menos uma pessoa no barco
    M_Barco + C_Barco =< CapacidadeBarco, % Não excede a capacidade do barco
    M_Novo is M - M_Barco,
    C_Novo is C - C_Barco.

% Barco na margem direita (direita -> esquerda)
mover(estado(M, C, direita), CapacidadeBarco, estado(M_Novo, C_Novo, esquerda), descricao(M_Barco, C_Barco, direita_para_esquerda)) :-
    between(0, CapacidadeBarco, M_Barco), % Missionários no barco
    between(0, CapacidadeBarco, C_Barco), % Canibais no barco
    M_Barco + C_Barco >= 1, % Pelo menos uma pessoa no barco
    M_Barco + C_Barco =< CapacidadeBarco, % Não excede a capacidade do barco
    M_Novo is M + M_Barco,
    C_Novo is C + C_Barco.

resolver_bfs(EstadoInicial, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Caminho) :-
    fila_create([ [EstadoInicial] ], Fila),
    resolver_bfs_loop(Fila, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Caminho).


resolver_bfs_loop(Fila, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Caminho) :-
    fila_pop(Fila, CaminhoAtual, FilaRestante),
    CaminhoAtual = [EstadoAtual | _],
    (   EstadoAtual = EstadoFinal
    ->  reverse(CaminhoAtual, Caminho) % Inverte o caminho para ter a ordem correta
    ;
        findall(NovoCaminho,
                (
                    mover(EstadoAtual, CapacidadeBarco, ProximoEstado, _),
                    ProximoEstado = estado(M_Prox, C_Prox, _),
                    \+ member(ProximoEstado, CaminhoAtual), 
                    seguro(M_Prox, C_Prox, TotalM, TotalC), % Garante que o próximo estado é seguro
                    NovoCaminho = [ProximoEstado | CaminhoAtual]
                ),
                NovosCaminhos),
        fila_push_list(FilaRestante, NovosCaminhos, NovaFila),
        resolver_bfs_loop(NovaFila, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Caminho)
    ).


encontrar_solucao(TotalM, TotalC, CapacidadeBarco, Solucao) :-
    EstadoInicial = estado(TotalM, TotalC, esquerda),
    EstadoFinal = estado(0, 0, direita),
    seguro(TotalM, TotalC, TotalM, TotalC), % Verifica se o estado inicial é seguro
    resolver_bfs(EstadoInicial, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Solucao).


fila_create(Elementos, Elementos).
fila_pop([H|T], H, T).
fila_push(Fila, Elemento, NovaFila) :-
    append(Fila, [Elemento], NovaFila).
fila_push_list(Fila, ListaElementos, NovaFila) :-
    append(Fila, ListaElementos, NovaFila).

% exemplo
% encontrar_solucao(3, 3, 2, Solucao).


