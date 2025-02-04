module top (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal
    input wire en,                // Enable signal
    input wire [65:0] din_66b,    // 66-bit input (64-bit data + 2-bit sync)
    input wire kin,               // Control character
    input wire error_injection_enable,
    output wire [79:0] dout_8b10, // 8 x 10-bit output
    output wire disp_err,         // Disparity error
    output wire kin_err,          // Control character error
    output wire [79:0] corrupted_data
);

    // Instantiate the converter module
    converter converter_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din_66b(din_66b),
        .kin(kin),
        .dout_8b10(dout_8b10),
        .disp_err(disp_err),
        .kin_err(kin_err)
    );

    // Instantiate the error injection module
    error_injection #(
        .ERROR_RATE(1),  // 1 in 100 chance of error
        .NUM_BITS(1)       // Flip 1 bit
    ) error_injection_inst (
        .clk(clk),
        .rst(rst),
        .en(error_injection_enable),
        .din(dout_8b10),
        .dout(corrupted_data)
    );
    
endmodule