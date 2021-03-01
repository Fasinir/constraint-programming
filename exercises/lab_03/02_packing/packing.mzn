% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares
include "globals.mzn";

% Variables
%%%%%%%%%%%
var n..floor((n+1)*(n/2)): height;    % height of the container
var n..floor((n+1)*(n/2)): width;     % width of the conainer

%the top constraint for area is way too big but I guess thats something
var n*n.. floor((n+1)*(n/2)*(n+1)*(n/2)): area = height * width; % container's area

array[SQUARES] of var 0..floor((n+1)*(n)/2): x; % squares' coordinates in the container
array[SQUARES] of var 0..floor((n+1)*(n/2)): y; % squares' coordinated in the container

%extra variable
array[1..n] of 1..n:lengths=[i | i in SQUARES];
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Constraint 1: Squares should fit inside the container
constraint forall(i in SQUARES)(x[i]+i<=width /\ y[i]+i<=height);



% Constraint 2: Squares should not overlap

constraint cumulative(x,lengths,lengths,height);
constraint cumulative(y,lengths,lengths,width);

%some symmetry breaking
constraint height<=width;
constraint x[n]=0;
constraint y[n]=0;
%some redundant constraints
constraint width=max(i in SQUARES)(x[i]+i);
constraint height=max(j in SQUARES)(y[j]+j);
constraint diffn(x,y,lengths,lengths);
%unsure about this one
%constraint forall(i,j in SQUARES where i<j)
%(
%x[i]+i<=x[j] \/ 
%x[j]+j<=x[i] \/
%y[i]+i<=y[j] \/
%y[j]+j<=y[i]
%);

% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve::seq_search([int_search([width,height],input_order,indomain_min),
int_search(reverse(x),input_order,indomain_max),
int_search(reverse(y),input_order,indomain_max)]) minimize area; 
%solve minimize area;

% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)];