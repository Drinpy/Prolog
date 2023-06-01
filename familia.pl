pai(gabriel, gael).
pai(pedro, natalia).
pai(ryan, diniz).
pai(amano, mariane).
pai(gael, andre).
pai(gael, neves).
pai(diniz, diane).
pai(andre, arena).
pai(neves, claudinei).
pai(jeremias, julia).
pai(afonso, jeremias).
pai(sergio, aurora).

mae(leticia, natalia).
mae(jade, gael).
mae(ana, diniz).
mae(patricia, mariane).
mae(natalia, andre).
mae(natalia, neves).
mae(mariane, diane).
mae(diane, arena).
mae(julia, claudinei).
mae(aurora, julia).
mae(isis, jeremias).
mae(aline, aurora).

irmao(X,Y) :-mae(Z,X),mae(Z,Y),X \= Y.

avoH(Z,Y):-pai(X,Y),pai(Z,X).
avoH(Z,Y):-mae(X,Y),pai(Z,X).

avoM(Z,Y):-mae(X,Y),mae(Z,X).
avoM(Z,Y):-pai(X,Y),mae(Z,X).

neto(Z,Y):-avoH(Y,Z).
neto(Z,Y):-avoM(Y,Z).

tio(Z,Y):-irmao(Z,X),pai(X,Y).
tio(Z,Y):-irmao(Z,X),mae(X,Y).

primo(Z,Y):-tio(P,Y),pai(P,Z).
primo(Z,Y):-tio(P,Y),mae(P,Z).






