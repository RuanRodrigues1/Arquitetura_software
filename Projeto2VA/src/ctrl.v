/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: ctrl

*/

module ctrl(
	input[31:0] instrucao, output reg RegDest, output reg Branch, output reg MemRead,
	
	output reg MemToReg, output reg[2:0] ALUOp, output reg MemWrite, output reg [1:0] ALUSrc,
	
	output reg RegWrite, output reg Jump, output reg Jal_Dest, output reg jr_sel
);

	wire[5:0] opcode = instrucao[31:26];
	wire[5:0] func = instrucao[5:0];
	
	always@(*) begin

		RegDest=0; Branch=0; MemRead=0; MemToReg=0; ALUOp=3'bxxx; MemWrite=0; ALUSrc=2'b00; RegWrite=0; Jump=0; Jal_Dest=0; jr_sel = 0;
		case(opcode)
		
			6'b000000: begin // Tipo R
				if (func == 6'b001000) begin
					Jump = 1;
					jr_sel = 1;
				end
				else begin
					RegDest=1; RegWrite=1; ALUOp=3'b010;
					if (func == 6'b000000) begin
						ALUSrc=2'b10; // para SLL
					end
					else if (func == 6'b000011) begin
						ALUSrc=2'b10; // Para SRA
					end
					else if (func == 6'b000100) begin
						ALUSrc=2'b11; // Para caso de SLLV
					end
				end
			end
			
			6'b001000: begin RegWrite=1; ALUSrc=2'b01; ALUOp=3'b000; end // ADDI
			
			6'b001101: begin RegWrite=1; ALUSrc=2'b01; ALUOp=3'b100; end // ORI
			
			6'b100011: begin RegWrite=1; MemRead=1; MemToReg=1; ALUSrc=2'b01; ALUOp=3'b000; end // LW
			
			6'b101011: begin MemWrite=1; ALUSrc=2'b01; ALUOp=3'b000; end // SW
			
			6'b001111: begin RegWrite=1; ALUOp=3'b111; end // LUI
			
			6'b000100: begin Branch=1; ALUOp=3'b001; end // BEQ
			
			6'b000101: begin Branch=1; ALUOp=3'b011; end // BNE
			
			6'b000010: begin Jump=1; end // JUMP
			
			6'b000011: begin Jump=1; RegWrite=1; Jal_Dest=1; end // JAL
			
		endcase
	end
endmodule