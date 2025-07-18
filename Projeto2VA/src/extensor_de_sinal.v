

module extensor_de_sinal (imediato, extensor_out);

   //Descrição das entradas e saídas:
   input wire [15:0] imediato;      // Valor imediato de 16 bits
   output wire [31:0] extensor_out; // Valor estendido para 32 bits

   //Comportamento:
   assign extensor_out = {{16{imediato[15]}}, imediato}; //Pega o bit mais significativo do imediato (imediato[15]), replica ele 16x e contaceta com o imediato 

endmodule