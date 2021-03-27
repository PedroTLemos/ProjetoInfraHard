module xchgMux(input logic xchgControl,
input logic [31:0] A,
input logic [31:0] B,
output logic [31:0] S
);


always 
	case (xchgControl)
		1'd0: begin
			  S = A;
		end
		1'd1: begin
			S = B;
		end
	endcase
	
endmodule