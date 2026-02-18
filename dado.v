module dice_fpga (
    input  wire clk,        // 27 MHz
    input  wire btn_n,      // botão ativo em nível baixo
    output reg  [6:0] seg   // a,b,c,d,e,f,g (catodo comum)
);

    // =========================
    // LFSR 3 bits (pseudoaleatório)
    // =========================
    reg [2:0] lfsr = 3'b101;
    always @(posedge clk) begin
        lfsr <= {lfsr[1:0], lfsr[2] ^ lfsr[1]};
    end

    // Converte para 1–6 (evita 0 e 7)
    reg [2:0] dice_value;
    always @(*) begin
        case (lfsr)
            3'd0: dice_value = 3'd6;
            3'd7: dice_value = 3'd3;
            default: dice_value = lfsr;
        endcase
    end

    // =========================
    // Divisor para rolagem visível (~200 Hz)
    // =========================
    reg [16:0] div_counter = 0;
    reg tick = 0;
    always @(posedge clk) begin
        if (div_counter == 17'd135000) begin
            div_counter <= 0;
            tick <= 1;
        end else begin
            div_counter <= div_counter + 1;
            tick <= 0;
        end
    end

    // =========================
    // Detecção de borda de descida do botão (ativo baixo)
    // =========================
    reg btn_d = 1'b1;
    wire btn_pressed;
    always @(posedge clk)
        btn_d <= btn_n;
    assign btn_pressed = btn_d & ~btn_n;

    // =========================
    // Controle de estados
    // =========================
    reg rolling = 1'b1;
    reg [27:0] hold_counter = 0;
    reg [2:0] current_value = 3'd1;

    always @(posedge clk) begin
        if (rolling) begin
            if (tick)
                current_value <= dice_value;
            if (btn_pressed) begin
                current_value <= dice_value; // trava o valor imediatamente
                rolling      <= 0;
                hold_counter <= 0;
            end
        end
        else begin
            if (hold_counter == 28'd135000000) begin
                rolling <= 1;
            end else begin
                hold_counter <= hold_counter + 1;
            end
        end
    end

    // =========================
    // Decodificador 7 segmentos
    // Catodo comum — segmentos {a,b,c,d,e,f,g}, 1 = acende
    // =========================
    always @(*) begin
        case (current_value)
            3'd1: seg = 7'b0110000; // b,c
            3'd2: seg = 7'b1101101; // a,b,d,e,g
            3'd3: seg = 7'b1111001; // a,b,c,d,g
            3'd4: seg = 7'b0110011; // b,c,f,g
            3'd5: seg = 7'b1011011; // a,c,d,f,g
            3'd6: seg = 7'b1011111; // a,c,d,e,f,g
            default: seg = 7'b0000000;
        endcase
    end

endmodule
