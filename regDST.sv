module regDST(
	input logic [4:0] inst20_16, // 
	input logic [4:0] inst15_11, // 1
	input logic [4:0] inst25_21,// 4
	output logic [4:0] regDSTOut,
	input logic [2:0] regDSTmux
);

parameter  stackPointer = 5'd29;
parameter  returnReg = 5'd31;

always
	case(regDSTmux)
		3'b000: regDSTOut = inst20_16;
		3'b001: regDSTOut = inst15_11;
		3'b010: regDSTOut = stackPointer;
		3'b011: regDSTOut = returnReg;
		3'b100: regDSTOut = inst25_21;
	endcase
	
endmodule: regDST
