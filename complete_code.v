// Code your design here
// Code your design here
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

module ieee16bitaddition(input [15:0] in1, input [15:0] in2,input signal, output reg [15:0] op);
  reg [4:0] exp1, exp2;
  reg [10:0] mantissa1, mantissa2;
  reg sign1, sign2;
  reg [11:0] mantissa_addition; // Stores the 20-bit mantissa product
  reg [4:0] exp_result;

  always @ (*) begin
    // Extract fields
    if(~signal) begin
      if(in1==16'b0 && in2==16'b0) op=16'b0;
      else begin
        exp1 = in1[14:10];
        exp2 = in2[14:10];
        mantissa1 = {1'b1, in1[9:0]}; // Adding implicit leading 1
        mantissa2 = {1'b1, in2[9:0]}; // Adding implicit leading 1
        sign1 = in1[15];
        sign2 = in2[15];
        if(exp1>exp2) begin
          while(exp1!=exp2) begin
            mantissa2={1'b0,mantissa2[10:1]};
            exp2=exp2+1;
          end
        end
        else begin
          while(exp2!=exp1) begin
            mantissa1={1'b0,mantissa1[10:1]};
            exp1=exp1+1;
          end
        end

        // Compute exponent
        exp_result = exp1 ;

        // Compute mantissa multiplication
        mantissa_addition = mantissa1 + mantissa2;
        if(mantissa_addition==12'b0) op=16'b0;
        else begin

        // Normalize mantissa if needed
        if (mantissa_addition[11]) begin
          op[9:0] = mantissa_addition[10:1]; // Normalized mantissa
          exp_result = exp_result + 1; // Adjust exponent
        end else begin
          op[9:0] = mantissa_addition[9:0]; // Adjust mantissa
        end

        // Assign final values
        op[14:10] = exp_result;
        op[15] = sign1 | sign2; // XOR for sign determination
        end
      end
    end
  end
endmodule

module ieee16bitsubtraction (input [15:0] in1, input [15:0] in2,input signal, output reg [15:0] op);
  reg [4:0] exp1, exp2;
  reg [10:0] mantissa1, mantissa2;
  reg sign1, sign2;
  reg [11:0] mantissa_subtraction;
  reg [11:0] real_mantissa;// Stores the 20-bit mantissa product
  reg [4:0] exp_result;

  always @ (*) begin
    // Extract fields
    if(signal) begin
      exp1 = in1[14:10];
      exp2 = in2[14:10];
      mantissa1 = {1'b1, in1[9:0]}; // Adding implicit leading 1
      mantissa2 = {1'b1, in2[9:0]}; // Adding implicit leading 1
      sign1 = in1[15];
      sign2 = in2[15];
      if(exp1>exp2) begin
        op[15]=sign1;
        while(exp1!=exp2) begin
          mantissa2={1'b0,mantissa2[10:1]};
          exp2=exp2+1;
        end
      end
      else begin
        op[15]=sign2;
        while(exp2!=exp1) begin
          mantissa1={1'b0,mantissa1[10:1]};
          exp1=exp1+1;
        end
      end

      // Compute exponent
      exp_result = exp1+1'b1 ;

      // Compute mantissa multiplication
      mantissa_subtraction = mantissa1 - mantissa2;

      // Normalize mantissa if needed
      if (mantissa_subtraction[11]) begin
        real_mantissa=~mantissa_subtraction+1'b1;
        if(exp1==exp2)  op[15]=sign2;
      end
      else real_mantissa=mantissa_subtraction;
      if(real_mantissa==12'b0) op=16'b0;
      else begin
        while(~real_mantissa[11]) begin
          real_mantissa={real_mantissa[10:0],1'b0};
          exp_result=exp_result-1'b1;
        end
      

      // Assign final values
      op[9:0]=real_mantissa[10:1];
      op[14:10] = exp_result;
      end
       // XOR for sign determination
    end
  end
endmodule


module ieee16bit_add(input [15:0] in1,input [15:0]in2,output reg [15:0]op);
  wire signal;
  assign signal=in1[15]^in2[15];
  wire [15:0]opadd,opsub;
  ieee16bitsubtraction sub(in1,in2,signal,opsub);
  ieee16bitaddition add(in1,in2,signal,opadd);
  assign op= in1[15]^in2[15] ? opsub:opadd;
endmodule

module ieee16bit_sub(input [15:0] in1,input [15:0]in2,output reg [15:0]op);
  reg [15:0] tin2;
  always @(*) begin
  tin2={~in2[15],in2[14:0]};
  end
  ieee16bit_add x(in1,tin2,op);
endmodule

module multi_two_imaginary(input [15:0] real_in1,input [15:0] imag_in1,input [15:0] real_in2,input [15:0] imag_in2,output reg [15:0] real_op,output reg [15:0] imag_op);
  //(a+ib)(c+id)=ac-bd+i(ad+bc)
  wire [15:0] ac,bd,ad,bc;
  ieee16bitmultiplier mul0(.in1(real_in1),.in2(real_in2),.op(ac));
  
  ieee16bitmultiplier mul1(.in1(imag_in1),.in2(imag_in2),.op(bd));
  
  ieee16bitmultiplier mul2(.in1(real_in1),.in2(imag_in2),.op(ad));
  
  ieee16bitmultiplier mul3(.in1(imag_in1),.in2(real_in2),.op(bc));
  
  ieee16bit_add add(.in1(ad),.in2(bc),.op(imag_op));
  
  ieee16bit_sub sub(.in1(ac),.in2(bd),.op(real_op));
  
endmodule
                    
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

module fft_8point (
  	input wire fftorifft,
    input wire [15:0] real_in [0:7], // Real part of inputs
    input wire [15:0] imag_in [0:7], // Imaginary part of inputs
  output reg [15:0] real_outi [0:7], // Real part of FFT output
  output reg [15:0] imag_outi [0:7], // Imaginary part of FFT output
  output reg invalid_input
);
    
    reg [15:0] real_stage1 [0:7], imag_stage1 [0:7];
    reg [15:0] real_stage2 [0:7], imag_stage2 [0:7];
    reg [15:0] real_stage3 [0:7], imag_stage3 [0:7];
  	reg [15:0] real_out [0:7], imag_out[0:7];
    
    bit_reversal_8point br (
        .real_in(real_in), .imag_in(imag_in),
        .real_out(real_stage1), .imag_out(imag_stage1)
    );
    
  reg [15:0] w0_real [0:3], w0_imag [0:3];
    
    twiddle_factor_rom twiddle_rom (
      .fftorifft(fftorifft),
      .W0_real(w0_real[0]), .W0_imag(w0_imag[0]),
      .W1_real(w0_real[1]), .W1_imag(w0_imag[1]),
      .W2_real(w0_real[2]), .W2_imag(w0_imag[2]),
      .W3_real(w0_real[3]), .W3_imag(w0_imag[3])
    );
    
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 2) begin : stage1
            butterfly_unit bfi (
                .real_in1(real_stage1[i]), .imag_in1(imag_stage1[i]),
                .real_in2(real_stage1[i+1]), .imag_in2(imag_stage1[i+1]),
                .real_out1(real_stage2[i]), .imag_out1(imag_stage2[i]),
                .real_out2(real_stage2[i+1]), .imag_out2(imag_stage2[i+1])
            );
        end
    endgenerate
  
    reg [15:0] a1, ai1, a2, ai2, a3, ai3, a4, ai4;
  reg [15:0] b1,bi1,b2,bi2,b3,bi3,b4,bi4;
  multi_two_imaginary a(.real_in1(real_stage2[2]),.imag_in1(imag_stage2[2]),.real_in2(w0_real[0]),.imag_in2(w0_imag[0]),.real_op(a1),.imag_op(ai1));
  multi_two_imaginary b(.real_in1(real_stage2[3]),.imag_in1(imag_stage2[3]),.real_in2(w0_real[2]),.imag_in2(w0_imag[2]),.real_op(a2),.imag_op(ai2));
  multi_two_imaginary c(.real_in1(real_stage2[6]),.imag_in1(imag_stage2[6]),.real_in2(w0_real[0]),.imag_in2(w0_imag[0]),.real_op(a3),.imag_op(ai3));
  multi_two_imaginary d(.real_in1(real_stage2[7]),.imag_in1(imag_stage2[7]),.real_in2(w0_real[2]),.imag_in2(w0_imag[2]),.real_op(a4),.imag_op(ai4));
  
  butterfly_unit bf1 (
    .real_in1(real_stage2[0]), .imag_in1(imag_stage2[0]),
    .real_in2(a1), .imag_in2(ai1),
    .real_out1(real_stage3[0]), .imag_out1(imag_stage3[0]),
    .real_out2(real_stage3[2]), .imag_out2(imag_stage3[2])
            );
  butterfly_unit bf2 (
    .real_in1(real_stage2[1]), .imag_in1(imag_stage2[1]),
    .real_in2(a2), .imag_in2(ai2),
    .real_out1(real_stage3[1]), .imag_out1(imag_stage3[1]),
    .real_out2(real_stage3[3]), .imag_out2(imag_stage3[3])
            );
  butterfly_unit bf3 (
    .real_in1(real_stage2[4]), .imag_in1(imag_stage2[4]),
    .real_in2(a3), .imag_in2(ai3),
    .real_out1(real_stage3[4]), .imag_out1(imag_stage3[4]),
    .real_out2(real_stage3[6]), .imag_out2(imag_stage3[6])
            );
   butterfly_unit bf4 (
     .real_in1(real_stage2[5]), .imag_in1(imag_stage2[5]),
     .real_in2(a4), .imag_in2(ai4),
     .real_out1(real_stage3[5]), .imag_out1(imag_stage3[5]),
     .real_out2(real_stage3[7]), .imag_out2(imag_stage3[7])
            );
  
  multi_two_imaginary e(.real_in1(real_stage3[4]),.imag_in1(imag_stage3[4]),.real_in2(w0_real[0]),.imag_in2(w0_imag[0]),.real_op(b1),.imag_op(bi1));
  multi_two_imaginary f(.real_in1(real_stage3[5]),.imag_in1(imag_stage3[5]),.real_in2(w0_real[1]),.imag_in2(w0_imag[1]),.real_op(b2),.imag_op(bi2));
  multi_two_imaginary g(.real_in1(real_stage3[6]),.imag_in1(imag_stage3[6]),.real_in2(w0_real[2]),.imag_in2(w0_imag[2]),.real_op(b3),.imag_op(bi3));
  multi_two_imaginary h(.real_in1(real_stage3[7]),.imag_in1(imag_stage3[7]),.real_in2(w0_real[3]),.imag_in2(w0_imag[3]),.real_op(b4),.imag_op(bi4));
  
  
  butterfly_unit bf5 (
    .real_in1(real_stage3[0]), .imag_in1(imag_stage3[0]),
    .real_in2(b1), .imag_in2(bi1),
    .real_out1(real_out[0]), .imag_out1(imag_out[0]),
    .real_out2(real_out[4]), .imag_out2(imag_out[4])
            );
  
   butterfly_unit bf6 (
     .real_in1(real_stage3[1]), .imag_in1(imag_stage3[1]),
     .real_in2(b2), .imag_in2(bi2),
     .real_out1(real_out[1]), .imag_out1(imag_out[1]),
     .real_out2(real_out[5]), .imag_out2(imag_out[5])
            );
  
   butterfly_unit bf7 (
     .real_in1(real_stage3[2]), .imag_in1(imag_stage3[2]),
     .real_in2(b3), .imag_in2(bi3),
     .real_out1(real_out[2]), .imag_out1(imag_out[2]),
     .real_out2(real_out[6]), .imag_out2(imag_out[6])
            );
  
  butterfly_unit bf8 (
    .real_in1(real_stage3[3]), .imag_in1(imag_stage3[3]),
    .real_in2(b4), .imag_in2(bi4),
    .real_out1(real_out[3]), .imag_out1(imag_out[3]),
    .real_out2(real_out[7]), .imag_out2(imag_out[7])
            );
  reg [4:0] div_real[0:7],real_outz[0:7],imag_outz[0:7];
    reg [4:0] div_imag[0:7];
    reg [4:0] minus[0:7];

    integer j,k;
    always @(*) begin
      if(real_in[0][14:10]==5'd31 || real_in[1][14:10]==5'd31 || real_in[2][14:10]==5'd31 || real_in[3][14:10]==5'd31 || real_in[4][14:10]==5'd31 || real_in[5][14:10]==5'd31 ||real_in[6][14:10]==5'd31 || real_in[7][14:10]==5'd31 ||imag_in[0][14:10]==5'd31 ||imag_in[1][14:10]==5'd31 ||imag_in[2][14:10]==5'd31 ||imag_in[3][14:10]==5'd31 ||imag_in[4][14:10]==5'd31 ||imag_in[5][14:10]==5'd31 ||imag_in[6][14:10]==5'd31 ||real_out[7][14:10]==5'd31 )begin
      
      invalid_input=1'b1;
      end
      else begin
        invalid_input=1'b0;
    if(fftorifft==1) begin
      
        for (j = 0; j < 8; j = j + 1) begin
        if(real_out[j][14:10]==5'b0) begin
            real_outz[j][4:0]=5'b0;
        end
        else begin
        div_real[j] = real_out[j][14:10];
        minus[j] = 5'b00011;
        real_outz[j][4:0] = div_real[j] - minus[j];
        end

        if(imag_out[j][14:10]==5'b0)begin
            // Extract exponent bits [14:10]
            imag_outz[j][4:0]=5'b0;
            end
            else begin
            div_imag[j] = imag_out[j][14:10];
            minus[j] = 5'b00011;
            imag_outz[j][4:0] = div_imag[j] - minus[j];
            end
            
        end
        real_outi=real_out;
        imag_outi=imag_out;
      for(k=0;k<8;k=k+1) begin
        real_outi[k][14:10]=real_outz[k];
        imag_outi[k][14:10]=imag_outz[k];
        end
        end
        else begin
        real_outi=real_out;
        imag_outi=imag_out;
        end

    end
    end
endmodule
