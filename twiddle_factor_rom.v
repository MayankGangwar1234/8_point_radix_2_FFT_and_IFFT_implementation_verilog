module twiddle_factor_rom (
    input wire fftorifft,
    output reg [15:0] W0_real, W0_imag,
    output reg [15:0] W1_real, W1_imag,
    output reg [15:0] W2_real, W2_imag,
    output reg [15:0] W3_real, W3_imag
);

    // Initialize the twiddle factors in IEEE 754 half-precision format
    always@(*) begin
    if(fftorifft==0) begin
        // W_8^0 = 1 + j0
        W0_real = 16'h3C00; // 1.0
        W0_imag = 16'h0000; // 0.0

        // W_8^1 = 1/sqrt(2) - j(1/sqrt(2))
        W1_real = 16'h39a8; // 0.7071
        W1_imag = 16'hB9a8; // -0.7071

        // W_8^2 = 0 - j1
        W2_real = 16'h0000; // 0.0
        W2_imag = 16'hBC00; // -1.0

        // W_8^3 = -1/sqrt(2) - j(1/sqrt(2))
        W3_real = 16'hB9a8; // -0.7071
        W3_imag = 16'hB9a8; // -0.7071
    end
    else begin
    W0_real = 16'h3C00; // 1.0
    W0_imag = 16'h0000; // 0.0

    // W_8^1 = 1/sqrt(2) - j(1/sqrt(2))
    W1_real = 16'h39a8; // 0.7071
    W1_imag = 16'h39a8; // 0.7071

    // W_8^2 = 0 - j1
    W2_real = 16'h0000; // 0.0
    W2_imag = 16'h3C00; // 1.0

    // W_8^3 = -1/sqrt(2) - j(1/sqrt(2))
    W3_real = 16'hB9a8; // -0.7071
    W3_imag = 16'h39a8; // 0.7071
    end
    end

endmodule
