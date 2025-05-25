% Integrantes:
% Enzo Ribeiro                 - 10418262 
% Gabriel Ken Kazama Geronazzo - 10418247 
% Lucas Zanini da Silva        - 10417361

% is_check(["tcbdrbct","pppppppp","8","8","8","8","PPPPPPPP","TCBDRBCT"]).
% >> false.

% Verifica se o rei branco está em xeque
is_check(BoardRaw) :-
    parse_board(BoardRaw, Board),
    find_king_position(Board, KingRow, KingCol),
    KingRow \= -1,
    KingCol \= -1,
    is_king_in_check(Board, KingRow, KingCol).

% Converte a representação do tabuleiro em uma matriz
parse_board([], []).
parse_board([Line|RestLines], [ExpandedLine|RestBoard]) :-
    atom_chars(Line, Chars),
    expand_line(Chars, ExpandedLine),
    parse_board(RestLines, RestBoard).

% Expande uma linha, convertendo números em casas vazias ('#')
expand_line([], []).
expand_line([C|Cs], Result) :-
    (char_type(C, digit) ->
        char_code(C, Code),
        Number is Code - 48,
        replicate('#', Number, Spaces),
        expand_line(Cs, RestResult),
        append(Spaces, RestResult, Result)
    ;
        expand_line(Cs, RestResult),
        Result = [C|RestResult]
    ).

% Replica um elemento N vezes
replicate(_, 0, []).
replicate(Element, N, [Element|Rest]) :-
    N > 0,
    N1 is N - 1,
    replicate(Element, N1, Rest).

% Encontra a posição do rei branco no tabuleiro
find_king_position(Board, Row, Col) :-
    find_king_position_aux(Board, 0, Row, Col).

find_king_position_aux([], _, -1, -1).
find_king_position_aux([Line|RestBoard], CurrentRow, Row, Col) :-
    (find_in_line(Line, 'R', 0, Col) ->
        Row = CurrentRow
    ;
        NextRow is CurrentRow + 1,
        find_king_position_aux(RestBoard, NextRow, Row, Col)
    ).

% Encontra uma peça em uma linha
find_in_line([], _, _, -1).
find_in_line([Piece|_], Piece, CurrentCol, CurrentCol).
find_in_line([_|RestLine], Piece, CurrentCol, Col) :-
    NextCol is CurrentCol + 1,
    find_in_line(RestLine, Piece, NextCol, Col).

% Verifica se o rei branco está em xeque
is_king_in_check(Board, KingRow, KingCol) :-
    between(0, 7, Row),
    between(0, 7, Col),
    get_piece(Board, Row, Col, Piece),
    is_black_piece(Piece),
    can_attack(Board, Row, Col, KingRow, KingCol),
    !.

% Obtém a peça em uma posição específica
get_piece(Board, Row, Col, Piece) :-
    nth0(Row, Board, Line),
    nth0(Col, Line, Piece).

% Verifica se um caractere representa uma peça preta
is_black_piece(t).
is_black_piece(p).
is_black_piece(c).
is_black_piece(b).
is_black_piece(d).
is_black_piece(r).

% Verifica se uma peça pode atacar o rei
can_attack(Board, Row, Col, KingRow, KingCol) :-
    get_piece(Board, Row, Col, Piece),
    can_attack_piece(Piece, Board, Row, Col, KingRow, KingCol).

can_attack_piece(p, _, Row, Col, KingRow, KingCol) :-
    can_pawn_attack(Row, Col, KingRow, KingCol).
can_attack_piece(t, Board, Row, Col, KingRow, KingCol) :-
    can_rook_attack(Board, Row, Col, KingRow, KingCol).
can_attack_piece(c, _, Row, Col, KingRow, KingCol) :-
    can_knight_attack(Row, Col, KingRow, KingCol).
can_attack_piece(b, Board, Row, Col, KingRow, KingCol) :-
    can_bishop_attack(Board, Row, Col, KingRow, KingCol).
can_attack_piece(d, Board, Row, Col, KingRow, KingCol) :-
    can_queen_attack(Board, Row, Col, KingRow, KingCol).
can_attack_piece(r, _, Row, Col, KingRow, KingCol) :-
    can_king_attack(Row, Col, KingRow, KingCol).

% Ataques específicos para cada peça
can_pawn_attack(Row, Col, KingRow, KingCol) :-
    KingRow is Row + 1,
    (KingCol is Col - 1 ; KingCol is Col + 1).

can_rook_attack(Board, Row, Col, KingRow, KingCol) :-
    (Row = KingRow ; Col = KingCol),
    \+ has_piece_between(Board, Row, Col, KingRow, KingCol).

can_knight_attack(Row, Col, KingRow, KingCol) :-
    RowDiff is abs(Row - KingRow),
    ColDiff is abs(Col - KingCol),
    ((RowDiff = 2, ColDiff = 1) ; (RowDiff = 1, ColDiff = 2)).

can_bishop_attack(Board, Row, Col, KingRow, KingCol) :-
    RowDiff is abs(Row - KingRow),
    ColDiff is abs(Col - KingCol),
    RowDiff = ColDiff,
    RowDiff > 0,
    \+ has_piece_between(Board, Row, Col, KingRow, KingCol).

can_queen_attack(Board, Row, Col, KingRow, KingCol) :-
    (can_rook_attack(Board, Row, Col, KingRow, KingCol) ;
     can_bishop_attack(Board, Row, Col, KingRow, KingCol)).

can_king_attack(Row, Col, KingRow, KingCol) :-
    RowDiff is abs(Row - KingRow),
    ColDiff is abs(Col - KingCol),
    RowDiff =< 1,
    ColDiff =< 1,
    (RowDiff > 0 ; ColDiff > 0).

% Verifica se há peças entre duas posições
has_piece_between(Board, Row1, Col1, Row2, Col2) :-
    (Row1 = Row2 ->
        check_horizontal_path(Board, Row1, Col1, Col2)
    ; Col1 = Col2 ->
        check_vertical_path(Board, Row1, Row2, Col1)
    ;
        check_diagonal_path(Board, Row1, Col1, Row2, Col2)
    ).

check_horizontal_path(Board, Row, Col1, Col2) :-
    MinCol is min(Col1, Col2) + 1,
    MaxCol is max(Col1, Col2) - 1,
    between(MinCol, MaxCol, Col),
    get_piece(Board, Row, Col, Piece),
    Piece \= '#',
    !.

check_vertical_path(Board, Row1, Row2, Col) :-
    MinRow is min(Row1, Row2) + 1,
    MaxRow is max(Row1, Row2) - 1,
    between(MinRow, MaxRow, Row),
    get_piece(Board, Row, Col, Piece),
    Piece \= '#',
    !.

check_diagonal_path(Board, Row1, Col1, Row2, Col2) :-
    step(Row1, Row2, RowStep),
    step(Col1, Col2, ColStep),
    check_diagonal_positions(Board, Row1, Col1, Row2, Col2, RowStep, ColStep).

check_diagonal_positions(Board, Row1, Col1, Row2, Col2, RowStep, ColStep) :-
    NextRow is Row1 + RowStep,
    NextCol is Col1 + ColStep,
    NextRow \= Row2,
    NextCol \= Col2,
    get_piece(Board, NextRow, NextCol, Piece),
    (Piece \= '#' ->
        true
    ;
        check_diagonal_positions(Board, NextRow, NextCol, Row2, Col2, RowStep, ColStep)
    ).

% Calcula o passo (direção) entre duas coordenadas
step(A, B, 1) :- A < B, !.
step(A, B, -1) :- A > B, !.
step(_, _, 0).