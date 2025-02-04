module error_injection #(
    parameter ERROR_RATE = 1,  // Error rate (1 in ERROR_RATE chance of error)
    parameter NUM_BITS = 1,    // Number of bits to flip
    parameter WIDTH = 8
)(
    input wire clk,            // Clock signal
    input wire rst,            // Reset signal
    input wire en,             // Enable signal
    input wire [WIDTH-1:0] din,     // 80-bit input (8 x 10-bit encoded data)
    output wire [WIDTH-1:0] dout    // 80-bit output with injected errors
);

    reg [WIDTH-1:0] data_out;
    reg [31:0] lfsr;           // Linear Feedback Shift Register for pseudo-random number generation
    reg error_injected = 1'b0;

    assign dout = data_out;

    // LFSR for pseudo-random number generation
    always @(posedge clk) begin
        if (rst) begin
            lfsr <= $random;  // Seed value
            error_injected <= 1'b0;
        end else if (en && !error_injected) begin
            lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
        end
    end

    // Error injection logic
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 0;
        end else if (en && !error_injected) begin
            data_out <= din;  // Default to no error
            if (lfsr % ERROR_RATE == 0) begin  // Inject error with 1 in ERROR_RATE chance
                for (i = 0; i < NUM_BITS; i = i + 1) begin
                    data_out[lfsr % WIDTH] <= ~data_out[lfsr % WIDTH];  // Flip a random bit
                end
                error_injected <= 1'b1;
            end
        end
    end

endmodule