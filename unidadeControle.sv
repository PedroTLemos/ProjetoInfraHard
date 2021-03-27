module unidadeControle( 
    input logic clk,
    input reset,

    //fios da instrucao
    input logic [5:0] funct,
    input logic [5:0] opcode,
    
    //flags da ula
    input logic Overflow,
    input logic Negativo,
    input logic z,
    input logic Igual,
    input logic Maior,
    input logic Menor,
    input logic multStop,
    input logic divStop,
    input logic divByZero,
    
    //sinais dos registradores
    output logic regwrite,
    output logic epcwrite,
    output logic irwrite,

    //sinais memorias
    output logic memwrite,
    
    //sinais pc
    output logic pcwrite,
    output logic pcwritecond,
    
    //sinais pro alu
    output logic [2:0] alucontrol,
    output logic aluoutwrite,

    //sinais div e mult
    output logic hiwrite,
    output logic lowrite,
    

    //sinal troca
    output logic xchgctrl,

    //sinal shiftreg
    output logic [2:0] shiftcontrol,

    //lb, lw, lh, sw,sb e sh control
    output logic [1:0] sscontrol,
    output logic [1:0] lscontrol,

    //muxes
    output logic [2:0] iordmux,
    output logic muxhi,
    output logic muxlo,
    output logic muxshiftsrca,
    output logic muxshiftsrcb,
    output logic [2:0]muxregdst,
    output logic [3:0] muxmemtoreg,
    output logic muxxchgctrl,
    output logic [1:0]muxalusrca,
    output logic [1:0]muxalusrcb,
    output logic [2:0]muxpcsource,
    output logic multBegin,
    output logic divBegin,
    output logic [6:0]state
    //estado atual
    
);

parameter fetch1 = 7'd0;
parameter fetch2 = 7'd1;
parameter fetch3 = 7'd2;
parameter decode = 7'd3;
parameter decode2 = 7'd4;
parameter wait_= 7'd5;
parameter execute = 7'd6;
parameter add_sub_and = 7'd7;
parameter addi_addiu = 7'd8;
parameter break2 = 7'd9;
parameter xchg2 = 7'd10;
parameter xchg3 = 7'd11;
parameter sll2 = 7'd13;
parameter sra2 = 7'd14;
parameter sll_sra_srl_sllv_srav = 7'd15;
parameter srl2 = 7'd16;
parameter sllv2 = 7'd17;
parameter srav2 = 7'd18;
parameter jal2 = 7'd19;
parameter jal3 = 7'd20;
parameter beq2 = 7'd21;
parameter bne2 = 7'd22;
parameter bgt2 = 7'd23;
parameter ble2 = 7'd24;
parameter lw2_wait = 7'd25;
parameter lw3 = 7'd26;
parameter lw4 = 7'd27;
parameter lh2_wait = 7'd28;
parameter lh3 = 7'd29;
parameter lh4 = 7'd30;
parameter lb2_wait = 7'd31;
parameter lb3 = 7'd32;
parameter lb4 = 7'd33;
parameter sw2 = 7'd34;
parameter sw3 = 7'd35;
parameter sh2 = 7'd36;
parameter sh3 = 7'd37;
parameter sb2 = 7'd38;
parameter sb3 = 7'd39;
parameter blm2_wait = 7'd40;
parameter blm3_wait = 7'd41;
parameter blm4 = 7'd42;
parameter mult2 = 7'd43;
parameter mult3 = 7'd44;
parameter div2 = 7'd45;
parameter div3 = 7'd46;
parameter overflowEx = 7'd47;
parameter overflowEx2 = 7'd48;
parameter overflowEx3 = 7'd49;
parameter overflowEx4 = 7'd50;
parameter divByZeroEx = 7'd51;
parameter divByZeroEx2 = 7'd52;
parameter divByZeroEx3 = 7'd53;
parameter divByZeroEx4 = 7'd54;
parameter opcodeEx = 7'd55;
parameter opcodeEx2 = 7'd56;
parameter opcodeEx3 = 7'd57;
parameter opcodeEx4 = 7'd58;
parameter closeWR = 7'd68;
parameter wait_Final = 7'd69;

//inst R
parameter formatR = 6'd0;
parameter sll = 6'd0;
parameter srl = 6'd2;
parameter sra = 6'd3;
parameter sllv = 6'd4;
parameter srav = 6'd7;
parameter xchg1 = 6'd5;
parameter jr = 6'd8;
parameter break1 = 6'd13;
parameter mfhi = 6'd16;
parameter mflo = 6'd18;
parameter rte = 6'd19;
parameter mult = 6'd24;
parameter div = 6'd26;
parameter andR = 6'd36;
parameter addR = 6'd32;
parameter subR = 6'd34;
parameter slt = 6'd42;

