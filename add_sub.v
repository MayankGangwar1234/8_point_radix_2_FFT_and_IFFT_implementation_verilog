module ieee16bitaddition(input [15:0] in1, input [15:0] in2, input signal, output reg [15:0] op);
    reg [4:0] exp1, exp2;
    reg [10:0] mantissa1, mantissa2;
    reg sign1, sign2;
    reg [11:0] mantissa_addition;
    reg [4:0] exp_result;
    integer i;

    always @ (*) begin
        if(~signal) begin
            if(in1==16'b0 && in2==16'b0) op=16'b0;
            else begin
                exp1 = in1[14:10];
                exp2 = in2[14:10];
                mantissa1 = {1'b1, in1[9:0]};
                mantissa2 = {1'b1, in2[9:0]};
                sign1 = in1[15];
                sign2 = in2[15];

                // Fixed iteration count (max 31 shifts for 5-bit exponent)
                if(exp1 > exp2) begin
                    for(i=0; i<31 && exp1!=exp2; i=i+1) begin
                        mantissa2 = {1'b0, mantissa2[10:1]};
                        exp2 = exp2 + 1;
                    end
                end
                else begin
                    for(i=0; i<31 && exp2!=exp1; i=i+1) begin
                        mantissa1 = {1'b0, mantissa1[10:1]};
                        exp1 = exp1 + 1;
                    end
                end

                exp_result = exp1;
                mantissa_addition = mantissa1 + mantissa2;
                
                if(mantissa_addition==12'b0) op=16'b0;
                else begin
                    if (mantissa_addition[11]) begin
                        op[9:0] = mantissa_addition[10:1];
                        exp_result = exp_result + 1;
                    end else begin
                        op[9:0] = mantissa_addition[9:0];
                    end
                    op[14:10] = exp_result;
                    op[15] = sign1 | sign2;
                end
            end
        end
    end
endmodule

module ieee16bitsubtraction(input [15:0] in1, input [15:0] in2, input signal, output reg [15:0] op);
    reg [4:0] exp1, exp2;
    reg [10:0] mantissa1, mantissa2;
    reg sign1, sign2;
    reg [11:0] mantissa_subtraction;
    reg [11:0] real_mantissa;
    reg [4:0] exp_result;
    integer i, j;

    always @ (*) begin
        
        if(signal) begin
            if(in1==in2)begin
                op=16'b0;
            end
            else begin
            exp1 = in1[14:10];
            exp2 = in2[14:10];
            mantissa1 = {1'b1, in1[9:0]};
            mantissa2 = {1'b1, in2[9:0]};
            sign1 = in1[15];
            sign2 = in2[15];

            if(exp1 > exp2) begin
                op[15] = sign1;
                for(i=0; i<31 && exp1!=exp2; i=i+1) begin
                    mantissa2 = {1'b0, mantissa2[10:1]};
                    exp2 = exp2 + 1;
                end
            end
            else begin
                op[15] = sign2;
                for(i=0; i<31 && exp2!=exp1; i=i+1) begin
                    mantissa1 = {1'b0, mantissa1[10:1]};
                    exp1 = exp1 + 1;
                end
            end

            exp_result = exp1 + 1'b1;
            mantissa_subtraction = mantissa1 - mantissa2;

            if (mantissa_subtraction[11]) begin
                real_mantissa = ~mantissa_subtraction + 1'b1;
                if(exp1 == exp2) op[15] = sign2;
            end
            else real_mantissa = mantissa_subtraction;
            
            if(real_mantissa == 12'b0) op = 16'b0;
            else begin
                // Fixed iteration count for normalization
                for(j=0; j<11 && ~real_mantissa[11]; j=j+1) begin
                    real_mantissa = {real_mantissa[10:0], 1'b0};
                    exp_result = exp_result - 1'b1;
                end
                
                op[9:0] = real_mantissa[10:1];
                op[14:10] = exp_result;
            end
            end
        end
    end
endmodule


module ieee16bit_add(input [15:0] in1,input [15:0]in2,output wire [15:0]op);
  wire signal;
  assign signal=in1[15]^in2[15];
  wire [15:0]opadd,opsub;
  ieee16bitsubtraction sub(in1,in2,signal,opsub);
  ieee16bitaddition add(in1,in2,signal,opadd);
  assign op= in1[15]^in2[15] ? opsub:opadd;
endmodule

module ieee16bit_sub(input [15:0] in1,input [15:0]in2,output wire [15:0]op);
  reg [15:0] tin2;
  always @(*) begin
  tin2={~in2[15],in2[14:0]};
  end
  ieee16bit_add x(in1,tin2,op);
endmodule
