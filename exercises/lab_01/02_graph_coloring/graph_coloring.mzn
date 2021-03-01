% parameters
int: nodesNumber;
set of int: indexes=1..nodesNumber;
array[indexes,indexes] of bool: edges;

int: ChromaMax=max(i in indexes)(sum(j in indexes)(edges[i,j]==true))+1;

%variables
array[indexes] of var 1..ChromaMax: nodes;
var int: colorsNumber=max(nodes);

%constraints
constraint forall (i,j in indexes) (if edges[i,j]==true /\ i!=j then nodes[i]!=nodes[j] endif);

solve minimize(colorsNumber);

output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber];
      % ++["\n"++ show(ChromaMax)++"\n"];
