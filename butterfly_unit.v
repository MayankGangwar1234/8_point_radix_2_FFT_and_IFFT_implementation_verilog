module butterfly_unit (
    input wire [15:0] real_in1, imag_in1, // First complex input (X_even)
    input wire [15:0] real_in2, imag_in2, // Second complex input (X_odd)
    output reg [15:0] real_out1, imag_out1, // Output X1
    output reg [15:0] real_out2, imag_out2  // Output X2
);
  ieee16bit_add f1(.in1(real_in1),.in2(real_in2),.op(real_out1));
  ieee16bit_add f2(.in1(imag_in1),.in2(imag_in2),.op(imag_out1));
  ieee16bit_sub s1 (.in1(real_in1),.in2(real_in2),.op(real_out2));
  ieee16bit_sub s2(.in1(imag_in1),.in2(imag_in2),.op(imag_out2));
endmodule
