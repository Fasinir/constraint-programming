include "alldifferent.mzn";
include "cumulative.mzn";
include "diffn.mzn";
include "alldifferent.mzn";
int: nr; % number of reclaimers
int: number_of_rails=(nr +1) div 2;           % number of rails = nr for stages A,B,C,D,E
set of int: RAILS=1..number_of_rails;           % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
 
int: maxtime; % time considered
set of int: TIME = 0..maxtime;

int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time;
int: reclaim_time;
int: reclaim_speed;

array[STOCKPILE] of var POSITION: westend;
array[STOCKPILE] of var POSITION: eastend;
array[STOCKPILE] of var TIME: stack;
array[STOCKPILE] of var TIME: endstack;
array[STOCKPILE] of var TIME: reclaim;
array[STOCKPILE] of var TIME: finished;
array[STOCKPILE] of var RECLAIMER: which;

% Go crazy here

% Stage A - Packing Problem
% Two stockpiles can't overlap in "spacetime"

% 1) what's the relation between endstack and stack times
constraint forall (i in STOCKPILE)(endstack[i]=stack[i]+size[i]*stack_time);
% 2) what's the relation between finished and stack times
constraint forall(i in STOCKPILE)(finished[i]>stack[i]);% i'm really not sure if this is necessary
% 3) what's the relation between reclaim and endstack times
constraint forall(i in STOCKPILE)(reclaim[i]>=endstack[i]);
% 4) what's the relation between finished and reclam times
constraint forall(i in STOCKPILE)(finished[i]=reclaim[i]+size[i]*reclaim_time);
% 5) what's the relation between eastend and westend offsets
constraint forall (i in STOCKPILE)(eastend[i]=westend[i]+size[i]);

% 6) packing problem
%    a) stockpiles should not overlap in "spacetime", treat them as rectangles
array[STOCKPILE] of var TIME: total_time_spent;
constraint forall (i in STOCKPILE)(total_time_spent[i]=(finished[i]-stack[i]));

%if there is some problem with cumulatives just use this
%constraint forall (i in STOCKPILE)(total_time_spent[i]=abs(finished[i]-stack[i]));


constraint cumulative(stack,total_time_spent,size,len);
constraint cumulative(westend,size,total_time_spent,maxtime);
constraint diffn(stack,westend,total_time_spent,size);
%    b) stockpiles can't use more space than there is available
constraint forall(i in STOCKPILE)(eastend[i]<=len);
%    c) we can't go beyond the time limit
%constraint forall(i in TIME)(finished[i]<=maxtime);%%%%%%%





  
  
  
% Stage B 
% Two stockpiles reclaimed by the same reclaimer do not overlap in time
%
% Tip: write your first custom predicate, i.e.
% <something something> ;
predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) =
(which[s1]==which[s2])->
(
(reclaim[s1]>finished[s2])
\/
(reclaim[s2]>finished[s1])
);
constraint forall (i,j in STOCKPILE where i!=j)(not_overlap(i,j));





% Stage C
% 1) no stockpile can be reclaimed onto a ship before the arrival time of the ship
% 2) also no two stockpiles can be reclaimed onto the same ship at the same time. Make sure these reclaims do not overlap in time.
% TIP: reuse your "not_overlap" predicate
constraint forall (i in STOCKPILE)(reclaim[i]>=arrival[ship[i]]);
predicate not_overlap_on_ship(var STOCKPILE: s1, var STOCKPILE: s2) =
(ship[s1]==ship[s2])->
(
(reclaim[s1]>finished[s2])
\/
(reclaim[s2]>finished[s1])
);

constraint forall (i,j in STOCKPILE where i!=j)(not_overlap_on_ship(i,j));




% Stage D
% Add constraints to your model to ensure that if a reclaimer finishes reclaiming a stockpile with westend at x and then has to start reclaiming a stockpile with westend at y there is at least |y − x| ∗ reclaim speed time between these two events.
% TIP: just make your "not_overlap" predicate smarter
% TIP: you can introduce local variables in the constraints/predicates
% let {
%  <local variables>
% } in <then something>


predicate reclaimer_travel_time(var STOCKPILE: s1, var STOCKPILE: s2)=
(which[s1]==which[s2])->
(
  (
    (reclaim[s2]>finished[s1]) -> (reclaim[s2]>=finished[s1]+reclaim_speed*(abs(westend[s1]-westend[s2])))
  )
  /\
  (
    (reclaim[s1]>finished[s2])-> (reclaim[s1]>=finished[s2]+reclaim_speed*(abs(westend[s1]-westend[s2])))
  )
);

constraint forall(i,j in STOCKPILE where i!=j)(reclaimer_travel_time(i,j));



% Stage E
% Add a definition of the objective to your model and change the model to minimize this value.
% You may well need to significantly change your search strategy to get good solutions for the objective.

% TIP: definetely change the line below
array[SHIP] of var TIME: total_ship_waiting_time;
constraint forall(i in SHIP)
(
total_ship_waiting_time[i]=(max([finished[j] | j in STOCKPILE where ship[j]=i])-arrival[i])
);



var int: obj = sum(total_ship_waiting_time);





% Stage F
% Add constraints in your model so that the two reclaimers on rail i numbered 2i − 1 and 2i for i ∈ 1..nr div 2 remain so the western one 2i − 1 is never east of the eastern one 2i. Note they can legitimately be in the same position (this is for simplicity, its not very real). Note that if there are
% an odd number of reclaimers the last reclaimer is on its own rail and has no further constraints.
% TIP: do some "channeling" and model reclaimers' positions explicitely with a new array of variables.

%so there is this channeling, one side only (I think?)
%this array stores position of each reclaimer during reclaiming
array[TIME,RAILS,1..2] of var POSITION:reclaimer_at;
constraint 
forall(i in STOCKPILE)
(
  forall(j in reclaim[i]..finished[i])
    (
      reclaimer_at[j,((which[i]-1)div 2)+1,((which[i]+1) mod 2)+1]=westend[i]
    )
);

constraint forall (i in TIME)
(
forall(j in RAILS)
(reclaimer_at[i,j,1]<=reclaimer_at[i,j,2])
);
array[STOCKPILE] of var TIME: doing_nothing=[reclaim[i] - endstack[i] | i in STOCKPILE];

%don't uncomment these
solve::seq_search([
int_search(stack,smallest,indomain_min,complete),
int_search(doing_nothing,smallest,indomain_min,complete),
int_search(westend,first_fail,indomain_min,complete),
int_search(reclaim,smallest,indomain_min,complete),
%int_search(which,first_fail,indomain_min,complete),


%int_search(size,first_fail,indomain_max,complete),
%int_search(arrival,first_fail,indomain_max,complete),
%int_search(total_ship_waiting_time,smallest,indomain_min,complete),
]) minimize obj;
% don't change the output

output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;
