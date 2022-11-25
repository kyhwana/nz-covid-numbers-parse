set xdata time
set timefmt "%Y-%m-%dT%H:%M:%S"
set format x "%Y:%m:%d"
set datafile separator ","

set terminal png
set output "btstats.png"
set xtics rotate
set xlabel 'Time UTC'
set key autotitle columnhead
plot 'btstatslatest.txt' using 1:3 with lines, 'btstatslatest.txt' using 1:4 with lines
