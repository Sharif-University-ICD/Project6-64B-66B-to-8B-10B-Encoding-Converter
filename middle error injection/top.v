module top (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal
    input wire en,                // Enable signal
    input wire [65:0] din_66b,    // 66-bit input (64-bit data + 2-bit sync)
    input wire kin,               // Control character
    input wire error_injection_enable,
    output wire [79:0] dout_original,   // 8 x 10-bit output
    output wire [79:0] dout_corrupted,  // 8 x 10-bit corrupted output
    output wire disp_err_original,      // Disparity error original data
    output wire disp_err_corrupted,     // Disparity error cottupted data
    output wire kin_err_original,       // Original control character error
    output wire kin_err_corrupted,       // Corrupted control character error

    output wire [63:0] chunk_original,
    output wire [63:0] chunk_corrupted
);
    // Instantiate the converter module
    converter converter_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .error_injection_enable(error_injection_enable),
        .din_66b(din_66b),
        .kin(kin),
        .chunk_original(chunk_original),
        .chunk_corrupted(chunk_corrupted),
        .dout_original(dout_original),
        .dout_corrupted(dout_corrupted),
        .disp_err_original(disp_err_original),
        .disp_err_corrupted(disp_err_corrupted),
        .kin_err_original(kin_err_original),
        .kin_err_corrupted(kin_err_corrupted)
    );

endmodule