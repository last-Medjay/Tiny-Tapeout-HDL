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