//inst I
parameter blm = 6'd1;
parameter addi = 6'd8;
parameter addiu = 6'd9;
parameter beq = 6'd4;
parameter bne = 6'd5;
parameter ble = 6'd6;
parameter bgt = 6'd7;
parameter slti = 6'd10;
parameter lui = 6'd15;
parameter lw = 6'd35;
parameter lh = 6'd33;
parameter lb = 6'd32;
parameter sw = 6'd43;
parameter sh = 6'd41;
parameter sb = 6'd40;

//inst j
parameter j = 6'd2;
parameter jal = 6'd3;


initial begin

state = fetch1;
  
end



always @(posedge clk) begin
	if (reset) begin
		 alucontrol = 3'd0;
		 aluoutwrite = 1'd0;
		 epcwrite = 1'd0;
		 hiwrite = 1'd0;
		 iordmux = 3'd4; // <-----
		 irwrite = 1'd0;
		 lowrite = 1'd0;
		 lscontrol = 2'd0;
		 memwrite  = 1'd0;
		 muxalusrca = 2'd0;
		 muxalusrcb = 2'd0;
		 muxhi = 1'd0;
		 muxlo = 1'd0;
		 muxmemtoreg = 4'd9; // 
		 muxpcsource = 2'd0;
		 muxregdst = 3'd2; // 
		 muxshiftsrca = 1'd0;
		 muxshiftsrcb = 1'd0;
		 muxxchgctrl = 1'd0;
		 pcwrite = 1'd0;
		 pcwritecond = 1'd0;
		 regwrite = 1'd1; //
		 shiftcontrol = 3'd0;
		 sscontrol = 2'd0;
		 state = fetch1;
		 xchgctrl = 1'd0;
		end
		else begin
			case (state)
				overflowEx: begin // PC-4 grava no EPC
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0; 
						 epcwrite = 1'd1; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd4; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = overflowEx2;
						 xchgctrl = 1'd0;
				end
				overflowEx2: begin
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd4; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 state = overflowEx3;
						 sscontrol = 2'd0;
						 xchgctrl = 1'd0;
				end
				overflowEx3: begin
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd4; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = overflowEx4;
						 xchgctrl = 1'd0;
				end
				overflowEx4: begin
						 alucontrol = 3'd2; 
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; 
						 hiwrite = 1'd0;
						 iordmux = 3'd4; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; 
						 muxalusrcb = 2'd1; 
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 3'd4; // < --- 
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd1; // <---
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = fetch1;
						 xchgctrl = 1'd0;
				end
				divByZeroEx: begin
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd1; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd5; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = divByZeroEx2;
						 xchgctrl = 1'd0;
				end
				divByZeroEx2: begin
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd5; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = divByZeroEx3;
						 xchgctrl = 1'd0;
				end
				divByZeroEx3: begin
					     alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd5; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = divByZeroEx4;
						   
						 xchgctrl = 1'd0;
				end
				divByZeroEx4: begin
						 alucontrol = 3'd2; 
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; 
						 hiwrite = 1'd0;
						 iordmux = 3'd5; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; 
						 muxalusrcb = 2'd1; 
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 3'd4; // < --- 
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd1; // <---
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = fetch1;
						   
						 xchgctrl = 1'd0;
				end
				opcodeEx: begin
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd01; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd3; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = opcodeEx2;
						   
						 xchgctrl = 1'd0;
				end
				opcodeEx2: begin
						alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd3; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = opcodeEx3;
						   
						 xchgctrl = 1'd0;
				end
				opcodeEx3: begin
						 alucontrol = 3'd2; //  <---
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; // <----
						 hiwrite = 1'd0;
						 iordmux = 3'd3; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; // <----
						 muxalusrcb = 2'd1; // <---
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = opcodeEx4;
						   
						 xchgctrl = 1'd0;
				end
				opcodeEx4: begin
						alucontrol = 3'd2; 
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0; 
						 hiwrite = 1'd0;
						 iordmux = 3'd3; // <----
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0;
						 muxalusrca = 2'd0; 
						 muxalusrcb = 2'd1; 
						 muxhi = 1'd0;
						 muxlo = 1'd0;
						 muxmemtoreg = 4'd9; 
						 muxpcsource = 3'd4; // < --- 
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd1; // <---
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						 state = fetch1;
						   
						 xchgctrl = 1'd0;
				end
				fetch1: begin // 
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd0;
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd0;
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd1;
					 muxhi = 1'd0;
					 muxlo = 1'd0;
					 muxmemtoreg = 4'd9; // 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; // 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; //
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					 state = fetch2;
					   
					 xchgctrl = 1'd0;
				end
				fetch2: begin // 
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd0;
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd0;
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd1;
					 muxhi = 1'd0;
					 muxlo = 1'd0;
					 muxmemtoreg = 4'd9; // 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; // 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd1;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; //
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					 state = fetch3;
					   
					 xchgctrl = 1'd0;
				end
				fetch3: begin // 
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd0;
					 iordmux = 2'd0;
					 irwrite = 1'd1;
					 lowrite = 1'd0;
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd1;
					 muxhi = 1'd0;
					 muxlo = 1'd0;
					 muxmemtoreg = 4'd9; // 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; // 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; //
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					 state = decode;
					   
					 xchgctrl = 1'd0;
				end
				decode: begin //
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd1;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd0;
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd0;
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd3;
					 muxhi = 1'd0;
					 muxlo = 1'd0;
					 muxmemtoreg = 4'd9; // 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; // 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; //
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					 state = decode2;
					   
					 xchgctrl = 1'd0;
				end
				decode2: begin // 
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd0;
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd0;
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd3;
					 muxhi = 1'd0;
					 muxlo = 1'd0;
					 muxmemtoreg = 4'd9; // 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; // 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; //
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					 state = execute;
					  
					 
					 xchgctrl = 1'd0;
				end
				execute: begin
					case (opcode)
						formatR: begin
							case (funct)
								andR: begin
									alucontrol = 3'd3; // funcao and
									aluoutwrite = 1'd1; // habilita escrita
									 
									epcwrite = 1'd0;
									hiwrite = 1'd0;
									iordmux = 2'd0;
									irwrite = 1'd0;
									lowrite = 1'd0;
									lscontrol = 2'd0;
									memwrite  = 1'd0;
									muxalusrca = 2'd1; // a
									muxalusrcb = 2'd0; // b
									muxhi = 1'd0;
									muxlo = 1'd0;
									muxmemtoreg = 4'd9; 
									muxpcsource = 2'd0;
									muxregdst = 3'd2;  
									muxshiftsrca = 1'd0;
									muxshiftsrcb = 1'd0;
									muxxchgctrl = 1'd0;
									pcwrite = 1'd0;
									pcwritecond = 1'd0;
									regwrite = 1'd0; 
									shiftcontrol = 3'd0;
									sscontrol = 2'd0;
									state = add_sub_and;
									  
									xchgctrl = 1'd0;
								end
								addR: begin
								    alucontrol = 3'd1; // funcao and
									aluoutwrite = 1'd1; // habilita escrita
									 
									epcwrite = 1'd0;
									hiwrite = 1'd0;
									iordmux = 2'd0;
									irwrite = 1'd0;
									lowrite = 1'd0;
									lscontrol = 2'd0;
									memwrite  = 1'd0;
									muxalusrca = 2'd1; // a
									muxalusrcb = 2'd0; // b
									muxhi = 1'd0;
									muxlo = 1'd0;
									muxmemtoreg = 4'd9; 
									muxpcsource = 2'd0;
									muxregdst = 3'd2;  
									muxshiftsrca = 1'd0;
									muxshiftsrcb = 1'd0;
									muxxchgctrl = 1'd0;
									pcwrite = 1'd0;
									pcwritecond = 1'd0;
									regwrite = 1'd0; 
									shiftcontrol = 3'd0;
									sscontrol = 2'd0;
									state = add_sub_and;
									  
									xchgctrl = 1'd0;
								end
								subR: begin
								    alucontrol = 3'd2; // funcao and
									aluoutwrite = 1'd1; // habilita escrita
									 
									epcwrite = 1'd0;
									hiwrite = 1'd0;
									iordmux = 2'd0;
									irwrite = 1'd0;
									lowrite = 1'd0;
									lscontrol = 2'd0;
									memwrite  = 1'd0;
									muxalusrca = 2'd1; // a
									muxalusrcb = 2'd0; // b
									muxhi = 1'd0;
									muxlo = 1'd0;
									muxmemtoreg = 4'd9; 
									muxpcsource = 2'd0;
									muxregdst = 3'd2;  
									muxshiftsrca = 1'd0;
									muxshiftsrcb = 1'd0;
									muxxchgctrl = 1'd0;
									pcwrite = 1'd0;
									pcwritecond = 1'd0;
									regwrite = 1'd0; 
									shiftcontrol = 3'd0;
									sscontrol = 2'd0;
									state = add_sub_and;
									  
									xchgctrl = 1'd0;
								end
								sll: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2; 
									 muxshiftsrca = 1'd1; // <---
									 muxshiftsrcb = 1'd1;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd1;// <--
									 sscontrol = 2'd0;
									 state = sll2;
									  
									 
									 xchgctrl = 1'd0;
								end
								srl: begin
									alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2; 
									 muxshiftsrca = 1'd1; // <---
									 muxshiftsrcb = 1'd1;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd1;// <--
									 sscontrol = 2'd0;
									 state = srl2;
									  
									  
									 xchgctrl = 1'd0;
								end
								sra: begin
									alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2; 
									 muxshiftsrca = 1'd1; // <---
									 muxshiftsrcb = 1'd1;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd1;// <--
									 sscontrol = 2'd0;
									 state = sra2;
									  
									  
									 xchgctrl = 1'd0;
								end
								sllv: begin
									alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2; 
									 muxshiftsrca = 1'd0; // <---
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd1;// <--
									 sscontrol = 2'd0;
									 state = sllv2;
									  
									  
									 xchgctrl = 1'd0;
								end
								srav: begin
									alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2; 
									 muxshiftsrca = 1'd0; // <---
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd1;// <--
									 sscontrol = 2'd0;
									 state = srav2;
									  
									  
									 xchgctrl = 1'd0;
								end
								jr: begin
									 alucontrol = 3'd0; // <---
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd1; // <---
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0; // <---
									 muxregdst = 3'd2;  
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd1; // <---
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = closeWR;
									  
									  
									 xchgctrl = 1'd0;
								end
								slt: begin
									 alucontrol = 3'd7; // <---
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd1; // <---
									 muxalusrcb = 2'd0; // <---
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd4; // <---
									 muxpcsource = 2'd0; 
									 muxregdst = 3'd1;  // <---
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0; 
									 pcwritecond = 1'd0;
									 regwrite = 1'd1; // <---
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = closeWR;
									  
									  
									 xchgctrl = 1'd0;
								end
						        break1: begin
									 alucontrol = 3'd2;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd1;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; // 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2; // 
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; //
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = break2;
									  
									  
									 xchgctrl = 1'd0;
						        end
								rte: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd9; // 
									 muxpcsource = 2'd3;
									 muxregdst = 3'd2; // 
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd1;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; //
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = closeWR;
									  
									  
									 xchgctrl = 1'd0;
								end
								xchg1: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0;
									 muxlo = 1'd0;
									 muxmemtoreg = 4'd8; // <--
									 muxpcsource = 2'd0;
									 muxregdst = 3'd0;  // <--
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0; // <--
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = xchg2;
									  
									  
									 xchgctrl = 1'd1; // <--
								end
								mult: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0; // <---	
									 muxlo = 1'd0; // <---	
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2;  
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; 
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = mult2;

									  
									 xchgctrl = 1'd0;
									 multBegin = 1'b1;	// <---						
								end
								mfhi: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0; 	
									 muxlo = 1'd0; 	
									 muxmemtoreg = 4'd2; // <---
									 muxpcsource = 2'd0;
									 muxregdst = 3'd1;  // <---
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd1; // <----
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = closeWR;

									  
									 xchgctrl = 1'd0;
									 multBegin = 1'b0;
									 divBegin = 1'b0; 
								end
								mflo: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd0; 	
									 muxlo = 1'd0; 	
									 muxmemtoreg = 4'd3; // <---
									 muxpcsource = 2'd0;
									 muxregdst = 3'd1;  // <---
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd1; // <----
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = closeWR;

									  
									 xchgctrl = 1'd0;
									 multBegin = 1'b0;
									 divBegin = 1'b0; 
								end
								div: begin
									 alucontrol = 3'd1;
									 aluoutwrite = 1'd0;
									  
									 epcwrite = 1'd0;
									 hiwrite = 1'd0;
									 iordmux = 2'd0;
									 irwrite = 1'd0;
									 lowrite = 1'd0;
									 lscontrol = 2'd0;
									 memwrite  = 1'd0; 
									 muxalusrca = 2'd0;
									 muxalusrcb = 2'd3;
									 muxhi = 1'd1; // <---	
									 muxlo = 1'd1; // <---	
									 muxmemtoreg = 4'd9; 
									 muxpcsource = 2'd0;
									 muxregdst = 3'd2;  
									 muxshiftsrca = 1'd0;
									 muxshiftsrcb = 1'd0;
									 muxxchgctrl = 1'd0;
									 pcwrite = 1'd0;
									 pcwritecond = 1'd0;
									 regwrite = 1'd0; //
									 shiftcontrol = 3'd0;
									 sscontrol = 2'd0;
									 state = div2;

									  
									 xchgctrl = 1'd0;
									 multBegin = 1'b0;
									 divBegin = 1'b1; // <---							
								end
							endcase
						end
						addi: begin
							 alucontrol = 3'd1;
							 aluoutwrite = 1'd1;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
							 muxalusrca = 2'd1;
							 muxalusrcb = 2'd2;
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; // 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd2; // 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; //
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = addi_addiu;

							  
							 xchgctrl = 1'd0;
						end
						addiu: begin
							 alucontrol = 3'd1;
							 aluoutwrite = 1'd1;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
							 muxalusrca = 2'd1;
							 muxalusrcb = 2'd2;
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; // 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd2; // 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; //
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = addi_addiu;

							  
							 xchgctrl = 1'd0;
						end
						beq: begin
							 alucontrol = 3'd7; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd0; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; 
							 muxpcsource = 2'd1; // <---
							 muxregdst = 3'd2; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd1; // <---
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = beq2;

							  
							 xchgctrl = 1'd0;
						end
						bne: begin
						     alucontrol = 3'd7; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd0; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; 
							 muxpcsource = 2'd1; // <---
							 muxregdst = 3'd2; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd1;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = bne2;

							  
							 xchgctrl = 1'd0;
						end
						bgt: begin
							 alucontrol = 3'd7; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd0; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; 
							 muxpcsource = 2'd1; // <---
							 muxregdst = 3'd2; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd1;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = bgt2;

							  
							 xchgctrl = 1'd0;
						end
						ble: begin
							 alucontrol = 3'd7; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd0; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; 
							 muxpcsource = 2'd1; // <---
							 muxregdst = 3'd2; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd1;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = ble2;

							  
							 xchgctrl = 1'd0;
						end
						blm: begin
							 alucontrol = 3'd0; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd0; 
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd9; 
							 muxpcsource = 2'd1; 
							 muxregdst = 3'd2; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0; // <----
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = blm2_wait;

							  
							 xchgctrl = 1'd0;
					
						end
						slti: begin
							 alucontrol = 3'd7;
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd4; // <---
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; // <--- 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd1; // <--- 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = closeWR;

							  
							 xchgctrl = 1'd0;
						end
						lui: begin
							 alucontrol = 3'd0;
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1;
							 muxalusrcb = 2'd2;
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; // <---
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; // <---
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd1; // <---
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = closeWR;

							  
							 xchgctrl = 1'd0;
						end
						lw: begin
							 alucontrol = 3'd1; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0;  // <---
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = lw2_wait;

							  
							 xchgctrl = 1'd0;
						end
						lh: begin
					         alucontrol = 3'd1; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0;  // <---
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = lh2_wait;

							  
							 xchgctrl = 1'd0;
						end
						lb: begin
					         alucontrol = 3'd1; // <---
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0;  // <---
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = lb2_wait;

							  
							 xchgctrl = 1'd0;
						end
						sw: begin
					         alucontrol = 3'd1; // <---
							 aluoutwrite = 1'd1;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0;  // <---
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = sw2;

							  
							 xchgctrl = 1'd0;
						end
						sh: begin
							 alucontrol = 3'd1; // <---
							 aluoutwrite = 1'd1;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0;  // <---
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = sh2;

							  
							 xchgctrl = 1'd0;
					
						end
						sb: begin
							 alucontrol = 3'd1; // <---
							 aluoutwrite = 1'd1;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd1; // <---
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0;  // <---
							 muxalusrca = 2'd1; // <---
							 muxalusrcb = 2'd2; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd6; 
							 muxpcsource = 2'd0;
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0;
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = sb2;

							  
							 xchgctrl = 1'd0;
						end
						j: begin
							 alucontrol = 3'd0;
							 aluoutwrite = 1'd0;
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd1;
							 muxalusrcb = 2'd2;
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd0; 
							 muxpcsource = 2'd2; // <---
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd1; // <---
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = closeWR;

							  
							 xchgctrl = 1'd0;
						end
						jal: begin
							 alucontrol = 3'd0; // <---
							 aluoutwrite = 1'd1; // <---
							  
							 epcwrite = 1'd0;
							 hiwrite = 1'd0;
							 iordmux = 2'd0;
							 irwrite = 1'd0;
							 lowrite = 1'd0;
							 lscontrol = 2'd0;
							 memwrite  = 1'd0; 
							 muxalusrca = 2'd0; // <---
							 muxalusrcb = 2'd1; // <---
							 muxhi = 1'd0;
							 muxlo = 1'd0;
							 muxmemtoreg = 4'd0; 
							 muxpcsource = 2'd2; 
							 muxregdst = 3'd0; 
							 muxshiftsrca = 1'd0;
							 muxshiftsrcb = 1'd0;
							 muxxchgctrl = 1'd0;
							 pcwrite = 1'd0; 
							 pcwritecond = 1'd0;
							 regwrite = 1'd0; 
							 shiftcontrol = 3'd0;
							 sscontrol = 2'd0;
							 state = jal2;

							  
							 xchgctrl = 1'd0;
						end
						default: begin
							state = opcodeEx;

						end
					endcase
			    end			
				add_sub_and: begin
					if (Overflow) begin
						state = overflowEx;

					end 
					else begin
						alucontrol = 3'd0;
						aluoutwrite = 1'd0;
						 														
						epcwrite = 1'd0;
						hiwrite = 1'd0;
						iordmux = 2'd0;
						irwrite = 1'd0;
						lowrite = 1'd0;
						lscontrol = 2'd0;
						memwrite  = 1'd0; 					
						muxalusrca = 2'd1;
						muxalusrcb = 2'd0;
						muxhi = 1'd0;
						muxlo = 1'd0;
						muxmemtoreg = 4'd0; // <----
						muxpcsource = 2'd0;
						muxregdst = 3'd1; // <---
						muxshiftsrca = 1'd0;
						muxshiftsrcb = 1'd0;
						muxxchgctrl = 1'd0;
						pcwrite = 1'd0;
						pcwritecond = 1'd0;
						regwrite = 1'd1; // <---
						shiftcontrol = 3'd0;
						sscontrol = 2'd0;
						state = closeWR;

						xchgctrl = 1'd0;
					end
				end
				sll2: begin
					alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd0;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd1;
					muxshiftsrcb = 1'd1; // <---
					muxxchgctrl = 1'd0; 
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; 
					shiftcontrol = 3'd2; // <---
					sscontrol = 2'd0;
					state = sll_sra_srl_sllv_srav;

					xchgctrl = 1'd0; 
				end
				srl2: begin
					alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd0;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd1;
					muxshiftsrcb = 1'd1; // <---
					muxxchgctrl = 1'd0; 
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; 
					shiftcontrol = 3'd3; // <---
					sscontrol = 2'd0;
					state = sll_sra_srl_sllv_srav;

					xchgctrl = 1'd0; 
				end
				sra2: begin
					alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd0;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd1;
					muxshiftsrcb = 1'd1; // <---
					muxxchgctrl = 1'd0; 
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; 
					shiftcontrol = 3'd4; // <---
					sscontrol = 2'd0;
					state = sll_sra_srl_sllv_srav;

					xchgctrl = 1'd0; 
				end
				sllv2: begin
					alucontrol = 3'd1;
					aluoutwrite = 1'd0;
				     
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd0;
					muxalusrcb = 2'd3;
					muxhi = 1'd0;
					muxlo = 1'd0;
				    muxmemtoreg = 4'd9; 
					muxpcsource = 2'd0;
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0; // <---
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; 
					shiftcontrol = 3'd2;// <--
					sscontrol = 2'd0;
					state = sll_sra_srl_sllv_srav;

					 
					xchgctrl = 1'd0;
				end
				srav2: begin
					alucontrol = 3'd1;
					aluoutwrite = 1'd0;
				     
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd0;
					muxalusrcb = 2'd3;
					muxhi = 1'd0;
					muxlo = 1'd0;
				    muxmemtoreg = 4'd9; 
					muxpcsource = 2'd0;
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0; // <---
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; 
					shiftcontrol = 3'd4;// <--
					sscontrol = 2'd0;
					state = sll_sra_srl_sllv_srav;

					 
					xchgctrl = 1'd0;
				end
				sll_sra_srl_sllv_srav: begin
					alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd1;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd7; // <--- 
					muxpcsource = 2'd0;
					muxregdst = 3'd1; // <---
					muxshiftsrca = 1'd1;
					muxshiftsrcb = 1'd1;
					muxxchgctrl = 1'd0; 
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1; // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;

					xchgctrl = 1'd0; 
				end
				mult2: begin
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd0;
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd0;
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; // 0 = lendo , 1 = escrevendo
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd3;
					 muxhi = 1'd0;
					 muxlo = 1'd0;
					 muxmemtoreg = 4'd9; // 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; // 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; //
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					  
					 xchgctrl = 1'd0;
					 multBegin = 1'b0;							
					 if(multStop == 0) begin
						state = mult2;
						
					end else begin
						state = mult3;
						
					end
				end
				mult3: begin
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd1; // <---
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd1; // <---
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; 
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd3;
					 muxhi = 1'd0; // <---
					 muxlo = 1'd0; // <---
					 muxmemtoreg = 4'd9; 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; 
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					 state = closeWR;
					   
					  
					 xchgctrl = 1'd0;
					 multBegin = 1'b0; // <---							
				end
				div2: begin
					if (divByZero) begin
						state = divByZeroEx;
						 
					end
					else begin
						 alucontrol = 3'd1;
						 aluoutwrite = 1'd0;
						  
						 epcwrite = 1'd0;
						 hiwrite = 1'd0;
						 iordmux = 2'd0;
						 irwrite = 1'd0;
						 lowrite = 1'd0;
						 lscontrol = 2'd0;
						 memwrite  = 1'd0; 
						 muxalusrca = 2'd0;
						 muxalusrcb = 2'd3;
						 muxhi = 1'd1; // <----
						 muxlo = 1'd1; // <----
					     muxmemtoreg = 4'd9; 
						 muxpcsource = 2'd0;
						 muxregdst = 3'd2; 
						 muxshiftsrca = 1'd0;
						 muxshiftsrcb = 1'd0;
						 muxxchgctrl = 1'd0;
						 pcwrite = 1'd0;
						 pcwritecond = 1'd0;
						 regwrite = 1'd0; 
						 shiftcontrol = 3'd0;
						 sscontrol = 2'd0;
						  
						 xchgctrl = 1'd0;
						 multBegin = 1'b0;
						 divBegin = 1'b0;	// <---						
						 if(divStop == 0) begin
							state = div2;
						
						end else begin
							state = div3;
						
						end
					end
				end
				div3: begin
					 alucontrol = 3'd1;
					 aluoutwrite = 1'd0;
					  
					 epcwrite = 1'd0;
					 hiwrite = 1'd1; // <----
					 iordmux = 2'd0;
					 irwrite = 1'd0;
					 lowrite = 1'd1; // <----
					 lscontrol = 2'd0;
					 memwrite  = 1'd0; 
					 muxalusrca = 2'd0;
					 muxalusrcb = 2'd3;
					 muxhi = 1'd1; // <----
					 muxlo = 1'd1; // <----
					 muxmemtoreg = 4'd9; 
					 muxpcsource = 2'd0;
					 muxregdst = 3'd2; 
					 muxshiftsrca = 1'd0;
					 muxshiftsrcb = 1'd0;
					 muxxchgctrl = 1'd0;
					 pcwrite = 1'd0;
					 pcwritecond = 1'd0;
					 regwrite = 1'd0; 
					 shiftcontrol = 3'd0;
					 sscontrol = 2'd0;
					  
					 state = closeWR;
					  
					 xchgctrl = 1'd0;
					 multBegin = 1'b0;
					 divBegin = 1'b0;	// <---	
				end
				xchg2: begin
					alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd1;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd8; // <--- 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0; // <---
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = xchg3;
					  
					xchgctrl = 1'd0; // <---
				end
				xchg3: begin
					alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd1;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd8; // <--- 
					muxpcsource = 2'd0;
					muxregdst = 3'd4; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd1; // <---
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  								
					xchgctrl = 1'd0; // <---
				end
				addi_addiu: begin
					if (Overflow == 1 && opcode == 6'd8) begin // overflow apenas no addi
						state = overflowEx;
						 
					end
					else begin
						alucontrol = 3'd0;
						aluoutwrite = 1'd0;
						 														
						epcwrite = 1'd0;
						hiwrite = 1'd0;
						iordmux = 2'd0;
						irwrite = 1'd0;
						lowrite = 1'd0;
						lscontrol = 2'd0;
						memwrite  = 1'd0; 					
						muxalusrca = 2'd1;
						muxalusrcb = 2'd0;
						muxhi = 1'd0;
						muxlo = 1'd0;
						muxmemtoreg = 4'd0; // <----
						muxpcsource = 2'd0;
						muxregdst = 3'd0; // <---
						muxshiftsrca = 1'd0;
						muxshiftsrcb = 1'd0;
						muxxchgctrl = 1'd0;
						pcwrite = 1'd0;
						pcwritecond = 1'd0;
						regwrite = 1'd1; // <---
						shiftcontrol = 3'd0;
						sscontrol = 2'd0;
						state = closeWR;
						
						xchgctrl = 1'd0;
					end
				end
				beq2: begin
					alucontrol = 3'd7; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; // <---
				    muxalusrcb = 2'd0; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd1; // <---
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd1; // <---
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					 
					xchgctrl = 1'd0;
				end
				bne2: begin
					alucontrol = 3'd7; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; // <---
				    muxalusrcb = 2'd0; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd1; // <---
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd1; // <---
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					 
					xchgctrl = 1'd0;
				end
				bgt2: begin
					alucontrol = 3'd7; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; // <---
				    muxalusrcb = 2'd0; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd1; // <---
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd1; // <---
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					 
					xchgctrl = 1'd0;
				end
				ble2: begin
					alucontrol = 3'd7; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; // <---
				    muxalusrcb = 2'd0; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd1; // <---
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd1; // <---
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					 
					xchgctrl = 1'd0;
				end
				blm2_wait: begin
					alucontrol = 3'd0; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; // <---
				    muxalusrcb = 2'd0; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd0;
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0; 
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = blm3_wait;
					 
					 
					xchgctrl = 1'd0;
				end
				blm3_wait: begin
					alucontrol = 3'd0; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; // <---
				    muxalusrcb = 2'd0; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd0;
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0; 
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = blm4;
					 
					 
					xchgctrl = 1'd0;
				end
				blm4: begin
					alucontrol = 3'd7; // <---
				    aluoutwrite = 1'd0;
					 
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 
					muxalusrca = 2'd2; // <---
				    muxalusrcb = 2'd0; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd9; 
					muxpcsource = 2'd1; // <---
					muxregdst = 3'd2; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd1; // <---
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					 
					 
					xchgctrl = 1'd0;
				end
				break2: begin
					alucontrol = 3'd2;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd0;
					muxalusrcb = 2'd1;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; // <----
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd1;
					pcwritecond = 1'd0;
					regwrite = 1'd0; // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  								
					xchgctrl = 1'd0;
				end
				lw2_wait: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = lw3;
					  
					xchgctrl = 1'd0;
				end
				lw3: begin
			        alucontrol = 3'd1; 
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; 
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd1; // <---
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; 
					muxalusrcb = 2'd2; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd1; // <---  
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0;  // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = lw4;
					  
					xchgctrl = 1'd0;
				end
				lw4: begin
					alucontrol = 3'd1; 
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; 
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd1; // <---
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; 
					muxalusrcb = 2'd2; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd1; // <---  
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1;  // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					xchgctrl = 1'd0;
				end
				lh2_wait: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = lh3;
					  
					xchgctrl = 1'd0;
				end
				lh3: begin
					alucontrol = 3'd1; 
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; 
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd2; // <---
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; 
					muxalusrcb = 2'd2; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd1; // <---  
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0;  // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = lh4;
					  
					xchgctrl = 1'd0;
				end
				lh4: begin
					alucontrol = 3'd1; 
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; 
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd2; // <---
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; 
					muxalusrcb = 2'd2; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd1; // <---  
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1;  // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					xchgctrl = 1'd0;
				end
				lb2_wait: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = lb3;
					  
					xchgctrl = 1'd0;
				end
				lb3: begin
			        alucontrol = 3'd1; 
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; 
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd3; // <---
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; 
					muxalusrcb = 2'd2; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd1; // <---  
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0;  // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = lb4;
					  
					xchgctrl = 1'd0;
				end
				lb4: begin
					alucontrol = 3'd1; 
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; 
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd3; // <---
					memwrite  = 1'd0; 
					muxalusrca = 2'd1; 
					muxalusrcb = 2'd2; 
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd1; // <---  
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1;  // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					  
					xchgctrl = 1'd0;
				end
				sw2: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0; //
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = sw3;
					  
					xchgctrl = 1'd0;
				end
				sw3: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd2; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd1; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd1; // <---
					state = closeWR;
					  
					xchgctrl = 1'd0;
				end
				sh2: begin
			        alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0; //
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = sh3;
					  
					xchgctrl = 1'd0;
				end
				sh3: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd2; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd1; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd2; // <--- 
					state = closeWR;
					xchgctrl = 1'd0;
				end
				sb2: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0; //
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd1; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = sb3;
					xchgctrl = 1'd0;
				end
				sb3: begin
					alucontrol = 3'd1; // <---
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd2; // <---
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd1; // <---
					muxalusrca = 2'd1; // <---
					muxalusrcb = 2'd2; // <---
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd3; // <---
					state = closeWR;
					xchgctrl = 1'd0;
				end
				jal2: begin
			        alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd0;
					muxalusrcb = 2'd1;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; // <----
					muxpcsource = 2'd0;
					muxregdst = 3'd3; // <---
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd1; // <---
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = jal3;						
					xchgctrl = 1'd0;
			
				end
				jal3: begin
			        alucontrol = 3'd0;
					aluoutwrite = 1'd0;
					 														
					epcwrite = 1'd0;
					hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0; 					
					muxalusrca = 2'd0;
					muxalusrcb = 2'd1;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; 
					muxpcsource = 2'd2; // <---
					muxregdst = 3'd0; 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd1; // <---
					pcwritecond = 1'd0;
					regwrite = 1'd0; 
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = closeWR;
					xchgctrl = 1'd0;
				end
				closeWR: begin
					alucontrol = 3'd0;
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0;
					muxalusrca = 2'd0;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; // 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = wait_Final;
					  
					xchgctrl = 1'd0;
				end
				wait_Final: begin
					alucontrol = 3'd0;
				    aluoutwrite = 1'd0;
				     
				    epcwrite = 1'd0;
				    hiwrite = 1'd0;
					iordmux = 2'd0;
					irwrite = 1'd0;
					lowrite = 1'd0;
					lscontrol = 2'd0;
					memwrite  = 1'd0;
					muxalusrca = 2'd0;
					muxalusrcb = 2'd0;
					muxhi = 1'd0;
					muxlo = 1'd0;
					muxmemtoreg = 4'd0; // 
					muxpcsource = 2'd0;
					muxregdst = 3'd0; // 
					muxshiftsrca = 1'd0;
					muxshiftsrcb = 1'd0;
					muxxchgctrl = 1'd0;
					pcwrite = 1'd0;
					pcwritecond = 1'd0;
					regwrite = 1'd0; //
					shiftcontrol = 3'd0;
					sscontrol = 2'd0;
					state = fetch1;
					  
					xchgctrl = 1'd0;
				end
			endcase
		end
	end
endmodule: unidadeControle