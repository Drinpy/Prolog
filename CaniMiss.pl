% Definição do problema dos Missionários e Canibais em Prolog - Nova Versão

% Representação do estado: [MissionariosEsquerda, CanibaisEsquerda, PosicaoBarco]
% PosicaoBarco: 'e' para esquerda, 'd' para direita

% Predicado para verificar se um estado é válido (seguro)
estado_valido(M, C, TotalM, TotalC) :-
    M >= 0, C >= 0, M =< TotalM, C =< TotalC, % Garante que os números são válidos
    (M >= C ; M = 0), % Verifica a margem esquerda
    MR is TotalM - M,
    CR is TotalC - C,
    (MR >= CR ; MR = 0). % Verifica a margem direita




% Regras de transição do barco
% transicao_barco(EstadoAtual, CapacidadeBarco, ProximoEstado, DescricaoMovimento)

% Barco na margem esquerda (esquerda -> direita)
transicao_barco([M, C, e], CapBarco, [M_Novo, C_Novo, d], mover(M_Barco, C_Barco, e_para_d)) :-
    between(0, CapBarco, M_Barco),
    between(0, CapBarco, C_Barco),
    M_Barco + C_Barco >= 1,
    M_Barco + C_Barco =< CapBarco,
    M_Novo is M - M_Barco,
    C_Novo is C - C_Barco.

% Barco na margem direita (direita -> esquerda)
transicao_barco([M, C, d], CapBarco, [M_Novo, C_Novo, e], mover(M_Barco, C_Barco, d_para_e)) :-
    between(0, CapBarco, M_Barco),
    between(0, CapBarco, C_Barco),
    M_Barco + C_Barco >= 1,
    M_Barco + C_Barco =< CapBarco,
    M_Novo is M + M_Barco,
    C_Novo is C + C_Barco.




% Predicado para encontrar o caminho usando busca em largura (BFS)
% encontrar_caminho_bfs(EstadoInicial, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Caminho)
encontrar_caminho_bfs(EstadoInicial, EstadoFinal, CapBarco, TotalM, TotalC, Caminho) :-
    criar_fila([ [EstadoInicial] ], Fila),
    processar_fila_bfs(Fila, EstadoFinal, CapBarco, TotalM, TotalC, Caminho).

% processar_fila_bfs(Fila, EstadoFinal, CapacidadeBarco, TotalM, TotalC, Caminho)
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




% Predicado principal para iniciar a busca
% resolver_quebra_cabeca(TotalMissionarios, TotalCanibais, CapacidadeBarco, Solucao)
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

% Exemplo de uso:
% resolver_quebra_cabeca(3, 3, 2, Solucao).


