clear -all
analyze -sv09 towers_of_hanoi.sv
elaborate -top hanoi
clock clk
reset rst
prove -bg -all
