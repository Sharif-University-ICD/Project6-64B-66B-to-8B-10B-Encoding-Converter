module tb_converter ();

    reg clk;
    reg rst;
    reg en;
    reg error_injection_enable;
    reg [65:0] din_66b;
    reg kin;
    wire [79:0] dout_original;
    wire [79:0] dout_corrupted;
    wire disp_err_original;
    wire disp_err_corrupted;
    wire kin_err_original;
    wire kin_err_corrupted;
    wire [63:0] chunk_original;
    wire [63:0] chunk_corrupted;

    // Instantiate the top module
    converter uut (
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

        #20;
        en = 1;
        error_injection_enable = 1;
        din_66b = 66'h0000000000000000;
        kin = 0;
        #40;
        en = 0;
        #20;
        $display("input: %b", din_66b);
        $display("chunk original:\n%b\nchunk corrupted:\n%b\ndout original:\n%b\ndout corrupted:\n%b\nchunk sub:\n%b\ndout sub:\n%b", chunk_original, chunk_corrupted, dout_original, dout_corrupted, chunk_original-chunk_corrupted, dout_original-dout_corrupted);
        $display("disparity error original: %b | disparity error corrupted: %b", disp_err_original, disp_err_corrupted);
        $display("kin error original: %b | kin error corrupted: %b", kin_err_original, kin_err_corrupted);
        $display("-------------------------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20;
        en = 1;
        error_injection_enable = 1;
        din_66b = 66'hFFFFFFFFFFFFFFFF;
        kin = 0;
        #40;
        en = 0;
        #20;
        $display("input: %b", din_66b);
        $display("chunk original:\n%b\nchunk corrupted:\n%b\ndout original:\n%b\ndout corrupted:\n%b\nchunk sub:\n%b\ndout sub:\n%b", chunk_original, chunk_corrupted, dout_original, dout_corrupted, chunk_original-chunk_corrupted, dout_original-dout_corrupted);
        $display("disparity error original: %b | disparity error corrupted: %b", disp_err_original, disp_err_corrupted);
        $display("kin error original: %b | kin error corrupted: %b", kin_err_original, kin_err_corrupted);
        $display("-------------------------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20;
        en = 1;
        error_injection_enable = 1;
        din_66b = 66'h1111111111111111;
        kin = 0;
        #40;
        en = 0;
        #20;
        $display("input: %b", din_66b);
        $display("chunk original:\n%b\nchunk corrupted:\n%b\ndout original:\n%b\ndout corrupted:\n%b\nchunk sub:\n%b\ndout sub:\n%b", chunk_original, chunk_corrupted, dout_original, dout_corrupted, chunk_original-chunk_corrupted, dout_original-dout_corrupted);
        $display("disparity error original: %b | disparity error corrupted: %b", disp_err_original, disp_err_corrupted);
        $display("kin error original: %b | kin error corrupted: %b", kin_err_original, kin_err_corrupted);
        $display("-------------------------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20;
        en = 1;
        error_injection_enable = 1;
        din_66b = 66'h123456789ABCDEF;
        kin = 0;
        #40;
        en = 0;
        #20;
        $display("input: %b", din_66b);
        $display("chunk original:\n%b\nchunk corrupted:\n%b\ndout original:\n%b\ndout corrupted:\n%b\nchunk sub:\n%b\ndout sub:\n%b", chunk_original, chunk_corrupted, dout_original, dout_corrupted, chunk_original-chunk_corrupted, dout_original-dout_corrupted);
        $display("disparity error original: %b | disparity error corrupted: %b", disp_err_original, disp_err_corrupted);
        $display("kin error original: %b | kin error corrupted: %b", kin_err_original, kin_err_corrupted);
        $display("-------------------------------------------------------------------------------------");

        rst = 1;
        #10; // Hold reset for 10ns
        rst = 0;

        #20;
        en = 1;
        error_injection_enable = 1;
        din_66b = 66'h123456789ABCDEF;
        kin = 0;
        #40;
        en = 0;
        #20;
        $display("input: %b", din_66b);
        $display("chunk original:\n%b\nchunk corrupted:\n%b\ndout original:\n%b\ndout corrupted:\n%b\nchunk sub:\n%b\ndout sub:\n%b", chunk_original, chunk_corrupted, dout_original, dout_corrupted, chunk_original-chunk_corrupted, dout_original-dout_corrupted);
        $display("disparity error original: %b | disparity error corrupted: %b", disp_err_original, disp_err_corrupted);
        $display("kin error original: %b | kin error corrupted: %b", kin_err_original, kin_err_corrupted);
        $display("-------------------------------------------------------------------------------------");
        $finish;
    end

endmodule
