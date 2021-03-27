module memToReg(
	input logic [31:0] Saida,//0
	input logic [31:0] lsOut,//1
	input logic [31:0] hiOut,//2
	input logic [31:0] loOut,//3
	input logic [31:0] ltOut, // 4     esta � a sa�da que vem do LT da ULA e que passa pelo sign extend 1:32
	input logic [31:0] inst15_0_Extend, // 5     16 primeiros bits da instrução extendidos para 32 bits com "0"s para números positivos e "1"s para negativos
	input logic [31:0] inst15_0_Shift, // 6      Após a extensão, faz shifleft de 16 bits do resultado
	input logic [31:0] shiftOut, // 7
	input logic [31:0] XchgOut, // 8
	output logic [31:0] memToRegOut,
	input logic [3:0]memToRegmux
);

parameter  stackStart = 32'd227;



always
	case(memToRegmux)
		4'b0000: memToRegOut = Saida;
		4'b0001: memToRegOut = lsOut;
		4'b0010: memToRegOut = hiOut;
		4'b0011: memToRegOut = loOut;
		4'b0100: memToRegOut = ltOut;
		4'b0101: memToRegOut = inst15_0_Extend;
		4'b0110: memToRegOut = inst15_0_Shift;
		4'b0111: memToRegOut = shiftOut;
		4'b1000: memToRegOut = XchgOut;
		4'b1001: memToRegOut = stackStart;
		
	endcase
	
endmodule: memToReg