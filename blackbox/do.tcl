clear -all
analyze -sv09 blackbox_checker.sv bind.sv
analyze -sv sv_model.sv
elaborate -top sv_model
clock clk
reset rst
prove -bg -all
