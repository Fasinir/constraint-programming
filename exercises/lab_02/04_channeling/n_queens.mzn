include "alldifferent.mzn";
include "lex_lesseq.mzn";

int: n;
set of int: indexes = 1..n;

%pierwszy model
%parametry
array[indexes] of var indexes: rows;
%ograniczenia dla pierwszego modelu
constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in indexes]);
constraint alldifferent([rows[i] - i | i in indexes]);

%drugi model
%data
array[1..n,1..n] of var bool: qb;

array[int] of var bool: qb0 = array1d(qb);
array[int] of var bool: qb1 = [ qb[j,i] | i,j in 1..n ];
array[int] of var bool: qb2 = [ qb[i,j] | i in reverse(1..n), j in 1..n ];
array[int] of var bool: qb3 = [ qb[j,i] | i in 1..n, j in reverse(1..n) ];
array[int] of var bool: qb4 = [ qb[i,j] | i in 1..n, j in reverse(1..n) ];
array[int] of var bool: qb5 = [ qb[j,i] | i in reverse(1..n), j in 1..n ];
array[int] of var bool: qb6 = [ qb[i,j] | i,j in reverse(1..n) ];
array[int] of var bool: qb7 = [ qb[j,i] | i,j in reverse(1..n) ];

%ograniczenia dla drugiego modelu
%rzędy
constraint forall(i in 1..n) (count_eq([qb[i,j] | j in 1..n],true, 1)); %count_eq(tablica, wartość, ile razy ta wartość ma być w tablicy)
%kolumny
constraint forall(i in 1..n) (count_eq([qb[j,i] | j in 1..n],true, 1));
%przekątne
constraint forall(a in 1-n..n-1)(sum(i,j in 1..n where i-j==a)(qb[i,j]==true) <=1);
constraint forall(a in 2..2*n)(sum(i,j in 1..n where i+j==a)(qb[i,j]==true) <=1);

constraint
    lex_lesseq(qb0,qb1)
/\  lex_lesseq(qb0,qb2)
/\  lex_lesseq(qb0,qb3)
/\  lex_lesseq(qb0,qb4)
/\  lex_lesseq(qb0,qb5)
/\  lex_lesseq(qb0,qb6)
/\  lex_lesseq(qb0,qb7)
;

%channeling
constraint forall (i,j in 1..n) ( qb[i,j] <-> (rows[i]=j) );
%modele są niezależne, usunięcie constraintów z jednego modelu nie wpływa na drugi
solve satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == n then "\n" else "" endif | i,j in 1..n];
