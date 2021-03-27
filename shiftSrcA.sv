module shiftSrcA(
input logic [31:0] A,
input logic [31:0] B,
input logic ShiftSrcA,
output logic [31:0] Source
);

always 
	case (ShiftSrcA)
		2'd0: begin
			Source = A;
		end
		2'd1: begin
			Source = B;
		end
	endcase
	
endmodule
