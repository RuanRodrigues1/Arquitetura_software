/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: shift_left

*/


module shift_left_2 (endereco_in, endereco_out);


   input wire [31:0] endereco_in;  		// Endereço inteiro
   output wire [31:0] endereco_out; 	// Endereço deslocado 2 bits

   assign endereco_out = endereco_in << 2; // Multiplica por 4 deslocando 2 bits à esquerda

endmodule