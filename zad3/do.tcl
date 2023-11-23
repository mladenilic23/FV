clear -all
analyze -sv09 zad3_checker.sv bind.sv
analyze -vhdl zad3.vhd
elaborate -vhdl -top zad3
clock clk
reset rst
prove -bg -all
