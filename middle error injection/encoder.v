module encoder_8b10
(
	input wire clk,             // Clock signal
	input wire rst,             // Reset signal
	input wire en,              // Enable signal
	input wire kin,             // K- or D-symbol selection (1 - K, 0 - D)
	input wire [7:0]data_in,    // 8-bit input data
	output wire [9:0]data_out,  // 10-bit encoded data
	output wire disp,           // Disparity output wire
	output wire kin_err         // K-symbol error output wire
);

reg tmp_disp;                   // Temporary disparity register                 
reg tmp_k_err;                  // Temporary K-symbol error register
reg [18:0]t;                    // Temporary register for encoding
reg [9:0]tmp_data_out;          // Temporary encoded data output
wire [7:0]tmp_data_in;          // Temporary input data
wire tmp_kin;                   // Temporary K-symbol selection

assign tmp_data_in = data_in;   // Assign input data to temporary input data
assign tmp_kin = kin;           // Assign K-symbol selection to temporary K-symbol selection

assign data_out = tmp_data_out; // Assign encoded data output to data_out
assign disp = tmp_disp;         // Assign disparity to disp
assign kin_err = tmp_k_err;     // Assign K-symbol error to kin_err

always @(posedge clk) begin
	if (rst) begin
		repeat (2) @(posedge clk);
		tmp_disp <= 1'b0;       
		tmp_k_err <= 1'b0;
		tmp_data_out <= 10'b0;
	end else begin
		if (en == 1'b1) begin
			repeat (2) @(posedge clk);
			tmp_disp <= ((tmp_data_in[5]&tmp_data_in[6]&tmp_data_in[7])|(!tmp_data_in[5]&!tmp_data_in[6]))^(tmp_disp^(((tmp_data_in[4]&tmp_data_in[3]&!tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0])|(!tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&tmp_data_in[2]&tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&tmp_data_in[0]&tmp_data_in[1]))))|(tmp_kin|(tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!tmp_data_in[2]&!tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&!tmp_data_in[0]&!tmp_data_in[1]))))));
			tmp_k_err <= (tmp_kin&(tmp_data_in[0]|tmp_data_in[1]|!tmp_data_in[2]|!tmp_data_in[3]|!tmp_data_in[4])&(!tmp_data_in[5]|!tmp_data_in[6]|!tmp_data_in[7]|!tmp_data_in[4]|!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&tmp_data_in[2]&tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&tmp_data_in[0]&tmp_data_in[1])))); 
			tmp_data_out[9] <= t[12]^t[0];
			tmp_data_out[8] <= t[12]^(t[1]|t[2]);
			tmp_data_out[7] <= t[12]^(t[3]|t[4]);
			tmp_data_out[6] <= t[12]^t[5];
			tmp_data_out[5] <= t[12]^(t[6]&t[7]);
			tmp_data_out[4] <= t[12]^(t[8]|t[9]|t[10]|t[11]);
			tmp_data_out[3] <= t[13]^(t[15]&!t[14]);
			tmp_data_out[2] <= t[13]^t[16];
			tmp_data_out[1] <= t[13]^t[17];
			tmp_data_out[0] <= t[13]^(t[18]|t[14]);
		end
	end
end
  
