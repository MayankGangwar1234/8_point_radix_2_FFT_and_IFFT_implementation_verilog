module bit_reversal_8point (
  input  [15:0] real_in0, real_in1, real_in2, real_in3,
  input  [15:0] real_in4, real_in5, real_in6, real_in7,
  input  [15:0] imag_in0, imag_in1, imag_in2, imag_in3,
  input  [15:0] imag_in4, imag_in5, imag_in6, imag_in7,
  output [15:0] real_out0, real_out1, real_out2, real_out3,
  output [15:0] real_out4, real_out5, real_out6, real_out7,
  output [15:0] imag_out0, imag_out1, imag_out2, imag_out3,
  output [15:0] imag_out4, imag_out5, imag_out6, imag_out7
);

  // Continuous assignments for bit reversal
  assign real_out0 = real_in0; assign imag_out0 = imag_in0;
  assign real_out1 = real_in4; assign imag_out1 = imag_in4;
  assign real_out2 = real_in2; assign imag_out2 = imag_in2;
  assign real_out3 = real_in6; assign imag_out3 = imag_in6;
  assign real_out4 = real_in1; assign imag_out4 = imag_in1;
  assign real_out5 = real_in5; assign imag_out5 = imag_in5;
  assign real_out6 = real_in3; assign imag_out6 = imag_in3;
  assign real_out7 = real_in7; assign imag_out7 = imag_in7;

endmodule

