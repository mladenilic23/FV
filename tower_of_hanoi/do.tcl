clear -all
analyze -sv09 tower_of_hanoi.sv
elaborate -top hanoi
clock clk
reset rst
prove -bg -all
