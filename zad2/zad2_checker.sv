checker zad2_checker ( 
		clk,
		rst,
  		a,
		b,
		c,
		d,
		e,
		f,
		o1,
		o2	
	) ;

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	logic a_s, b_s, c_s, d_s, e_s, f_s;

	always @(posedge clk)
		a_s <= rst ? 1'b0 : a;
	always @(posedge clk)
		b_s <= rst ? 1'b0 : b;
	always @(posedge clk)
		c_s <= rst ? 1'b0 : c;
	always @(posedge clk)
		d_s <= rst ? 1'b0 : d;
	always @(posedge clk)
		e_s <= rst ? 1'b0 : e;
	always @(posedge clk)
		f_s <= rst ? 1'b0 : f;

	assert property (o1 == o2);

endchecker
