:- [main].

% ====================================================================
% CASOS DE TESTE PARA DETECÇÃO DE XEQUE
% Aplicando técnicas de testagem de software:
% 1. Teste de valores limite (boundary testing)
% 2. Teste de partição de equivalência
% ====================================================================

% ===== TESTES BÁSICOS DE FUNCIONALIDADE =====

% Teste 1: Posição inicial do xadrez (não deve haver xeque)
test1 :-
    is_check([['t','c','b','d','r','b','c','t'],['p','p','p','p','p','p','p','p'],8,8,8,8,['P','P','P','P','P','P','P','P'],['T','C','B','D','R','B','C','T']]),
    write('Test 1 (initial position): FAIL - should be false'), nl, !.
test1 :-
    write('Test 1 (initial position): PASS'), nl.

% Teste 2: Rei sozinho no tabuleiro (não deve haver xeque)
test2 :-
    is_check([8, 8, 8, 8, [3,'R',4], 8, 8, 8]),
    write('Test 2 (king alone): FAIL - should be false'), nl, !.
test2 :-
    write('Test 2 (king alone): PASS'), nl.

% ===== TESTES DE ATAQUE POR PEÃO =====

% Teste 3: Peão atacando rei na diagonal esquerda
test3 :-
    is_check([8, 8, 8, 8, 8, 8, ['p',7], [1,'R',6]]),
    write('Test 3 (pawn attack left): PASS'), nl, !.
test3 :-
    write('Test 3 (pawn attack left): FAIL - should be true'), nl.

% Teste 4: Peão atacando rei na diagonal direita
test4 :-
    is_check([8, 8, 8, 8, 8, 8, [1,'p',6], ['R',7]]),
    write('Test 4 (pawn attack right): PASS'), nl, !.
test4 :-
    write('Test 4 (pawn attack right): FAIL - should be true'), nl.

% Teste 5: Peão não pode atacar para trás
test5 :-
    is_check([8, ['R',7], ['p',7], 8, 8, 8, 8, 8]),
    write('Test 5 (pawn backward): FAIL - should be false'), nl, !.
test5 :-
    write('Test 5 (pawn backward): PASS'), nl.

% ===== TESTES DE ATAQUE POR TORRE =====

% Teste 6: Torre atacando rei horizontalmente
test6 :-
    is_check([8, 8, 8, 8, 8, 8, 8, ['t',3,'R',4]]),
    write('Test 6 (rook horizontal): PASS'), nl, !.
test6 :-
    write('Test 6 (rook horizontal): FAIL - should be true'), nl.

% Teste 7: Torre atacando rei verticalmente
test7 :-
    is_check([['t',7], 8, 8, 8, 8, 8, 8, ['R',7]]),
    write('Test 7 (rook vertical): PASS'), nl, !.
test7 :-
    write('Test 7 (rook vertical): FAIL - should be true'), nl.

% Teste 8: Torre bloqueada por peça
test8 :-
    is_check([['t',7], ['P',7], 8, 8, 8, 8, 8, ['R',7]]),
    write('Test 8 (rook blocked): FAIL - should be false'), nl, !.
test8 :-
    write('Test 8 (rook blocked): PASS'), nl.

% ===== TESTES DE ATAQUE POR BISPO =====

% Teste 9: Bispo atacando na diagonal principal
test9 :-
    is_check([['b',7], 8, 8, 8, 8, 8, 8, [7,'R']]),
    write('Test 9 (bishop diagonal): PASS'), nl, !.
test9 :-
    write('Test 9 (bishop diagonal): FAIL - should be true'), nl.

% Teste 10: Bispo atacando na diagonal secundária
test10 :-
    is_check([[7,'b'], 8, 8, 8, 8, 8, 8, ['R',7]]),
    write('Test 10 (bishop anti-diagonal): PASS'), nl, !.
test10 :-
    write('Test 10 (bishop anti-diagonal): FAIL - should be true'), nl.

% Teste 11: Bispo bloqueado por peça
test11 :-
    is_check([['b',7], [1,'P',6], 8, 8, 8, 8, 8, [7,'R']]),
    write('Test 11 (bishop blocked): FAIL - should be false'), nl, !.
test11 :-
    write('Test 11 (bishop blocked): PASS'), nl.

% ===== TESTES DE ATAQUE POR CAVALO =====

/*
Teste 12: Cavalo atacando - movimento L válido (2,1)

Tabuleiro: [8, 8, 8, 8, 8, ['c',7], 8, [1,'R',6]]

# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
c # # # # # # # #
# # # # # # # # #
# R # # # # # # #

*/

test12 :-
    is_check([8, 8, 8, 8, 8, ['c',7], 8, [1,'R',6]]),
    write('Test 12 (knight L-move 2,1): PASS'), nl, !.
test12 :-
    write('Test 12 (knight L-move 2,1): FAIL - should be true'), nl.

/*
Teste 13: Cavalo atacando - movimento L válido (1,2)

Tabuleiro: [8, 8, 8, 8, 8, 8, ['c',7], [2,'R',5]]

# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
c # # # # # # # #
# # R # # # # # #
*/
test13 :-
    is_check([8, 8, 8, 8, 8, 8, ['c',7], [2,'R',5]]),
    write('Test 13 (knight L-move 1,2): PASS'), nl, !.
