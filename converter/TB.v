`timescale 1ns / 1ps

module tb_converter;

  // Inputs
  reg clk;
  reg rst;
  reg en;
  reg [65:0] din_66b;
  reg kin;

  // Outputs
  wire [79:0] dout_8b10;
  wire disp_err;
  wire kin_err;

  // Instantiate the module under test (MUT)
  converter uut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .din_66b(din_66b),
    .kin(kin),
    .dout_8b10(dout_8b10),
    .disp_err(disp_err),
    .kin_err(kin_err)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
  end

  // Test vectors and tasks
  task initialize_inputs;
    begin
      rst = 1;
      en = 0;
      din_66b = 66'b0;
      kin = 0;
    end
  endtask

  task reset_module;
    begin
      rst = 1;
      #10; // Hold reset for 10ns
      rst = 0;
    end
  endtask

  initial begin

    // Reset the module
    reset_module;

    // Test Cases
    // Test 1: All zeros input
    #20
    en = 1;
    din_66b = 66'b0;
    kin = 0;
    #20
    en = 0;
    #20
    $display("Test 1 - All zeros: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 2: All ones input
    #20
    en = 1;
    din_66b = 66'b1111111111111111111111111111111111111111111111111111111111111111;
    kin = 0;
    #20
    en = 0;
    #20
    $display("Test 2 - All ones: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 3: Alternate bits pattern
    #20
    en = 1;
    din_66b = 66'b1010101010101010101010101010101010101010101010101010101010101010;
    kin = 0;
    #20
    en = 0;
    #20
    $display("Test 3 - Alternate bits: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 4: Single control character
    #20
    en = 1;
    din_66b = 66'b1111111100000000000000000000000000000000000000000000000000000000;
    kin = 1;
    #20
    en = 0;
    #20
    $display("Test 4 - Single control char: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 5: Mixed data and control character
    #20
    en = 1;
    din_66b = 66'b1101010101010101110101010101010110101010101010101010101010101010;
    kin = 1;
    #20
    en = 0;
    #20
    $display("Test 5 - Mixed data/control: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 6: Edge case - MSB sync bits set
    #20
    en = 1;
    din_66b = {2'b11, 64'b0};
    kin = 0;
    #20
    en = 0;
    $display("Test 6 - MSB sync bits: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 7: Edge case - LSB sync bits set
    #20
    en = 1;
    din_66b = {64'b0, 2'b11};
    kin = 0;
    #20
    en = 0;
    #20
    $display("Test 7 - LSB sync bits: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 8: Random input with control character
    #20
    en = 1;
    din_66b = 66'h123456789ABCDEF;
    kin = 1;
    #20
    en = 0;
    #20
    $display("Test 8 - Random data with control: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // Test 9: Random input without control character
    #20
    en = 1;
    din_66b = 66'hFEDCBA987654321;
    kin = 0;
    #20
    en = 0;
    #20
    $display("Test 9 - Random data no control: dout_8b10 = %b, disp_err = %b, kin_err = %b", dout_8b10, disp_err, kin_err);
    reset_module;

    // End of test
    $finish;
  end

endmodule
