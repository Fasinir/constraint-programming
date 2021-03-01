int: N;

array[0..N-1] of var 0..N: magic;

constraint forall(i in 0..N-1)(magic[i]=sum(j in 0..N-1)(magic[j]==i));
constraint assert(N>0,"N must be a positive integer");
solve satisfy;

output [ "magic sequence = ", show(magic),";\n"];
