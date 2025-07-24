/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO:  i_mem

*/

module i_mem (pc_adress, inst_out);

   input wire [31:0] pc_adress;  		// Endereço do PC
	
   output reg [31:0] inst_out;   // Instrução da posicao do pc
	
	parameter mem_size = 64;    // Tamanho da memoria
	
   reg [31:0] memoria_ROM [0: mem_size - 1];  
	
   // Le as instrucoes
   initial begin
	
       $readmemb("instructions.list", memoria_ROM);
		 
   end
	
	always @ (pc_adress) begin
	
		// Divide o PC por 4
		inst_out = memoria_ROM[pc_adress >> 2];
		
	end

endmodule