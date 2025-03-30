# Checkmate Detector

## Notação de Forsyth

A notação de Forsyth ou (Notação Forsyth-Edwards, FEN) é uma representação compacta do estado de um tabuleiro de xadrez. 

### Estrutura da FEN

Uma string FEN é composta por seis campos, separados por espaços, traço ou barra. Cada campo descreve um aspecto da posição do jogo.

#### Posição das peças no tabuleiro

O tabuleiro é descrito da oitava fileira (linha 8) até a primeira fileira (linha 1), da esquerda para a direita (da coluna "a" à coluna "h").

As peças são representadas por letras:

- Brancas: R (Rei), D (Dama), T (Torre), B (Bispo), C (Cavalo), P (Peão).
- Pretas: as mesmas letras, mas em minúsculas (r, d, t, b, c, p).

#### Exemplo

Estado inicial do tabuleiro:

```
tcbdrbct-pppppppp-8-8-8-8-PPPPPPPP-TCBDRBCT
```

```
tcbdkbct-pppp1ppp-5c2-5p2-5P2-5C2-PPPP1PPP-TCBDKBCT
```

- `tcbdkbct` (fileira 8: torre, cavalo, bispo, rainha, rei, bispo, cavalo, torre pretos).
- `pppp1ppp` (fileira 7: cinco peões pretos, uma casa vazia, dois peões pretos).
- `5c2` (fileira 6: cinco casas vazias, cavalo preto, duas casas vazias).
- `5p2` (fileira 5: cinco casas vazias, peão preto, duas casas vazias).
- `5P2` (fileira 4: cinco casas vazias, peão branco, duas casas vazias).
- `5C2` (fileira 3: cinco casas vazias, cavalo branco, duas casas vazias).
- `PPPP1PPP` (fileira 2: cinco peões brancos, uma casa vazia, dois peões brancos).
- `TCBDKBCT` (fileira 1: torre, cavalo, bispo, rainha, rei, bispo, cavalo, torre brancos).