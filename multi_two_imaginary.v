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
