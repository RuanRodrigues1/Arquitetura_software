/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: Mux2x1

*/

module mux2x1 (entrada0, entrada1, seletor, saida);
    
	input wire [31:0] entrada0;  	   
   input wire [31:0] entrada1;  	   
   input wire seletor;              // seletor
   output wire [31:0] saida;  	  		// saída 


   assign saida = seletor ? entrada1 : entrada0;

endmodule