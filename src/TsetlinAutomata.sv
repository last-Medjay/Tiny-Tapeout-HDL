/*
module TsetlinAutomata
#(
	parameter Width = 8, //output width
	parameter N_states = 2**(Width-1)-1 //number of states in one action
)(
	input TA_clk_in, TA_rstn_in, TA_rwd_in, //TA clock, reset negative, reward input
	output TA_action_out, //TA action output
	output reg [Width-1:0] TA_state_out //TA state output
);

//initialize
initial begin
	TA_state_out <= N_states;
end

always @(posedge TA_clk_in or negedge TA_rstn_in) begin
	//reset TA
	if (!TA_rstn_in) begin
		TA_state_out <= N_states;
	//update state
	end else begin
		if (1<=TA_state_out && TA_state_out<=N_states && TA_rwd_in==0) begin
			TA_state_out <= TA_state_out + 1;
		end else if (N_states+1<=TA_state_out && TA_state_out<=2*N_states && TA_rwd_in==0) begin
			TA_state_out <= TA_state_out - 1;
		end else if (1<TA_state_out && TA_state_out<=N_states && TA_rwd_in==1) begin
			TA_state_out <= TA_state_out - 1;
		end else if (N_states+1<=TA_state_out && TA_state_out<2*N_states && TA_rwd_in==1) begin
			TA_state_out <= TA_state_out + 1;
		end else begin
			TA_state_out <= TA_state_out;
		end
	end
end

//assign TA action
assign TA_action_out = TA_state_out[Width-1];

endmodule
*/

module TsetlinAutomata #(
    parameter int Width    = 8,
    parameter int N_states = 2**(Width-1) - 1
)(
    input  logic clk,
    input  logic rstn,
    input  logic reward,
    output logic action,
    output logic [Width-1:0] state
);

    // Action: include/exclude (MSB of state)
    assign action = state[Width-1];

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= Width'(N_states);
        end else begin
            unique casez ({reward, state})
                // Penalize: exclude zone [1, N_states] → move toward include
                {1'b0, {1'b0, {(Width-1){1'b?}}}}: 
                    if (state >= 1 && state <= N_states)
                        state <= state + 1'b1;

                // Penalize: include zone [N_states+1, 2*N_states] → move toward exclude
                {1'b0, {1'b1, {(Width-1){1'b?}}}}: 
                    if (state >= N_states+1 && state <= 2*N_states)
                        state <= state - 1'b1;

                // Reward: exclude zone (1, N_states] → move toward exclude boundary
                {1'b1, {1'b0, {(Width-1){1'b?}}}}: 
                    if (state > 1 && state <= N_states)
                        state <= state - 1'b1;

                // Reward: include zone [N_states+1, 2*N_states) → move toward include boundary
                {1'b1, {1'b1, {(Width-1){1'b?}}}}: 
                    if (state >= N_states+1 && state < 2*N_states)
                        state <= state + 1'b1;

                default: state <= state;
            endcase
        end
    end

endmodule