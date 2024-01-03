module hanoi  #(parameter S = 4)
  	( 
	input clk,
    input rst,
	input [1:0] fr,
	input [1:0] to);
	
	logic [S-1:0] rod0; 
	logic [S-1:0] rod1;
	logic [S-1:0] rod2;

    always @(posedge clk)
      if (rst)
        begin
	    	rod0 <= 4'b1111;
    		rod1 <= 4'b0000;
	    	rod2 <= 4'b0000;
	    end
      else
        begin
			//from rod0 to rod1
        	if (fr == 2'b00 && to == 2'b01) begin
	        	rod0 = rod0 << 1;
		  		rod1 = rod1 >> 1;
		  		rod1 = rod1 | 4'b1000;
			end
			//from rod0 to rod2
	        if (fr == 2'b00 && to == 2'b10) begin
	        	rod0 = rod0 << 1;
		  		rod2 = rod2 >> 1;
		  		rod2 = rod2 | 4'b1000;
			end
			//from rod1 to rod0
			if (fr == 2'b01 && to == 2'b00) begin  
		  		rod1 = rod1 << 1;
		  		rod0 = rod0 >> 1;
		  		rod0 = rod0 | 4'b1000;
			end
			//from rod1 to rod2
			if(fr == 2'b01 && to == 2'b10) begin
  				rod1 = rod1 << 1;
			  	rod2 = rod2 >> 1;
		  		rod2 = rod2 | 4'b1000;
			end
			//from rod2 to rod0
			if(fr == 2'b10 && to == 2'b00) begin
		  		rod2 = rod2 << 1;
		  		rod0 = rod0 >> 1;
		  		rod0 = rod0 | 4'b1000;
			end
			//from rod2 to rod1
			if(fr == 2'b10 && to == 2'b01) begin		  
		  		rod2 = rod2 << 1;
		  		rod1 = rod1 >> 1;
		  		rod1 = rod1 | 4'b1000;
			end
		end


    	default clocking
        	@(posedge clk);
    	endclocking

    	default disable iff (rst); 

		//A disk from one tower can't be placed on itself
      	assume_only_valid:restrict property ((fr == 2'b00 && to == 2'b01) | (fr == 2'b00 && to == 2'b10) | 	
                     				   		 (fr == 2'b01 && to == 2'b00) | (fr == 2'b01 && to == 2'b10) | 				
				    	 				   	 (fr == 2'b10 && to == 2'b00) | (fr == 2'b10 && to == 2'b01));

		//A disk can't be taken from an empty rod
 		assume_empty_rod0: restrict property(fr == 2'b00 |-> ~(rod0 == 2'b0000));
    	assume_empty_rod1: restrict property(fr == 2'b01 |-> ~(rod1 == 2'b0000));
    	assume_empty_rod2: restrict property(fr == 2'b10 |-> ~(rod2 == 2'b0000)); 
	

		final_cov: cover property (rod0 == 4'b0000 && rod1 == 4'b0000 && rod2 == 4'b1111);					   

endmodule
