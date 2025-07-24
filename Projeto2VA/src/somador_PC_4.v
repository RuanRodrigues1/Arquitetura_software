/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: somador_PC_4

*/

module somador_PC_4 (PC, somador_out);


   input wire [31:0] PC;   	 		// Valor atual do PC
   output wire [31:0] somador_out;  // Valor do pc + 4


   assign somador_out = PC + 4;   // Soma 4 ao endereço do PC

endmodule