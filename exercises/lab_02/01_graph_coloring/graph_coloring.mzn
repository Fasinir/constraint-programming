%copied from previous assignment
%basic parameters
int: nodesNumber;
set of int: indexes=1..nodesNumber;
array[indexes,indexes] of bool: edges;

int: ChromaMax=max(i in indexes)(sum(j in indexes)(edges[i,j]==true))+1;

%clique parameters
int: minColorsNumber;
set of int: CliqueIndexes=1..minColorsNumber;
array[CliqueIndexes] of 1..nodesNumber: maxClique;

%variables
array[indexes] of var 1..ChromaMax: nodes;
var int: colorsNumber=max(nodes);

%clique constraint
constraint forall (i in CliqueIndexes) (nodes[maxClique[i]]=i);
%basic constraint
constraint forall (i,j in indexes) (if edges[i,j]==true /\ i<j then nodes[i]!=nodes[j] endif);


solve minimize(colorsNumber);

output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber];
      % ++["\n"++ show(ChromaMax)++"\n"];