always @(posedge clk) begin
	if(rst) begin
		repeat (2) @(posedge clk);
		t <= 0;
	end else begin
		if (en == 1'b1) begin
			repeat (2) @(posedge clk);
			t[0] <= tmp_data_in[0];
			t[1] <= tmp_data_in[1]&!(tmp_data_in[0]&tmp_data_in[1]&tmp_data_in[2]&tmp_data_in[3]);
			t[2] <= (!tmp_data_in[0]&!tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3]);
			t[3] <= (!tmp_data_in[0]&!tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|tmp_data_in[2];
			t[4] <= tmp_data_in[4]&tmp_data_in[3]&!tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0];
			t[5] <= tmp_data_in[3]&!(tmp_data_in[0]&tmp_data_in[1]&tmp_data_in[2]);
			t[6] <= tmp_data_in[4]|((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!tmp_data_in[2]&!tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&!tmp_data_in[0]&!tmp_data_in[1]));
			t[7] <= !(tmp_data_in[4]&tmp_data_in[3]&!tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0]);
			t[8] <= (((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!tmp_data_in[4])|(tmp_data_in[4]&(tmp_data_in[0]&tmp_data_in[1]&tmp_data_in[2]&tmp_data_in[3]));
			t[9] <= tmp_data_in[4]&!tmp_data_in[3]&!tmp_data_in[2]&!(tmp_data_in[0]&tmp_data_in[1]);
			t[10] <= tmp_kin&tmp_data_in[4]&tmp_data_in[3]&tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0];
			t[11] <= tmp_data_in[4]&!tmp_data_in[3]&tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0];
			t[12] <= (((tmp_data_in[4]&tmp_data_in[3]&!tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0])|(!tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&tmp_data_in[2]&tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&tmp_data_in[0]&tmp_data_in[1]))))&!tmp_disp)|((tmp_kin|(tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!tmp_data_in[2]&!tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&!tmp_data_in[0]&!tmp_data_in[1])))|(!tmp_data_in[4]&!tmp_data_in[3]&tmp_data_in[2]&tmp_data_in[1]&tmp_data_in[0]))&tmp_disp);
			t[13] <= (((!tmp_data_in[5]&!tmp_data_in[6])|(tmp_kin&((tmp_data_in[5]&!tmp_data_in[6])|(!tmp_data_in[5]&tmp_data_in[6]))))&!(tmp_disp^(((tmp_data_in[4]&tmp_data_in[3]&!tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0])|(!tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&tmp_data_in[2]&tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&tmp_data_in[0]&tmp_data_in[1]))))|(tmp_kin|(tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!tmp_data_in[2]&!tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&!tmp_data_in[0]&!tmp_data_in[1])))))))|((tmp_data_in[5]&tmp_data_in[6])&(tmp_disp^(((tmp_data_in[4]&tmp_data_in[3]&!tmp_data_in[2]&!tmp_data_in[1]&!tmp_data_in[0])|(!tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&tmp_data_in[2]&tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&tmp_data_in[0]&tmp_data_in[1]))))|(tmp_kin|(tmp_data_in[4]&!((tmp_data_in[0]&tmp_data_in[1]&!tmp_data_in[2]&!tmp_data_in[3])|(tmp_data_in[2]&tmp_data_in[3]&!tmp_data_in[0]&!tmp_data_in[1])|(!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))))&!((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!tmp_data_in[2]&!tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&!tmp_data_in[0]&!tmp_data_in[1])))))));
			t[14] <= tmp_data_in[5]&tmp_data_in[6]&tmp_data_in[7]&(tmp_kin|(tmp_disp?(!tmp_data_in[4]&tmp_data_in[3]&((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&tmp_data_in[2]&tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&tmp_data_in[0]&tmp_data_in[1]))):(tmp_data_in[4]&!tmp_data_in[3]&((!((tmp_data_in[0]&tmp_data_in[1])|(!tmp_data_in[0]&!tmp_data_in[1]))&!tmp_data_in[2]&!tmp_data_in[3])|(!((tmp_data_in[2]&tmp_data_in[3])|(!tmp_data_in[2]&!tmp_data_in[3]))&!tmp_data_in[0]&!tmp_data_in[1])))));
			t[15] <= tmp_data_in[5];
			t[16] <= tmp_data_in[6]|(!tmp_data_in[5]&!tmp_data_in[6]&!tmp_data_in[7]);
			t[17] <= tmp_data_in[7];
			t[18] <= !tmp_data_in[7]&(tmp_data_in[6]^tmp_data_in[5]);
		end
	end
end

endmodule