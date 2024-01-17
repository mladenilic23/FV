clear -all
analyze -sv09 {sort.sv} 
elaborate -top {sort}
clock clk 
reset rst
prove -bg -all
