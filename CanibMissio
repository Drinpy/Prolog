%-------------------------------------------------------------------------
% 			UNIFAL = Universidade Federal de Alfenas.
%			BACHARELADO EM CIÊNCIAS DA COMPUTAÇÃO.
%-------------------------------------------------------------------------
% Trabalho: Generização do problema dos missionários e canibais
% Professor: Luiz Eduardo da Silva
% Aluno: Matheus Malvão Barbosa 2020.1.08.025
% Data: 20/06/2025
%------------------------------------------------------------------------

estado_valido(M, C, TotalM, TotalC) :-
    M >= 0, C >= 0, M =< TotalM, C =< TotalC, 
    (M >= C ; M = 0), %margem esquerda
    MR is TotalM - M,
    CR is TotalC - C,
    (MR >= CR ; MR = 0). %margem direita

% Regras de transição do barco

% margem esquerda (esquerda direita)
transicao_barco([M, C, e], CapBarco, [M_Novo, C_Novo, d], mover(M_Barco, C_Barco, e_para_d)) :-
    between(0, CapBarco, M_Barco),
    between(0, CapBarco, C_Barco),
    M_Barco + C_Barco >= 1,
    M_Barco + C_Barco =< CapBarco,
    M_Novo is M - M_Barco,
    C_Novo is C - C_Barco.

% margem direita (direita esquerda)
transicao_barco([M, C, d], CapBarco, [M_Novo, C_Novo, e], mover(M_Barco, C_Barco, d_para_e)) :-
    between(0, CapBarco, M_Barco),
    between(0, CapBarco, C_Barco),
    M_Barco + C_Barco >= 1,
    M_Barco + C_Barco =< CapBarco,
    M_Novo is M + M_Barco,
    C_Novo is C + C_Barco.




% busca em largura (BFS)
encontrar_caminho_bfs(EstadoInicial, EstadoFinal, CapBarco, TotalM, TotalC, Caminho) :-
    criar_fila([ [EstadoInicial] ], Fila),
    processar_fila_bfs(Fila, EstadoFinal, CapBarco, TotalM, TotalC, Caminho).


processar_fila_bfs(Fila, EstadoFinal, CapBarco, TotalM, TotalC, Caminho) :-
    remover_da_fila(Fila, CaminhoAtual, FilaRestante),
    CaminhoAtual = [EstadoAtual | _],
    (   EstadoAtual = EstadoFinal
    ->  reverse(CaminhoAtual, Caminho)
    ;
        findall(NovoCaminho,
                (
                    transicao_barco(EstadoAtual, CapBarco, ProximoEstado, _),
                    ProximoEstado = [M_Prox, C_Prox, _],
                    \+ member(ProximoEstado, CaminhoAtual),
                    estado_valido(M_Prox, C_Prox, TotalM, TotalC),
                    NovoCaminho = [ProximoEstado | CaminhoAtual]
                ),
                NovosCaminhos),
        adicionar_lista_a_fila(FilaRestante, NovosCaminhos, NovaFila),
        processar_fila_bfs(NovaFila, EstadoFinal, CapBarco, TotalM, TotalC, Caminho)
    ).

% Solucao será uma lista de estados, do inicial ao final
resolver_quebra_cabeca(TotalM, TotalC, CapBarco, Solucao) :-
    EstadoInicial = [TotalM, TotalC, e],
    EstadoFinal = [0, 0, d],
    estado_valido(TotalM, TotalC, TotalM, TotalC),
    encontrar_caminho_bfs(EstadoInicial, EstadoFinal, CapBarco, TotalM, TotalC, Solucao).

% Predicados auxiliares para manipulação de fila
criar_fila(Elementos, Elementos).
remover_da_fila([H|T], H, T).
adicionar_a_fila(Fila, Elemento, NovaFila) :-
    append(Fila, [Elemento], NovaFila).
adicionar_lista_a_fila(Fila, ListaElementos, NovaFila) :-
    append(Fila, ListaElementos, NovaFila).

% Exemplo:
% resolver_quebra_cabeca(3, 3, 2, Solucao).
