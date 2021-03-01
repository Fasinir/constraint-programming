%defining data
int: N;
set of int: range=1..N;
include "alldifferent.mzn";

%variables
array[range] of var range: rows;

%constraints
constraint alldifferent(rows);
%diagonal constraints
constraint forall(i,j in range)(if i!=j then rows[i]+i!=rows[j]+j endif);
constraint forall(i,j in range)(if i!=j then rows[i]-i!=rows[j]-j endif);

solve satisfy; 

output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];
