%assigning types
int: menu_length;
int: money_limit;
set of int: range;


%defining data
array[range] of int: menu_prices;
array[range] of string: menu_names;
array[range] of int: yumyum_factors;

%variables
array[range] of var 0..(money_limit div min(menu_prices)): order;

%constraints
%%constraint forall([order[i] >= 0 | i in range]);
constraint assert(menu_length>=1, "Menu_length must be a positive integer");
constraint sum([order[i] * menu_prices[i] | i in range]) <= money_limit;

solve maximize(sum([yumyum_factors[i]*order[i] | i in range]));

output [menu_names[i] ++ ": " ++ show(order[i]) ++ "\n" | i in range];