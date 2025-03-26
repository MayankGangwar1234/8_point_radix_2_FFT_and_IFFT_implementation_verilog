module bit_reversal_8point (
    input wire [15:0] real_in [0:7], // Real part of inputs
    input wire [15:0] imag_in [0:7], // Imaginary part of inputs
    output reg [15:0] real_out [0:7], // Real part of reordered outputs
    output reg [15:0] imag_out [0:7]  // Imaginary part of reordered outputs
);

    // Bit-reversed index mapping
  always @(*) begin
        real_out[0] = real_in[0]; imag_out[0] = imag_in[0]; // 000 -> 000
        real_out[1] = real_in[4]; imag_out[1] = imag_in[4]; // 001 -> 100
        real_out[2] = real_in[2]; imag_out[2] = imag_in[2]; // 010 -> 010
        real_out[3] = real_in[6]; imag_out[3] = imag_in[6]; // 011 -> 110
        real_out[4] = real_in[1]; imag_out[4] = imag_in[1]; // 100 -> 001
        real_out[5] = real_in[5]; imag_out[5] = imag_in[5]; // 101 -> 101
        real_out[6] = real_in[3]; imag_out[6] = imag_in[3]; // 110 -> 011
        real_out[7] = real_in[7]; imag_out[7] = imag_in[7]; // 111 -> 111
    end

endmodule
