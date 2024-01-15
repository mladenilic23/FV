module hanoi #(parameter S = 4)
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

		//Invalid values of fr and to
		assume_invalid_val:restrict property(fr != 2'b11 && to != 2'b11);

		//A disk from one tower can't be placed on itself
      	assume_only_valid:restrict property((fr == 2'b00 && to == 2'b01) | (fr == 2'b00 && to == 2'b10) | 	
                     				   		(fr == 2'b01 && to == 2'b00) | (fr == 2'b01 && to == 2'b10) | 				
				    	 				   	(fr == 2'b10 && to == 2'b00) | (fr == 2'b10 && to == 2'b01));

		//A disk can't be taken from an empty rod
		assume_empty0:restrict property(rod0 == 4'b0000 |=> ~(fr == 2'b00));
		assume_empty1:restrict property(rod1 == 4'b0000 |=> ~(fr == 2'b01));
		assume_empty2:restrict property(rod2 == 4'b0000 |=> ~(fr == 2'b10));

		//First move
		assume_start:restrict property(rod0 == 4'b1111 |-> (fr == 2'b00 && to == 2'b01));

		//It is not possible to move a disc that has just been moved
		restrict property(to == 2'b00 |=> ~(fr == 2'b00));
		restrict property(to == 2'b01 |=> ~(fr == 2'b01));
		restrict property(to == 2'b10 |=> ~(fr == 2'b10));

		//It is not possible to move the discs from one rod to the same other rod twice in a row
		//From rod0
		restrict property((fr == 2'b00 && to == 2'b01) |=> ~(fr == 2'b00 && to == 2'b01));
		restrict property((fr == 2'b00 && to == 2'b10) |=> ~(fr == 2'b00 && to == 2'b10));
		//From rod1
		restrict property((fr == 2'b01 && to == 2'b00) |=> ~(fr == 2'b01 && to == 2'b00));
		restrict property((fr == 2'b01 && to == 2'b10) |=> ~(fr == 2'b01 && to == 2'b10));
		//From rod2
		restrict property((fr == 2'b10 && to == 2'b00) |=> ~(fr == 2'b10 && to == 2'b00));
		restrict property((fr == 2'b10 && to == 2'b01) |=> ~(fr == 2'b10 && to == 2'b01));

		//It is not possible to move discs 3 times in a row FROM the same rod
		restrict property(fr == 2'b00 [*2] |=> ~(fr == 2'b00));
		restrict property(fr == 2'b01 [*2] |=> ~(fr == 2'b01));
		restrict property(fr == 2'b10 [*2] |=> ~(fr == 2'b10));

		//It is not possible to move discs 3 times in a row TO the same rod
		restrict property(to == 2'b00 [*2] |=> ~(to == 2'b00));
		restrict property(to == 2'b01 [*2] |=> ~(to == 2'b01));
		restrict property(to == 2'b10 [*2] |=> ~(to == 2'b10));

		//It is not possible to place a disc on the rod from which the previous two discs were removed
		restrict property(fr == 2'b00 [*2] |=> ~(to == 2'b00));
		restrict property(fr == 2'b01 [*2] |=> ~(to == 2'b01));
		restrict property(fr == 2'b10 [*2] |=> ~(to == 2'b10));

		//Until the moment when the largest disk is left alone on rod0 (It doesn't move from there)
		restrict property((to == 2'b01 ##1 to == 2'b10[*2] ##1 to == 2'b01) |=> to == 2'b00);

		//This restriction refers to the cycle after the previous restriction
		restrict property((to == 2'b01 ##1 to == 2'b10[*2] ##1 to == 2'b01 ##1 to == 2'b00) |=> to == 2'b01);

		final_cov: cover property(rod0 == 4'b0000 && rod1 == 4'b0000 && rod2 == 4'b1111);					   

endmodule
