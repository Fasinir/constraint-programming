set term postscript font "sans,9"        # can set pdf as well 
set output 'solution.sol.plt.ps'
set title "Pad & Machine Schedule for solution with obj value 114"
set autoscale
set xlabel 'Time' offset 0,-1.5
set ylabel 'Pad position'
set xtics out
set ytics out
unset colorbox
set border lw 0.5
set key outside above right horizontal
plot  '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle lt -1 fill empty, '-' with labels font "12" offset 0.5,0.5 notitle , '-' with linespoints ls 2 lw 6 title 'R_1', '-' with linespoints ls 3 lw 6 title 'R_2', '-' with linespoints ls 4 lw 6 title 'R_3'
# Dwell: putting first to have the empty fill pattern: x y xlow xhigh ylow yhigh (color?)
1 1 8 8 12 14
1 1 53 100 0 2
1 1 4 20 7 8
1 1 39 40 5 9
1 1 141 150 0 3
1 1 8 20 10 12
1 1 27 30 0 5
1 1 4 4 0 1
1 1 8 15 5 7
1 1 118 120 0 3
1 1 179 250 0 5
1 1 30 30 12 16
end
# Stacking: x y xlow xhigh ylow yhigh (color?)
1 1 0 8 12 14
1 1 45 53 0 2
1 1 0 4 7 8
1 1 23 39 5 9
1 1 129 141 0 3
1 1 0 8 10 12
1 1 7 27 0 5
1 1 0 4 0 1
1 1 0 8 5 7
1 1 106 118 0 3
1 1 159 179 0 5
1 1 14 30 12 16
end
# Reclaim: x y xlow xhigh ylow yhigh (color?)
1 1 8 14 12 14
1 1 100 106 0 2
1 1 20 23 7 8
1 1 40 52 5 9
1 1 150 159 0 3
1 1 20 26 10 12
1 1 30 45 0 5
1 1 4 7 0 1
1 1 15 21 5 7
1 1 120 129 0 3
1 1 250 265 0 5
1 1 30 42 12 16
end
# Whole boxes: x y xlow xhigh ylow yhigh (color?)
1 1 0 14 12 14 1
1 1 45 106 0 2 2
1 1 0 23 7 8 3
1 1 23 52 5 9 4
1 1 129 159 0 3 5
1 1 0 26 10 12 6
1 1 7 45 0 5 7
1 1 0 7 0 1 8
1 1 0 21 5 7 9
1 1 106 129 0 3 10
1 1 159 265 0 5 11
1 1 14 42 12 16 12
end
# Labels: x y text (rgbcolor)
8 13 1
76 1 2
12 7 3
39 7 4
145 1 5
14 11 6
28 2 7
4 0 8
11 6 9
119 1 10
214 2 11
30 14 12
end
 # Recl schedule: x y 
4 0
7 0
15 5
21 5
30 0
45 0
100 0
106 0
120 0
129 0
150 0
159 0
250 0
265 0
end
 # Recl schedule: x y 
8 12
14 12
20 10
26 10
30 12
42 12
end
 # Recl schedule: x y 
20 7
23 7
40 5
52 5
end
set title "\n\n\n\nThe input data: obj value 114 and:\n\n\neastend = [14, 2, 8, 9, 3, 12, 5, 1, 7, 3, 5, 16];\nendstack = [8, 53, 4, 39, 141, 8, 27, 4, 8, 118, 179, 30];\nfinish = [14, 106, 23, 52, 159, 26, 45, 7, 21, 129, 265, 42];\nreclaim = [8, 100, 20, 40, 150, 20, 30, 4, 15, 120, 250, 30];\nstack = [0, 45, 0, 23, 129, 0, 7, 0, 0, 106, 159, 14];\nwestend = [12, 0, 7, 5, 0, 10, 0, 0, 5, 0, 0, 12];\nwhich = [2, 1, 3, 3, 1, 2, 1, 1, 1, 1, 1, 2];\n" font "sans,12"
set yrange[-1:0]
unset ytics; unset xtics; unset border
plot x*x notitle

