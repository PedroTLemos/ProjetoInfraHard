module signExtend1to32(
input logic slt,
output logic [31:0] signExtd1to32Out
);

always

signExtd1to32Out <= (32'b00000000000000000000000000000000 + slt);


endmodule:signExtend1to32

