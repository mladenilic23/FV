checker blackbox_checker (clk,
 		  				  rst,
        	  			  x,
			  			  y);

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	logic x_s;
	
	always @(posedge clk)
		x_s <= rst ? 1'b0 : x;
   	
	a1: assert property (y[0] |=> ~y[0]);

	a2: assert property (s_eventually y[2]);

	a3: assert property (y[1] |=> (y[3] s_until y[4]));

	a4: assert property ((y[2] ##1 y[5]) |=> y[6]);

	a5: assert property (~y[2][*3] |-> y[7]);

	a6: assert property (y[8][*2:3] ##1 ~y[9] ##1 y[10]);

	a7:assert property (y[0] |=> y[1] ^ y[11]);

	a8: assert property (y[2][->2] |=> y[16]);

	a9: assert property (y[28:17][=3] |=> y[15]);

	c10: cover property  (y[29][*10]);

	r11: assume property (~(x[0] && x[1])); //nista se ne desi
	a11: assert property (~(y[30] && y[31]));

endchecker
