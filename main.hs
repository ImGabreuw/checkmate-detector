import System.IO

type Position = (Int, Int)
type Board = [[Char]]

main :: IO ()
main = do
  putStrLn "Exemplo entrada: [\"tcbdrbct\",\"pppppppp\",\"8\",\"8\",\"8\",\"8\",\"PPPPPPPP\",\"TCBDRBCT\"] \n"
  putStrLn "Digite a representação do tabuleiro de xadrez:"
  input <- getLine
  let boardRaw = read input :: [String] -- converte a string de entrada em uma lista de strings
  print (isCheck boardRaw)

-- Verifica se o rei branco está em xeque
isCheck :: [String] -> Bool
isCheck boardRaw = isKingInCheck board kingPos
  where
    board = parseBoard boardRaw
    kingPos = findKingPosition board

-- Converte a representação do tabuleiro em uma matriz de caracteres
parseBoard :: [String] -> Board
parseBoard = map expandLine

-- Expande uma linha, convertendo números em casas vazias ("#")
expandLine :: String -> [Char]
expandLine [] = []
expandLine (c : cs)
  | c `elem` ['1' .. '8'] = replicate (read [c] :: Int) '#' ++ expandLine cs
  | otherwise = c : expandLine cs

-- Encontra a posição do rei branco no tabuleiro
findKingPosition :: Board -> Position
findKingPosition board =
  head
    [ (line, col)
      | line <- [0 .. 7],
        col <- [0 .. 7],
        (board !! line !! col) == 'R'
    ]

-- Verifica se o rei branco está em xeque
isKingInCheck :: Board -> Position -> Bool
isKingInCheck board kingPos =
  any -- automaticamente aplica cada posição (i, j) da lista como o terceiro argumento da função parcialmente aplicada "canAttack"
    (canAttack board kingPos) -- aplicação parcial de funções (currying): criar uma nova função que recebe apenas a posição da peça preta (parâmetro "pos")
    [ (i, j)
      | i <- [0 .. 7],
        j <- [0 .. 7],
        isBlackPiece (board !! i !! j)
    ]

-- Verifica se um caractere representa uma peça preta
isBlackPiece :: Char -> Bool
isBlackPiece c = c `elem` "tpcbdr"

-- Verifica se uma peça na posição "pos" pode atacar o rei branco em "kingPos"
canAttack :: Board -> Position -> Position -> Bool
-- operador "@" é usado para construir o "padrão de associação" (as pattern):
-- "kingPos@(kingRow, kingCol)" atribui o nome "kingPos" ao valor completo da posição (tupla), enquanto também extrai cada componente como "kingRow" e "kingCol"
-- "pos@(row, col)" faz o mesmo para a posição da peça preta
canAttack board kingPos@(kingRow, kingCol) pos@(row, col) =
  case board !! row !! col of
    'p' -> canPawnAttack pos kingPos
    't' -> canRookAttack board pos kingPos
    'c' -> canKnightAttack pos kingPos
    'b' -> canBishopAttack board pos kingPos
    'd' -> canQueenAttack board pos kingPos
    'r' -> canKingAttack pos kingPos
    _ -> False

-- Verifica ataques específicos para cada tipo de peça
canPawnAttack :: Position -> Position -> Bool
canPawnAttack (row, col) (kingRow, kingCol) =
  row + 1 == kingRow && (col - 1 == kingCol || col + 1 == kingCol)

canRookAttack :: Board -> Position -> Position -> Bool
canRookAttack board (row, col) (kingRow, kingCol) =
  (row == kingRow || col == kingCol)
    && not (hasPieceBetween board (row, col) (kingRow, kingCol))

canKnightAttack :: Position -> Position -> Bool
canKnightAttack (row, col) (kingRow, kingCol) =
  (abs (row - kingRow) == 2 && abs (col - kingCol) == 1)
    || (abs (row - kingRow) == 1 && abs (col - kingCol) == 2)

canBishopAttack :: Board -> Position -> Position -> Bool
canBishopAttack board (row, col) (kingRow, kingCol) =
  abs (row - kingRow) == abs (col - kingCol)
    && not (hasPieceBetween board (row, col) (kingRow, kingCol))

canQueenAttack :: Board -> Position -> Position -> Bool
canQueenAttack board pos kingPos =
  canRookAttack board pos kingPos || canBishopAttack board pos kingPos

canKingAttack :: Position -> Position -> Bool
canKingAttack (row, col) (kingRow, kingCol) =
  abs (row - kingRow) <= 1 && abs (col - kingCol) <= 1

-- Verifica se há peças entre duas posições (para ataques de torre, bispo e rainha)
hasPieceBetween :: Board -> Position -> Position -> Bool
hasPieceBetween board (row1, col1) (row2, col2)
  | row1 == row2 = any (\col -> board !! row1 !! col /= '#') [min col1 col2 + 1 .. max col1 col2 - 1]
  | col1 == col2 = any (\row -> board !! row !! col1 /= '#') [min row1 row2 + 1 .. max row1 row2 - 1]
  | otherwise =
      let diagonal =
            zip
              [row1 + step row1 row2, row1 + 2 * step row1 row2 .. row2 - step row1 row2]
              [col1 + step col1 col2, col1 + 2 * step col1 col2 .. col2 - step col1 col2]
       in any (\(r, c) -> board !! r !! c /= '#') diagonal
  where
    step a b = if a < b then 1 else -1