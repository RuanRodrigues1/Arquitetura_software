/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: ULA_CTRL, Unidade de controle da ULA

*/

module ULA_CTRL(
    input wire [2:0] ALUOp,
    input wire [5:0] func,
    output reg [3:0] ula_op_out
);

    // Códigos de operação da ULA
    localparam OP_AND = 4'b0000;
    localparam OP_OR  = 4'b0001;
	 localparam OP_XOR = 4'b1011;
	 localparam OP_NOR = 4'b1100;
    localparam OP_ADD = 4'b0010;
    localparam OP_SUB = 4'b0110;
    localparam OP_SLT = 4'b0111;
	 localparam OP_SLL = 4'b1001;
	 localparam OP_SRA = 4'b1101;
	 // To do: completar operacoes

    // Lógica para definir a operação da ULA
    always @(*) begin
        // O valor de 'alu_op_in' é definido pela unidade de controle principal
        if (ALUOp == 2'b10) begin // Instrução do Tipo-R
            // Para o Tipo-R, a operação é definida pelo campo 'funct'
            case(func)
					 6'b000000: ula_op_out = OP_SLL; // sll
					 6'b000011: ula_op_out = OP_SRA; // sra
					 6'b000100: ula_op_out = OP_SLL; // sllv
                6'b100000: ula_op_out = OP_ADD; // add
                6'b100010: ula_op_out = OP_SUB; // sub
                6'b100100: ula_op_out = OP_AND; // and
                6'b100101: ula_op_out = OP_OR;  // or
					 6'b100110: ula_op_out = OP_XOR; // xor
					 6'b100111: ula_op_out = OP_NOR; // nor
                6'b101010: ula_op_out = OP_SLT; // slt
                default:   ula_op_out = 4'bxxxx; // Operação não definida
            endcase
        end
        else if (ALUOp== 3'b000) begin // Para lui, lw, sw, addi
				ula_op_out = OP_ADD; // A ULA deve somar
        end
		  else if (ALUOp == 3'b100) begin // Para ORI
				ula_op_out = OP_OR; // OR
		  end
        else if (ALUOp == 3'b001) begin // Para beq
            ula_op_out = OP_SUB; // A ULA deve subtrair para comparar
        end
		  else if (ALUOp == 3'b011) begin // Para bne
            ula_op_out = OP_SUB; // A ULA deve subtrair para comparar
        end
        else begin
            ula_op_out = 4'bxxxx; // Caso indefinido
        end
    end

endmodule