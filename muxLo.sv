module muxLo(
input logic [31:0] mult,
input logic [31:0] div,
input logic  loControl,
output logic [31:0] lo
);

always 
	case (loControl)
		1'd0: begin
			  lo = mult;
		end
		1'd1: begin
			lo = div;
		end
	endcase
	
endmodule
