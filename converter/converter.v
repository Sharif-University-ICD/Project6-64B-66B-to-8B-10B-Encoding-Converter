module converter (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal
    input wire en,                // Enable signal
    input wire [65:0] din_66b,    // 66-bit input (64-bit data + 2-bit sync)
    input wire kin,               // Control character
    output wire [79:0] dout_8b10, // 8 x 10-bit output
    output wire disp_err,         // Disparity error
    output wire kin_err           // Control character error
);

// Extract 2 sync bits and 64-bit data
wire [1:0] sync_bits = din_66b[65:64];
wire [63:0] data_64b = din_66b[63:0];

// Intermediate wires for each encoder instance
wire [7:0] data_chunk[7:0];
wire [9:0] encoded_chunk[7:0];
wire disparity[7:0];
wire kin_err_chunk[7:0];

// Assign each 8-bit data chunk
genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin
    assign data_chunk[i] = data_64b[(i+1)*8-1 : i*8];
  end
endgenerate

// Instantiate 8 encoder_8b10 modules
genvar j;
generate
    for (j = 0; j < 8; j = j + 1) begin : ENCODER_INSTANCES
        encoder_8b10 encoder_inst (
            .clk(clk),
            .rst(rst),
            .en(en),
            .kin(kin),
            .data_in(data_chunk[j]),
            .data_out(encoded_chunk[j]),
            .disp(disparity[j]),
            .kin_err(kin_err_chunk[j])
        );
    end
endgenerate

// Combine all 10-bit outputs
assign dout_8b10 = {encoded_chunk[7], encoded_chunk[6], encoded_chunk[5], encoded_chunk[4],
                    encoded_chunk[3], encoded_chunk[2], encoded_chunk[1], encoded_chunk[0]};

// Combine disparity and control character error signals
assign disp_err = |{disparity[0], disparity[1], disparity[2], disparity[3], 
                    disparity[4], disparity[5], disparity[6], disparity[7]};
assign kin_err = |{kin_err_chunk[0], kin_err_chunk[1], kin_err_chunk[2], kin_err_chunk[3],
                    kin_err_chunk[4], kin_err_chunk[5], kin_err_chunk[6], kin_err_chunk[7]};

endmodule
