module loadSize(
	input logic [31:0] mdr,
	input logic [1:0] LSControl,
	output logic [31:0] lsOut
);

always @ (*) begin
	if(LSControl == 2'b01) begin // word
		lsOut = mdr;
	end else if(LSControl == 2'b10) begin // halfword			Preenche os bits restantes para 32 com "0"s		
		lsOut = {16'b0, mdr[15:0]};//									O resultado vai para o MemToReg e será escrito em um registrador
	end else if (LSControl == 2'b11) begin // byte
		lsOut = {24'b0, mdr[7:0]};
	end
end

endmodule: loadSize