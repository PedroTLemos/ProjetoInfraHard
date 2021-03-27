module branchMux(
input logic Igual,
input logic Maior,
input logic Menor,
input logic [5:0] Opcode,
output logic signal
);

always 
	case (Opcode)
		6'd4: begin
			  signal = Igual;
		end
		6'd5: begin
			if (Igual) begin
				signal = 0;
			end
			else begin
				signal = 1;
			end
		end
		6'd06: begin
			if (Maior) begin
				signal = 0;
			end
			else begin
				signal = 1;
			end
		end
		6'd07: begin
			signal = Maior;
		end
		default: begin
			signal = 0;
		end
	endcase
	
endmodule