test13 :-
    write('Test 13 (knight L-move 1,2): FAIL - should be true'), nl.

/*
Teste 14: Cavalo - movimento inválido

Tabuleiro: [8, 8, 8, ['c',7], 8, 8, 8, ['R',7]]

# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
c # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # #
# # # # # # # # R
*/
test14 :-
    is_check([8, 8, 8, ['c',7], 8, 8, 8, ['R',7]]),
    write('Test 14 (knight invalid move): FAIL - should be false'), nl, !.
test14 :-
    write('Test 14 (knight invalid move): PASS'), nl.

% ===== TESTES DE ATAQUE POR RAINHA =====

% Teste 15: Rainha atacando horizontalmente
test15 :-
    is_check([8, 8, 8, 8, 8, 8, 8, ['d',3,'R',4]]),
    write('Test 15 (queen horizontal): PASS'), nl, !.
test15 :-
    write('Test 15 (queen horizontal): FAIL - should be true'), nl.

% Teste 16: Rainha atacando na diagonal
test16 :-
    is_check([['d',7], 8, 8, 8, 8, 8, 8, [7,'R']]),
    write('Test 16 (queen diagonal): PASS'), nl, !.
test16 :-
    write('Test 16 (queen diagonal): FAIL - should be true'), nl.

% ===== TESTES DE ATAQUE POR REI =====

% Teste 17: Rei atacando rei (adjacente)
test17 :-
    is_check([8, 8, 8, 8, 8, 8, ['r',7], ['R',7]]),
    write('Test 17 (king vs king): PASS'), nl, !.
test17 :-
    write('Test 17 (king vs king): FAIL - should be true'), nl.

% ===== TESTES DE CASOS LIMITE (BOUNDARY TESTING) =====

% Teste 18: Rei no canto superior esquerdo
test18 :-
    is_check([['R',7], ['t',7], 8, 8, 8, 8, 8, 8]),
    write('Test 18 (corner attack): PASS'), nl, !.
test18 :-
    write('Test 18 (corner attack): FAIL - should be true'), nl.

% Teste 19: Rei no centro com múltiplas ameaças
test19 :-
    is_check([8, 8, 8, ['t',3,'R','t',3], 8, 8, 8, 8]),
    write('Test 19 (center multiple threats): PASS'), nl, !.
test19 :-
    write('Test 19 (center multiple threats): FAIL - should be true'), nl.

% Teste 20: Ataque máximo - diagonal completa
test20 :-
    is_check([['b',7], 8, 8, 8, 8, 8, 8, [7,'R']]),
    write('Test 20 (max diagonal): PASS'), nl, !.
test20 :-
    write('Test 20 (max diagonal): FAIL - should be true'), nl.

% ===== TESTES DE ROBUSTEZ =====

% Teste 21: Tabuleiro com muitas peças, sem xeque
test21 :-
    is_check([['t','c','b','d','r','b','c','t'], ['p','p','p','p',1,'p','p','p'], 8, 8, 8, 8, ['P','P','P','P','P','P','P','P'], ['T','C','B','D','R','B','C','T']]),
    write('Test 21 (complex no check): FAIL - should be false'), nl, !.
test21 :-
    write('Test 21 (complex no check): PASS'), nl.

% Teste 22: Múltiplos ataques simultâneos
test22 :-
    is_check([8, 8, 8, ['b',3,'R','t',3], 8, 8, 8, 8]),
    write('Test 22 (multiple simultaneous): PASS'), nl, !.
test22 :-
    write('Test 22 (multiple simultaneous): FAIL - should be true'), nl.

% ===== TESTES DE PARTIÇÃO DE EQUIVALÊNCIA =====

% Teste 23: Peças brancas não atacam rei branco
test23 :-
    is_check([8, 8, 8, 8, 8, 8, 8, ['T',3,'R',4]]),
    write('Test 23 (white pieces ignore): FAIL - should be false'), nl, !.
test23 :-
    write('Test 23 (white pieces ignore): PASS'), nl.

% Teste 24: Casas vazias são ignoradas
test24 :-
    is_check([[3,'R',4], 8, 8, 8, 8, 8, 8, 8]),
    write('Test 24 (empty squares): FAIL - should be false'), nl, !.
test24 :-
    write('Test 24 (empty squares): PASS'), nl.

% Teste 25: Notação mista (peças e números)
test25 :-
    is_check([['t',1,'b',1,'r',1,'c',1], 8, 8, 8, 8, 8, 8, [4,'R',3]]),
    write('Test 25 (mixed notation): FAIL - should be false'), nl, !.
test25 :-
    write('Test 25 (mixed notation): PASS'), nl.

run_all_tests :-
    write('====== EXECUÇÃO DE TODOS OS TESTES ======'), nl,
    test1, test2, test3, test4, test5,
    test6, test7, test8, test9, test10,
    test11, test12, test13, test14, test15,
    test16, test17, test18, test19, test20,
    test21, test22, test23, test24, test25,
    write('====== TODOS OS TESTES CONCLUÍDOS ======'), nl.
