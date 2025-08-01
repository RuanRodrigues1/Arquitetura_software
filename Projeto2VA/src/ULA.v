/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: Modulo ULA (Operações aritiméticas / lógicas)

*/

module ULA(in1, in2, OP, result, Zero_flag);
	input wire[31:0] in1, in2;
	input wire [3:0] OP;
	output reg[31:0] result;
	output wire Zero_flag;
	
	// id das operacoes
	localparam SLL = 4'b1001, SRL = 4'b1010, SRA = 4'b1101;
	localparam SLLV = 4'b0011, SRLV = 4'b0100, SRAV = 4'b0101;
	localparam ADD = 4'b0010, SUB = 4'b0110, AND = 4'b0000;
	localparam OR = 4'b0001, XOR = 4'b1011, NOR = 4'b1100;
	localparam SLT = 4'b0111, SLTU = 4'b1111;
	
	always @(*) begin
		case (OP)
			// 'retorna' a operacao requisitada
			SLL:  result = in1 << in2[4:0];
			SRL:  result = in1 >> in2[4:0];
			SRA:  result = $signed(in1) >>> in2[4:0];
			SLLV: result = in1 << in2[4:0];
			SRLV: result = in1 >> in2[4:0];
			SRAV: result = $signed(in1) >>> in2[4:0];
			ADD: result = in1 + in2;
			SUB: result = in1 - in2;
			AND: result = in1 & in2;
			OR: result = in1 | in2;
			XOR: result = in1 ^ in2;
			NOR: result = ~(in1 | in2);
			SLT: result = ($signed(in1) < $signed(in2)) ? 32'b1 : 32'b0;
			SLTU: result = (in1 < in2) ? 32'b1 : 32'b0;
			default: result = 32'b0;
		endcase
	end
	assign Zero_flag = (result == 32'b0); // se resultado = 0, Zero_flag = 1
endmodule
