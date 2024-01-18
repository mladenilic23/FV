check_sec -analyze -spec -sv {MAC_module.sv} ;
check_sec -analyze -imp -sv {MAC_reg.sv} ;
check_sec -elaborate -spec -top mac_spec -bbox_mul 100 ;
check_sec -elaborate -imp -top mac_imp -bbox_mul 100 ;
check_sec -setup ;
check_sec -auto_map_reset_x_values off ;


reset rst
clock clk
check_sec -generate_verification -task <embedded>
check_sec -prove -bg
