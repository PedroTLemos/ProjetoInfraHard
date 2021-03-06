module aluSrcA(input logic [1:0] muxalusrca,
input logic [31:0] pcOut,
input logic [31:0] registerAOut,
input logic [31:0] mdrOut,
output logic [31:0] aluSrcAOut // saida do mux do aluSrcA
);

always 
	case (muxalusrca)
		2'd0: begin
			  aluSrcAOut = pcOut;
		end
		2'd1: begin
			aluSrcAOut = registerAOut;
		end
		2'd2: begin
			aluSrcAOut = mdrOut;
		end
	endcase
	
endmodule
