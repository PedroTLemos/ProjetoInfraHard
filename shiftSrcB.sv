module shiftSrcB(
input logic [4:0] B,
input logic [4:0] Shamt,
input logic ShiftSrcB,
output logic [4:0] Shift
);

always 
	case (ShiftSrcB)
		2'd0: begin
			  Shift = B; // Desloca valor definido pelo registrador
		end
		2'd1: begin
			Shift = Shamt; // Desloca valor definido pela instrução
		end
	endcase
	
endmodule