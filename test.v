`timescale 1ns / 1ps

module fft_8point_tb;

    // Inputs
    reg fftorifft;
    reg [15:0] real_in [0:7];
    reg [15:0] imag_in [0:7];

    // Outputs
    wire [15:0] real_outi [0:7];
    wire [15:0] imag_outi [0:7];
    wire invalid_input;

    // Instantiate the Unit Under Test (UUT)
    fft_8point uut (
        .fftorifft(fftorifft),
        .real_in(real_in),
        .imag_in(imag_in),
        .real_outi(real_outi),
        .imag_outi(imag_outi),
        .invalid_input(invalid_input)
    );

    // Testbench logic
    initial begin
        // Initialize inputs
        $display("Starting FFT 8-point testbench...\n");
      
      // Test Case 1: Infinity input test
        #5  fftorifft = 1'b0;
        real_in[0] = 16'h7C00; // +infinity
        real_in[1] = 16'h0000; // 0.0
        real_in[2] = 16'h0000; // 0.0
        real_in[3] = 16'h0000; // 0.0
        real_in[4] = 16'h0000; // 0.0
        real_in[5] = 16'h0000; // 0.0
        real_in[6] = 16'h0000; // 0.0
        real_in[7] = 16'h0000; // 0.0

        imag_in[0] = 16'h0000; // 0.0
        imag_in[1] = 16'h0000; // 0.0
        imag_in[2] = 16'h0000; // 0.0
        imag_in[3] = 16'h0000; // 0.0
        imag_in[4] = 16'h0000; // 0.0
        imag_in[5] = 16'h0000; // 0.0
        imag_in[6] = 16'h0000; // 0.0
        imag_in[7] = 16'h0000; // 0.0

        #100;
      $display("\nTest Case 1: Infinity Input Test");
        $display("invalid_input = %b (expected 1)", invalid_input);
        $display("Real Outputs:");
        $display("real_out[0] = %h", real_outi[0]);
        $display("real_out[1] = %h", real_outi[1]);
        $display("real_out[2] = %h", real_outi[2]);
        $display("real_out[3] = %h", real_outi[3]);
        $display("real_out[4] = %h", real_outi[4]);
        $display("real_out[5] = %h", real_outi[5]);
        $display("real_out[6] = %h", real_outi[6]);
        $display("real_out[7] = %h", real_outi[7]);

        $display("Imaginary Outputs:");
        $display("imag_out[0] = %h", imag_outi[0]);
        $display("imag_out[1] = %h", imag_outi[1]);
        $display("imag_out[2] = %h", imag_outi[2]);
        $display("imag_out[3] = %h", imag_outi[3]);
        $display("imag_out[4] = %h", imag_outi[4]);
        $display("imag_out[5] = %h", imag_outi[5]);
        $display("imag_out[6] = %h", imag_outi[6]);
        $display("imag_out[7] = %h", imag_outi[7]);
        
        // Test Case 2: Basic FFT test
        #5  fftorifft = 1'b0;
        real_in[0] = 16'h0000; // 0.0
        real_in[1] = 16'h0000; // 0.0
        real_in[2] = 16'h0000; // 0.0
        real_in[3] = 16'h0000; // 0.0
        real_in[4] = 16'h39a8; // 0.7071
        real_in[5] = 16'h39a8; // 0.7071
        real_in[6] = 16'h39a8; // 0.7071
        real_in[7] = 16'h39a8; // 0.7071

        imag_in[0] = 16'h0000; // 0.0
        imag_in[1] = 16'h0000; // 0.0
        imag_in[2] = 16'h39a8; // 0.7071
        imag_in[3] = 16'h39a8; // 0.7071
        imag_in[4] = 16'h0000; // 0.0
        imag_in[5] = 16'h0000; // 0.0
        imag_in[6] = 16'h39a8; // 0.7071
        imag_in[7] = 16'h39a8; // 0.7071

        #100;
      $display("\nTest Case 2: Basic FFT Test");
        $display("invalid_input = %b", invalid_input);
        $display("Real Outputs:");
        $display("real_out[0] = %h", real_outi[0]);
        $display("real_out[1] = %h", real_outi[1]);
        $display("real_out[2] = %h", real_outi[2]);
        $display("real_out[3] = %h", real_outi[3]);
        $display("real_out[4] = %h", real_outi[4]);
        $display("real_out[5] = %h", real_outi[5]);
        $display("real_out[6] = %h", real_outi[6]);
        $display("real_out[7] = %h", real_outi[7]);

        $display("Imaginary Outputs:");
        $display("imag_out[0] = %h", imag_outi[0]);
        $display("imag_out[1] = %h", imag_outi[1]);
        $display("imag_out[2] = %h", imag_outi[2]);
        $display("imag_out[3] = %h", imag_outi[3]);
        $display("imag_out[4] = %h", imag_outi[4]);
        $display("imag_out[5] = %h", imag_outi[5]);
        $display("imag_out[6] = %h", imag_outi[6]);
        $display("imag_out[7] = %h", imag_outi[7]);
        
        // Test Case 3: IFFT test
        #5  fftorifft = 1'b1;
        real_in[0] = 16'h41a8; // 3.0
        real_in[1] = 16'hb9a8; // -0.7071
        real_in[2] = 16'hbda8; // -1.7071
        real_in[3] = 16'hb9a8; // -0.7071
        real_in[4] = 16'h0000; // 0.0
        real_in[5] = 16'hb9a8; // -0.7071
        real_in[6] = 16'h3da8; // 1.7071
        real_in[7] = 16'hb9a8; // -0.7071

        imag_in[0] = 16'h41a8; // 3.0
        imag_in[1] = 16'h3ed3; // 0.9239
        imag_in[2] = 16'hbda8; // -1.7071
        imag_in[3] = 16'h34ae; // 0.3827
        imag_in[4] = 16'h0000; // 0.0
        imag_in[5] = 16'hb4ae; // -0.3827
        imag_in[6] = 16'hbda8; // -1.7071
        imag_in[7] = 16'hbed3; // -0.9239

        #100;
      $display("\nTest Case 3: IFFT Test");
        $display("invalid_input = %b", invalid_input);
        $display("Real Outputs:");
        $display("real_out[0] = %h", real_outi[0]);
        $display("real_out[1] = %h", real_outi[1]);
        $display("real_out[2] = %h", real_outi[2]);
        $display("real_out[3] = %h", real_outi[3]);
        $display("real_out[4] = %h", real_outi[4]);
        $display("real_out[5] = %h", real_outi[5]);
        $display("real_out[6] = %h", real_outi[6]);
        $display("real_out[7] = %h", real_outi[7]);

        $display("Imaginary Outputs:");
        $display("imag_out[0] = %h", imag_outi[0]);
        $display("imag_out[1] = %h", imag_outi[1]);
        $display("imag_out[2] = %h", imag_outi[2]);
        $display("imag_out[3] = %h", imag_outi[3]);
        $display("imag_out[4] = %h", imag_outi[4]);
        $display("imag_out[5] = %h", imag_outi[5]);
        $display("imag_out[6] = %h", imag_outi[6]);
        $display("imag_out[7] = %h", imag_outi[7]);
        
        

        // Test Case 4: All zeros input
        #5  fftorifft = 1'b0;
        for (integer i = 0; i < 8; i = i + 1) begin
            real_in[i] = 16'h0000;
            imag_in[i] = 16'h0000;
        end

        #100;
        $display("\nTest Case 4: All Zeros Input");
        $display("invalid_input = %b (expected 0)", invalid_input);
        $display("Real Outputs (should all be 0):");
        $display("real_out[0] = %h", real_outi[0]);
        $display("real_out[1] = %h", real_outi[1]);
        $display("real_out[2] = %h", real_outi[2]);
        $display("real_out[3] = %h", real_outi[3]);
        $display("real_out[4] = %h", real_outi[4]);
        $display("real_out[5] = %h", real_outi[5]);
        $display("real_out[6] = %h", real_outi[6]);
        $display("real_out[7] = %h", real_outi[7]);

        $display("Imaginary Outputs (should all be 0):");
        $display("imag_out[0] = %h", imag_outi[0]);
        $display("imag_out[1] = %h", imag_outi[1]);
        $display("imag_out[2] = %h", imag_outi[2]);
        $display("imag_out[3] = %h", imag_outi[3]);
        $display("imag_out[4] = %h", imag_outi[4]);
        $display("imag_out[5] = %h", imag_outi[5]);
        $display("imag_out[6] = %h", imag_outi[6]);
        $display("imag_out[7] = %h", imag_outi[7]);

        // End simulation
        $display("\nAll test cases completed.");
        $stop;
    end

endmodule


//output of FFT or IFFT accoarding to given input
/*

# KERNEL: Test Case 1: Infinity Input Test
# KERNEL: invalid_input = 1 (expected 1)
# KERNEL: Real Outputs:
# KERNEL: real_out[0] = xxxx
# KERNEL: real_out[1] = xxxx
# KERNEL: real_out[2] = xxxx
# KERNEL: real_out[3] = xxxx
# KERNEL: real_out[4] = xxxx
# KERNEL: real_out[5] = xxxx
# KERNEL: real_out[6] = xxxx
# KERNEL: real_out[7] = xxxx
# KERNEL: Imaginary Outputs:
# KERNEL: imag_out[0] = xxxx
# KERNEL: imag_out[1] = xxxx
# KERNEL: imag_out[2] = xxxx
# KERNEL: imag_out[3] = xxxx
# KERNEL: imag_out[4] = xxxx
# KERNEL: imag_out[5] = xxxx
# KERNEL: imag_out[6] = xxxx
# KERNEL: imag_out[7] = xxxx
# KERNEL: 
# KERNEL: Test Case 2: Basic FFT Test
# KERNEL: invalid_input = 0
# KERNEL: Real Outputs:
# KERNEL: real_out[0] = 41a8
# KERNEL: real_out[1] = b9a8
# KERNEL: real_out[2] = bda8
# KERNEL: real_out[3] = b9a8
# KERNEL: real_out[4] = 0000
# KERNEL: real_out[5] = b9a8
# KERNEL: real_out[6] = 3da8
# KERNEL: real_out[7] = b9a8
# KERNEL: Imaginary Outputs:
# KERNEL: imag_out[0] = 41a8
# KERNEL: imag_out[1] = 3ed3
# KERNEL: imag_out[2] = bda8
# KERNEL: imag_out[3] = 34ae
# KERNEL: imag_out[4] = 0000
# KERNEL: imag_out[5] = b4ae
# KERNEL: imag_out[6] = bda8
# KERNEL: imag_out[7] = bed3
# KERNEL: 
# KERNEL: Test Case 3: IFFT Test
# KERNEL: invalid_input = 0
# KERNEL: Real Outputs:
# KERNEL: real_out[0] = 0000
# KERNEL: real_out[1] = 9000
# KERNEL: real_out[2] = 0000
# KERNEL: real_out[3] = 9000
# KERNEL: real_out[4] = 39a8
# KERNEL: real_out[5] = 39a7
# KERNEL: real_out[6] = 39a8
# KERNEL: real_out[7] = 39a7
# KERNEL: Imaginary Outputs:
# KERNEL: imag_out[0] = 0000
# KERNEL: imag_out[1] = 0000
# KERNEL: imag_out[2] = 39a8
# KERNEL: imag_out[3] = 39a8
# KERNEL: imag_out[4] = 0000
# KERNEL: imag_out[5] = 0000
# KERNEL: imag_out[6] = 39a8
# KERNEL: imag_out[7] = 39a8
# KERNEL: 
# KERNEL: Test Case 4: All Zeros Input
# KERNEL: invalid_input = 0 (expected 0)
# KERNEL: Real Outputs (should all be 0):
# KERNEL: real_out[0] = 0000
# KERNEL: real_out[1] = 0000
# KERNEL: real_out[2] = 0000
# KERNEL: real_out[3] = 0000
# KERNEL: real_out[4] = 0000
# KERNEL: real_out[5] = 0000
# KERNEL: real_out[6] = 0000
# KERNEL: real_out[7] = 0000
# KERNEL: Imaginary Outputs (should all be 0):
# KERNEL: imag_out[0] = 0000
# KERNEL: imag_out[1] = 0000
# KERNEL: imag_out[2] = 0000
# KERNEL: imag_out[3] = 0000
# KERNEL: imag_out[4] = 0000
# KERNEL: imag_out[5] = 0000
# KERNEL: imag_out[6] = 0000
# KERNEL: imag_out[7] = 0000
# KERNEL: 
# KERNEL: All test cases completed.
*/
