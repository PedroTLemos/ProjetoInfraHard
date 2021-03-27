module iord(
	input logic [31:0] pcOut,
	input logic [31:0] S,
	input logic [31:0] Saida,
	output logic [31:0] iordOut,
	input logic [2:0]iordmux
);

parameter  OpCodeException = 32'd253;
parameter  OverflowException = 32'd254;
parameter  DivByZeroException = 32'd255;


always
	case(iordmux)
		3'b000: iordOut = pcOut;
		3'b001: iordOut = S;
		3'b010: iordOut = Saida;
		3'b011: iordOut = OpCodeException;
		3'b100: iordOut = OverflowException;
		3'b101: iordOut = DivByZeroException;
	endcase
	
endmodule: iord