

module mux2x1 (entrada0, entrada1, seletor, saida);
    
	//Descrição das entradas e saídas:
	input wire [31:0] entrada0;  	   
   input wire [31:0] entrada1;  	   
   input wire seletor;              // Sinal de seleção
   output wire [31:0] saida;  	  		// Saída do mux

	//Comportamento:
   assign saida = seletor ? entrada1 : entrada0; // Seleciona in2 se sel = 1, senão seleciona in1

endmodule