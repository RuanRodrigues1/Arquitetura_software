/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO:signal extended

*/

module extensor_de_sinal (imediato, extensor_out);

   input wire [15:0] imediato;      // Valor imediato de 16 bits
   output wire [31:0] extensor_out; // Valor estendido para 32 bits


   assign extensor_out = {{16{imediato[15]}}, imediato}; //Pega o bit mais significativo do imediato (imediato[15]), replica ele 16x e contaceta com o imediato 

endmodule