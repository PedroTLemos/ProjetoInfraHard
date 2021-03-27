module pcSource(input logic [2:0] muxpcsource,
input logic [31:0] aluResult,
input logic [31:0] S,
input logic [31:0] shiftLeft2Out,
input logic [31:0] epcOut,
input logic [31:0] mdr,
output logic [31:0] pcSourceOut // saida do mux do pcSource
);


always 
	case (muxpcsource)
		3'd0: begin
			  pcSourceOut = aluResult;
		end
		3'd1: begin
			pcSourceOut = S;
		end
		3'd2: begin
			pcSourceOut = shiftLeft2Out;
		end
		3'd3: begin
			pcSourceOut = epcOut;
		end
		3'd4: begin
			pcSourceOut = mdr;
		end
	endcase
	
endmodule