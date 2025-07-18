

module ula_ctrl(ALUOp, funct, ALUControl);
    // Descrição das portas
    input  wire [3:0] ALUOp;      // Código da operação da ULA (derivado do opcode da instrução)
    input  wire [5:0] funct;      // Campo funct para instruções do tipo R
    output reg  [3:0] ALUControl; // Código da operação que será executada na ULA

    // Bloco combinacional: Define o controle da ULA com base na operação
    always @(*) begin
        case(ALUOp)
            4'b1111: begin // Instruções do tipo R
                case(funct)
                    6'b000000: ALUControl = 4'b1001; // SLL (Shift Left Logical)
                    6'b000010: ALUControl = 4'b1010; // SRL (Shift Right Logical)
                    6'b000011: ALUControl = 4'b1101; // SRA (Shift Right Arithmetic)
                    6'b000100: ALUControl = 4'b0011; // SLLV (Shift Left Logical Variable)
                    6'b000110: ALUControl = 4'b0100; // SRLV (Shift Right Logical Variable)
                    6'b000111: ALUControl = 4'b0101; // SRAV (Shift Right Arithmetic Variable)
                    6'b100000: ALUControl = 4'b0010; // ADD
                    6'b100010: ALUControl = 4'b0110; // SUB
                    6'b100100: ALUControl = 4'b0000; // AND
                    6'b100101: ALUControl = 4'b0001; // OR
                    6'b100110: ALUControl = 4'b1011; // XOR
                    6'b100111: ALUControl = 4'b1100; // NOR
                    6'b101010: ALUControl = 4'b0111; // SLT
                    6'b101011: ALUControl = 4'b1111; // SLTU
                    default:   ALUControl = 4'bxxxx; // Operação indefinida
                endcase
            end
            4'b0100: ALUControl = 4'b0110; // BEQ (Subtração para comparação)
            4'b0101: ALUControl = 4'b1000; // BNE (Tratamento especial)
            4'b1000: ALUControl = 4'b0010; // ADDI (Soma imediata)
            4'b1010: ALUControl = 4'b0111; // SLTI (Set Less Than Immediate)
            4'b1011: ALUControl = 4'b1111; // SLTIU (Set Less Than Immediate Unsigned)
            4'b1100: ALUControl = 4'b0000; // ANDI (AND imediato)
            4'b1101: ALUControl = 4'b0001; // ORI (OR imediato)
            4'b1110: ALUControl = 4'b1011; // XORI (XOR imediato)
            default: ALUControl = 4'b0010; // Operação padrão (lw/sw fazem soma)
        endcase
    end

endmodule