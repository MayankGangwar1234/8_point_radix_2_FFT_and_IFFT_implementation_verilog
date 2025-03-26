module ieee16bitmultiplier(input [15:0] in1, input [15:0] in2, output reg [15:0] op);
  reg [4:0] exp1, exp2;
  reg [10:0] mantissa1, mantissa2;
  reg sign1, sign2;
  reg [21:0] mantissa_product; // Stores the 20-bit mantissa product
  reg [4:0] exp_result;

  always @ (*) begin
    // Extract fields
    if( in1==16'b0 || in2==16'b0) op=16'b0;
    else begin
      exp1 = in1[14:10];
      exp2 = in2[14:10];
      mantissa1 = {1'b1, in1[9:0]}; // Adding implicit leading 1
      mantissa2 = {1'b1, in2[9:0]}; // Adding implicit leading 1
      sign1 = in1[15];
      sign2 = in2[15];

      // Compute exponent
      exp_result = exp1 + exp2 - 5'd15;

      // Compute mantissa multiplication
      mantissa_product = mantissa1 * mantissa2;

      // Normalize mantissa if needed
      if (mantissa_product[21]) begin
        op[9:0] = mantissa_product[20:11]; // Normalized mantissa
        exp_result = exp_result + 1; // Adjust exponent
      end else begin
        op[9:0] = mantissa_product[19:10]; // Adjust mantissa
      end

      // Assign final values
      op[14:10] = exp_result;
      op[15] = sign1 ^ sign2; // XOR for sign determination
    end
  end
endmodule 
