module converter (
    input wire clk,                     // Clock signal
    input wire rst,                     // Reset signal
    input wire en,                      // Enable signal
    input wire error_injection_enable,  // Error injection enable signal
    input wire [65:0] din_66b,          // 66-bit input (64-bit data + 2-bit sync)
    input wire kin,                     // Control character
    output wire [63:0] chunk_original,
    output wire [63:0] chunk_corrupted,
    output wire [79:0] dout_original,   // 8 x 10-bit output
    output wire [79:0] dout_corrupted,  // 8 x 10-bit corrupted output
    output wire disp_err_original,      // Disparity error original data
    output wire disp_err_corrupted,     // Disparity error cottupted data
    output wire kin_err_original,       // Original control character error
    output wire kin_err_corrupted       // Corrupted control character error
);

// Extract 2 sync bits and 64-bit data
wire [1:0] sync_bits = din_66b[65:64];
wire [63:0] data_64b = din_66b[63:0];

// Intermediate wires for each encoder instance
wire [7:0] data_chunk_original[7:0];
wire [7:0] data_chunk_corrupted[7:0];

wire [9:0] encoded_chunk_original[7:0];
wire [9:0] encoded_chunk_corrupted[7:0];

wire [7:0] disparity_original;
wire [7:0] disparity_corrupted;

wire [7:0] kin_err_chunk_original;
wire [7:0] kin_err_chunk_corrupted;

// Assign each 8-bit data chunk
genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin
    assign data_chunk_original[i] = data_64b[(i+1)*8-1 : i*8];

    error_injection #(
      .ERROR_RATE(1),
      .NUM_BITS(1),
      .WIDTH(8)
    ) error_injection_1 (
      .clk(clk),
      .rst(rst),
      .en(error_injection_enable),
      .din(data_chunk_original[i]),
      .dout(data_chunk_corrupted[i])
    );

  end
endgenerate

// Instantiate 8 encoder_8b10 modules
genvar j;
generate
    for (j = 0; j < 8; j = j + 1) begin : ENCODER_INSTANCES
        encoder_8b10 encoder_inst_original (
          .clk(clk),
          .rst(rst),
          .en(en),
          .kin(kin),
          .data_in(data_chunk_original[j]),
          .data_out(encoded_chunk_original[j]),
          .disp(disparity_original[j]),
          .kin_err(kin_err_chunk_original[j])
        );

        encoder_8b10 encoder_inst_corrupted (
          .clk(clk),
          .rst(rst),
          .en(en),
          .kin(kin),
          .data_in(data_chunk_corrupted[j]),
          .data_out(encoded_chunk_corrupted[j]),
          .disp(disparity_corrupted[j]),
          .kin_err(kin_err_chunk_corrupted[j])
        );
    end
endgenerate


// Combine all 8-bit inputs
assign chunk_original = {data_chunk_original[7], data_chunk_original[6], data_chunk_original[5], data_chunk_original[4], 
                    data_chunk_original[3], data_chunk_original[2], data_chunk_original[1], data_chunk_original[0]};

assign chunk_corrupted = {data_chunk_corrupted[7], data_chunk_corrupted[6], data_chunk_corrupted[5], data_chunk_corrupted[4], 
                    data_chunk_corrupted[3], data_chunk_corrupted[2], data_chunk_corrupted[1], data_chunk_corrupted[0]};

// Combine all 10-bit outputs
assign dout_original = {encoded_chunk_original[7], encoded_chunk_original[6], encoded_chunk_original[5], encoded_chunk_original[4],
                    encoded_chunk_original[3], encoded_chunk_original[2], encoded_chunk_original[1], encoded_chunk_original[0]};

assign dout_corrupted = {encoded_chunk_corrupted[7], encoded_chunk_corrupted[6], encoded_chunk_corrupted[5], encoded_chunk_corrupted[4],
                    encoded_chunk_corrupted[3], encoded_chunk_corrupted[2], encoded_chunk_corrupted[1], encoded_chunk_corrupted[0]};

// Combine disparity error signals
assign disp_err_original = |{disparity_original[0], disparity_original[1], disparity_original[2], disparity_original[3], 
                    disparity_original[4], disparity_original[5], disparity_original[6], disparity_original[7]};

assign disp_err_corrupted = |{disparity_corrupted[0], disparity_corrupted[1], disparity_corrupted[2], disparity_corrupted[3], 
                    disparity_corrupted[4], disparity_corrupted[5], disparity_corrupted[6], disparity_corrupted[7]};

// Combine control character error signals
assign kin_err_original = |{kin_err_chunk_original[0], kin_err_chunk_original[1], kin_err_chunk_original[2], kin_err_chunk_original[3],
                    kin_err_chunk_original[4], kin_err_chunk_original[5], kin_err_chunk_original[6], kin_err_chunk_original[7]};

assign kin_err_corrupted = |{kin_err_chunk_corrupted[0], kin_err_chunk_corrupted[1], kin_err_chunk_corrupted[2], kin_err_chunk_corrupted[3],
                    kin_err_chunk_corrupted[4], kin_err_chunk_corrupted[5], kin_err_chunk_corrupted[6], kin_err_chunk_corrupted[7]};

endmodule
