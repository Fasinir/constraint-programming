%authors: Ernest Roszak & Filip Piwosz aka "Kustosze"

include "alldifferent.mzn";
include "inverse.mzn";
include "count_eq.mzn";
include "increasing.mzn";



int: n; % number of gangs
int: r; % number of rivalries

set of int: Gang = 1..n;  
set of int: Rival = 1..r;
set of int: STUDENTS=1..t;

int: t=sum(m);

array[Gang] of int: m;  % size of each gang
array[Rival] of Gang: g1;
array[Rival] of Gang: g2;
array[STUDENTS] of Gang: members = [ g | g in Gang, j in 1..m[g] ]; % returns gang for each student
%members[i]=j means student i is in j'th gang
array[STUDENTS] of var 0..3+2*(max(m)-1): score; % how many points each student gets
array[STUDENTS] of var STUDENTS: order ; % order the students arrive
%order[i]=j means on i'th position is student j 
array[1..t] of var 1..t: time; % for each student returns his time of arriving
%time[i]=j means i'th student is interviewed at j'th time (is j'th in order)

% Stage A

constraint alldifferent(time);
constraint alldifferent(order);
%%inverse between time and order
constraint inverse(time,order);

%getting leaders
array[Gang] of 1..(t - m[n]) + 1: leader = [if (i > 1) then sum([m[j] | j in Gang where j < i] ) + 1 else 1 endif | i in Gang] ;
%leader[i]=j means leader of gang i is j

%%NOTE
%we use a lot of leader[i]..leader[i]+m[i]-1
%this means that we enumerate for all members of i'th gang
%some lines start with leader[i]+1 that means we skip the leader for this constraint


%%no 2 gang members can be interviewd one after another
constraint forall(i in Gang)
  (    
    forall
    (j in leader[i] .. leader[i]+m[i]-1,
     k in j+1 .. leader[i]+m[i]-1)
        
        (abs( time[j] - time[k]) > 1)
  );
%redundant
constraint forall(i in 1..t-1)
  (
    members[order[i]]!=members[order[i+1]]
  );
  
int:morning=(t div 2);

%leader is interviewed before or after morning
%only used for stage A where there are no rivarlies
constraint (r==0) -> forall(i in Gang)
  (
  if(  time[leader[i]] < morning)
    then
    score[leader[i]]=3
    else
    score[leader[i]]=0
  endif
  );

%%before or after leader is interviewed
constraint forall(i in 1..n)
  (
  forall (j in leader[i]+1 .. leader[i]+m[i]-1 )
    (
      if( time[j] < time[leader[i]])
        then 
        score[j] = 1
        else 
        score[j] = 0
        endif
    )
  );

%  STAGE B  

%no 2 members of rival gangs can be next to each other
constraint forall(i in 1..r)
  (
    forall( j in leader[g1[i]] .. leader[g1[i]]+m[g1[i]]-1,
            k in leader[g2[i]] .. leader[g2[i]]+m[g2[i]]-1 )
            (
                abs( time[k] - time[j] ) > 1
            )
  );
%redundant
constraint forall(i in 1..r, j in 1..t-1)
  (
  
    ( members[order[j]] == g1[i] -> members[order[j+1]] != g2[i] )
    /\
    ( members[order[j]] == g2[i] -> members[order[j+1]] != g1[i] )
  );

predicate snitching
(var 1..n: firstGang, var 1..n: secondGang)=
(
  let 
  {
  var 1..t: firstLeader = leader[firstGang],
  var 1..t: firstGangSize=m[firstGang],
  var 1..t: secondLeader=leader[secondGang],
  var 1..t: lastGangMember=secondLeader+m[secondGang]-1
  }
  in
    %if gang leader is interviewed after another rival gang
    %we compare only times of leader and last member, because non-leaders are constrained to be sorted by time
    if ( time[firstLeader] > max( time[secondLeader], time[lastGangMember] ) )  
    then
      %then first leader snitches on his gang
      score[firstLeader] = 3 + 2 * sum ( [ bool2int(time[k] > time[firstLeader])| k in firstLeader+1 .. firstLeader+firstGangSize-1])
    %else we base points on whether the leader was interviewed before morning
    elseif (time[firstLeader] < morning)
    then 
      score[firstLeader]=3
    else
      score[firstLeader]=0
  endif
  );

constraint (r!=0)->forall(i in 1..r)(snitching(g1[i],g2[i]));
constraint (r!=0)->forall(i in 1..r)(snitching(g2[i],g1[i]));


%if a gang is not in g1 and g2
%then we assign the points based on time before/after morning

constraint (r!=0)-> forall  (i in Gang)
  (
    if ( count_eq(g1,i,0) /\ count_eq(g2,i,0) )
      then
      (
          if (time[leader[i]] < morning )
            then
            score[leader[i]] = 3
            else
            score[leader[i]] = 0
          endif
      )
    endif
  );


%symmetry breaking
%non-leaders are sorted
constraint symmetry_breaking_constraint
  (
    forall (i in Gang)(increasing([ time[j] | j in leader[i]+1 .. leader[i]+m[i]-1]))

  );

%some other redundant constraints
constraint (sum(i in 1..t) ( bool2int(score[i] <= 3+2*(max(m)-1) /\ score[i] >= 3+2*(min(m)-1)) )) <= min(n,r);
constraint (sum(i in 1..t) ( bool2int(score[i] == 3) )) <=n;
constraint (sum(i in 1..t) ( bool2int(score[i] == 1) )) <= sum(m)-n;
constraint (sum(i in 1..t) ( bool2int(score[i] == 0) )) <= sum(m);
constraint forall( i in Gang) ( ( bool2int(score[leader[i]] == 0 \/ (score[leader[i]] <= 3+2*(m[i]-1) /\ score[leader[i]] >= 3) ) ) == 1);
constraint forall( i in Gang) (forall(j in leader[i]+1.. leader[i]+m[i]-1) (  bool2int(score[j] == 0 \/ score[j] == 1) == 1 ));
constraint sum(time) = (t*(t+1)/2);
constraint sum(order) = (t*(t+1)/2);


solve ::  int_search(time,first_fail,indomain_median,complete)  maximize sum(score);

output
["order = "]++[show(order)]++
[";\nobj = "]++[show(sum(score))]++[";"];

