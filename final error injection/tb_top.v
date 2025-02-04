module tb_top ();

    reg clk;
    reg rst;
    reg en;
    reg [65:0] din_66b;
    reg kin;
    reg error_injection_enable;
    wire [79:0] dout_8b10;
    wire disp_err;
    wire kin_err;
    wire [79:0] corrupted_data;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din_66b(din_66b),
        .kin(kin),
        .error_injection_enable(error_injection_enable),
        .dout_8b10(dout_8b10),
        .disp_err(disp_err),
        .kin_err(kin_err),
        .corrupted_data(corrupted_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20
        en = 1;
        din_66b = 66'h0000000000000000;
        kin = 0;
        error_injection_enable = 0;
        #20
        en = 0;
        #20;
        error_injection_enable = 1;
        #200;
        $display("input: %b", din_66b);
        $display("original output: \n%h\ncorrupted output: \n%h\nsub: \n%b", dout_8b10, corrupted_data, dout_8b10-corrupted_data);
        $display("----------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20
        en = 1;
        din_66b = 66'hFFFFFFFFFFFFFFFF;
        kin = 0;
        error_injection_enable = 0;
        #20
        en = 0;
        #20;
        error_injection_enable = 1;
        #200;
        $display("input: %b", din_66b);
        $display("original output: \n%h\ncorrupted output: \n%h\nsub: \n%b", dout_8b10, corrupted_data, dout_8b10-corrupted_data);
        $display("----------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20
        en = 1;
        din_66b = 66'h1111111111111111;
        kin = 0;
        error_injection_enable = 0;
        #20
        en = 0;
        #20;
        error_injection_enable = 1;
        #200;
        $display("input: %b", din_66b);
        $display("original output: \n%h\ncorrupted output: \n%h\nsub: \n%b", dout_8b10, corrupted_data, dout_8b10-corrupted_data);
        $display("----------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20
        en = 1;
        din_66b = 66'h0123456789ABCDEF;
        kin = 0;
        error_injection_enable = 0;
        #20
        en = 0;
        #20;
        error_injection_enable = 1;
        #200;
        $display("input: %b", din_66b);
        $display("original output: \n%h\ncorrupted output: \n%h\nsub: \n%b", dout_8b10, corrupted_data, dout_8b10-corrupted_data);
        $display("----------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20
        en = 1;
        din_66b = 66'hFEDCBA9876543210;
        kin = 0;
        error_injection_enable = 0;
        #20
        en = 0;
        #20;
        error_injection_enable = 1;
        #200;
        $display("input: %b", din_66b);
        $display("original output: \n%h\ncorrupted output: \n%h\nsub: \n%b", dout_8b10, corrupted_data, dout_8b10-corrupted_data);
        $display("----------------------------------------------------------------------");

        $finish;
    end

endmodule