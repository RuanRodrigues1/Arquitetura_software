/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: Branch de teste

*/

`timescale 1ns/1ps
module tb_mips_processor;
    reg clock;
    reg reset;
	 wire [31:0] pc_current;
	 wire [31:0] ula_result_value;
	 wire [31:0] d_mem_read_out;
    mips_processor uut (.clock(clock), .reset(reset), .ula_result_out(ula_result_value), .d_mem_read_out(d_mem_read_out), .current_pc_value_out(pc_current));
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    initial begin
        reset = 1;
        repeat (2) @(posedge clock); // Espera por 2 ciclos de clock completos
        reset = 0;                   // Desativa o reset logo após a borda do clock
        #690;
        $finish;
    end
    initial begin
		  $monitor("PC: %d | ULA: %d | D_MEM: %d", pc_current, ula_result_value, d_mem_read_out);
    end
endmodule