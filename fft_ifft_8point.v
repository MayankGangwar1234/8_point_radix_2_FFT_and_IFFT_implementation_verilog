
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
