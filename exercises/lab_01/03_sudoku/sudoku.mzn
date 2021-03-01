include "alldifferent.mzn";

%parameters
int:S=3; 
int: N=S*S;
set of int: PuzzleRange=1..N;
set of int: SubSquareRange=1..S;
array[1..N,1..N] of 0..N: board;
%set of 1..N: PuzzleRange;
%set of 1..S: SubSquareRange;

%variable
array[PuzzleRange,PuzzleRange] of var PuzzleRange: puzzle;

%constraints
%start values
constraint forall(i in PuzzleRange,j in PuzzleRange)(if board[i,j]>0 then puzzle[i,j]=board[i,j] endif);

%columns
constraint forall (j in PuzzleRange) (alldifferent( [ puzzle[i,j] | i in PuzzleRange ]) );

%rows
constraint forall (j in PuzzleRange) (alldifferent([puzzle[j,i] | i in PuzzleRange]));

%subsquares
constraint forall (r,c in SubSquareRange) (alldifferent([puzzle[(c-1)*S+r2,(r-1)*S+c2] | r2,c2 in SubSquareRange]));


solve satisfy;



output [ show(puzzle[i,j]) ++ " " ++
  if j mod S == 0 then " " else "" endif ++ if j == N /\ i != N then
  if i mod S == 0 then "\n\n" else "\n" endif else "" endif
    | i,j in PuzzleRange ] ++ ["\n"];
