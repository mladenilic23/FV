module sort #(parameter MAX_LEN = 100)(
    input logic clk,
    input logic rst,

    input logic ain_tvalid,
    output logic ain_tready,
    input logic [31:0] ain_tdata,
    input logic ain_tlast,

    output logic aout_tvalid,
    input logic aout_tready,
    output logic [31:0] aout_tdata,
    output logic aout_tlast
);

    typedef enum logic [1:0] {IDLE, SORT, DONE} state_t;

    // Internal signals and arrays
    logic [31:0] sort_array [0:MAX_LEN];
    int unsigned first_element = MAX_LEN;
    int unsigned length = 0;
    state_t current_state = IDLE;
    int unsigned out_counter = 0;
    int counter = 0;

    always_ff @(posedge clk) begin
        
		if (rst) begin
            // Reset state
            current_state <= IDLE;
            first_element <= MAX_LEN;
            length <= 0;
            out_counter <= 0;
            aout_tlast <= 0;
            aout_tdata <= 32'b0;
            aout_tvalid <= 0;
           ain_tready <= 0;
            foreach (sort_array[i]) sort_array[i] <= 32'b0;
        end else begin
        
            case (current_state)
            
                IDLE: begin
                    aout_tlast <= 0;
                    aout_tdata <= 32'b0;
            	    aout_tvalid <= 0; // Ensure aout_tvalid is deasserted
   /*                
		    		if (ain_tvalid && !ain_tready) begin
                        ain_tready <= 1; // Set ain_tready when ain_tvalid is asserted
                    end
                    if (ain_tvalid && ain_tready) begin
                        current_state <= SORT;
                    end
*/
					if (ain_tvalid) begin
          				current_state <= SORT;
          				ain_tready <= 1;
        			end 
                end
                
                SORT: begin

                    if (ain_tvalid) begin
                        counter = 0;
                        for (int i = 1; i <= MAX_LEN; i++) begin
                            if (i >= first_element && i <= first_element + length) begin
                                if (ain_tdata > sort_array[i]) begin
                                    counter++;
                                    sort_array[i-1] = sort_array[i];
                                end
                            end
                        end

                        sort_array[first_element - 1 + counter] = ain_tdata;
                        first_element--;
                        length++;
						
                        if (ain_tlast) begin
                            out_counter <= first_element + 1; //
                            aout_tdata <= sort_array[first_element];
                            current_state <= DONE;
                            ain_tready <= 0;
                        end
                    end
                end

                DONE: begin

        	    ain_tready  <= 0;
                    aout_tvalid <= 1;
                    if (aout_tready) begin
                        aout_tdata <= sort_array[out_counter];
                        out_counter++;
                    end
		    		if (out_counter == first_element + length) begin
                        aout_tlast <= 1;
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end

	default clocking
    	@(posedge clk);
	endclocking

	default disable iff (rst);

	// Once ain_tvalid/aout_tvalid is asserted it must remain asserted until handshake occurs
	r0: restrict property ((ain_tvalid && ~ain_tready) |=> ain_tvalid); 
	r1: restrict property ((aout_tvalid && ~aout_tready) |=> aout_tvalid);
    	
	// A situation in which a valid data is entered which is at the same time the last value
	r2: restrict property (~(ain_tvalid && ain_tready) |=> (~ain_tlast));
	r3: restrict property (~(aout_tvalid && aout_tready) |=> (~aout_tlast));

	r4: restrict property (((out_counter == first_element + length - 1) && aout_tvalid && aout_tready) |-> ##1 aout_tlast);

	// Restriction that limits transition from state to next state
	r5: restrict property (current_state == IDLE |-> s_eventually ~(current_state == DONE));
	r6: restrict property (current_state == SORT |-> s_eventually ~(current_state == IDLE));
	r7: restrict property (current_state == DONE |-> s_eventually ~(current_state == SORT));

	c0:cover property (current_state == IDLE);
	c1:cover property (current_state == SORT);
	c2:cover property (current_state == DONE);

	c3:cover property (ain_tvalid && ain_tready && ain_tlast);
	c4:cover property (aout_tvalid && aout_tready && aout_tlast);

endmodule

