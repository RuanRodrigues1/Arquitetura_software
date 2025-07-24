/*
PROJETO: Processador MIPS, autores: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

ARQUIVO: MIPS (MIPS top level)

*/

module MIPS (
    input wire clock,
    input wire reset,
    output wire [31:0] current_PC,
    output wire [31:0] ULA_result,
    output wire [31:0] d_mem_out
);

    // Fios internos
    wire [31:0] pc_out, next_pc, pc_plus_4;
    wire [31:0] instruction;
    wire [31:0] read_data_1, read_data_2;
	 reg [31:0] write_data_regfile;
    wire [31:0] sign_extended_immediate, alu_input_2;
    wire [31:0] alu_result_internal, data_mem_read_data;
    wire [31:0] branch_address, shifted_branch_offset, jump_address;
    wire [31:0] pc_after_branch_mux;

    reg [4:0] write_reg_addr_mux_out;
    wire [3:0] alu_control_signal;

    // Sinais da unidade de controle
    wire RegDest, Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump, Jal_Dest;
    wire [1:0] MemToReg;
    wire [3:0] ALUOp;
    wire alu_zero_flag, pc_select_for_branch;

	 //PC
    PC PC_inst (
        .clock(clock),
        .reset(reset),
        .next_PC(next_pc),
        .PC(pc_out)
    );

    //PC + 4
    somador_PC_4 PC_adder_inst (
        .PC(pc_out),
        .somador_out(pc_plus_4)
    );

    // i_mem (lê instrucao no endereco PC e retorna em instruction), instruction <- instrucao atual
    i_mem instruction_memory_inst (
        .endereco_PC(pc_out),
        .instrucao_out(instruction)
    );


    // unidade de controle
    ctrl control_unit_inst (
        .instrucao(instruction), // recebe instrucao
        .RegDest(RegDest), // RegDest <- flag ($rd ou $rt) (instrucoes tipo R / I)
        .Branch(Branch), // Flag de branch (BEQ)
        .MemRead(MemRead), // Flag de leitura
        .MemToReg(MemToReg), // Seletor de dado a ser escrito, 00 > resultadoULA, 01 -> valor lido, 10 -> endereco de PC + 4 (jal)
        .ALUOp(ALUOp), // Tipo de operacao da ULA
        .MemWrite(MemWrite), // Flag de escrita
        .ALUSrc(ALUSrc), // Define se a in2 da ULA eh imediato ou registrador
        .RegWrite(RegWrite), // Flag de escrita no regfile
        .Jump(Jump), // Flag de jump
        .Jal_Dest(Jal_Dest) // flag de jal
    );

    // regfile
    regfile reg_file_inst (
        .clock(clock),
        .reset(reset),
        .RegWrite(RegWrite), // Flag de escrita
        .ReadAddr1(instruction[25:21]), // Endereco1
        .ReadAddr2(instruction[20:16]), // Endereco2
        .WriteAddr(write_reg_addr_mux_out), // Endereco a ser escrito
        .WriteData(write_data_regfile), // Dado a ser escrito
        .ReadData1(read_data_1), // Dados lidos
        .ReadData2(read_data_2)
    );

    // MUX para selecionar o endereço do registrador de destino (WriteAddr)
    // Se Jal_Dest=1 -> destino é $ra (31). senao se RegDest=1 -> destino é $rd. Senão -> $rt
    always @(*) begin
        if (Jal_Dest) begin
            write_reg_addr_mux_out = 5'd31; // Para instrução JAL, escreve em $ra
        end else if (RegDest) begin
            write_reg_addr_mux_out = instruction[15:11]; // Para tipo R, destino é $rd
        end else begin
            write_reg_addr_mux_out = instruction[20:16]; // Para lw, destino é $rt
        end
    end

    // extensor de sinal 16 -> 32 bits
    extensor_de_sinal sign_extender_inst (
        .imediato(instruction[15:0]),           // Imediato de 16 bits
        .extensor_out(sign_extended_immediate)  // Imediato estendido para 32 bits
    );

    // MUX para selecionar o segundo operando da ULA (ALUSrc)
    // Seleciona entre o dado do registrador (read_data_2) e o imediato estendido
    mux2x1 mux_alu_src (
        .entrada0(read_data_2), 
        .entrada1(sign_extended_immediate),
        .seletor(ALUSrc),
        .saida(alu_input_2) // Se recebe reg, input2 = reg, se recebe imediato, input2 = imediato
    );

    // Instanciação da ULA ctrl
    ula_ctrl ula_control_inst (
        .ALUOp(ALUOp), // Tipo de operacao da ULA
        .funct(instruction[5:0]), // funct
        .ALUControl(alu_control_signal) // Operacao a ser realizada pela ULA
    );

    // Instanciação da ULA
    ULA alu_inst (
        .in1(read_data_1), // input 1
        .in2(alu_input_2), // input 2
        .OP(alu_control_signal), // Operacao
        .result(alu_result_internal), // Resultado
        .Zero_flag(alu_zero_flag) // Flag resultado == 0
    );

    // Instanciação da Memória de Dados (d_mem) 
    // Realiza leitura ou escrita na memória de dados.
    d_mem data_memory_inst (
        .MemWrite(MemWrite), // Flag de escrita
        .MemRead(MemRead), // Flag de leitura
        .Address(alu_result_internal), // Endereço fornecido pela ULA
        .WriteData(read_data_2), // Dado a ser escrito
        .ReadData(data_mem_read_data) // Dado lido
    );

    // MUX para selecionar o dado a ser escrito de volta no banco de registradores (MemToReg)
    // O sinal MemToReg de 2 bits seleciona entre resultado da ULA, dado da memória ou PC+4 (para jal).
    always @(*) begin
        case(MemToReg)
            2'b00:  write_data_regfile = alu_result_internal; // Escreve o resultado da ULA
            2'b01:  write_data_regfile = data_mem_read_data;  // Escreve o dado vindo da memória (lw)
            2'b10:  write_data_regfile = pc_plus_4; // Escreve PC+4 (jal)
            default: write_data_regfile = 32'h00000000;
        endcase
    end

    // Instanciação do Shift Left 2 para o desvio (branch)
    // Multiplica o offset do branch por 4.
    shift_left_2 shift_left_branch_inst (
        .endereco_in(sign_extended_immediate), // Offset do branch
        .endereco_out(shifted_branch_offset)  // Offset deslocado
    );

    // Somador para calcular o endereço de destino do branch
    assign branch_address = pc_plus_4 + shifted_branch_offset;

    // Lógica para determinar se o branch deve ser tomado
    assign pc_select_for_branch = Branch & alu_zero_flag; // Para beq

    // MUX para desvio (branch): seleciona entre PC+4 e o endereço de branch
    mux2x1 mux_branch (
        .entrada0(pc_plus_4),
        .entrada1(branch_address),
        .seletor(pc_select_for_branch),
        .saida(pc_after_branch_mux) // Se branch, pc recebe branch
    );

    // Lógica para calcular o endereço de destino do salto (jump)
    assign jump_address = {pc_plus_4[31:28], instruction[25:0], 2'b00};

    // MUX jump seleciona entre o resultado da lógica de branch e o endereço de jump
    mux2x1 mux_jump (
        .entrada0(pc_after_branch_mux),
        .entrada1(jump_address),
        .seletor(Jump),
        .saida(next_pc) // se jump, pc recebe jump
    );

    assign current_PC = pc_out;
    assign ULA_result = alu_result_internal;
    assign d_mem_out = data_mem_read_data;

endmodule