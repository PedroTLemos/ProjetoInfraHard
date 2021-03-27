module aluSrcB(input logic [1:0] muxalusrcb,
input logic [31:0] registerBOut,
input logic [31:0] signExtend16to32Out,
input logic [31:0] shiftLeft2Out2,
output logic [31:0] aluSrcBOut // saida do mux do aluSrcB
);


parameter pcMais4 = 3'd4;

always 
	case (muxalusrcb)
		2'd0: begin
			  aluSrcBOut = registerBOut;
		end
		2'd1: begin
			aluSrcBOut = pcMais4;
		end
		2'd2: begin
			aluSrcBOut = signExtend16to32Out;
		end
		2'd3: begin
			aluSrcBOut = shiftLeft2Out2;
		end
	endcase
	
endmodule
