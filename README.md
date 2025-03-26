# 8_point_radix_2_FFT_and_IFFT_implementation_verilog

# IEEE 16-bit Floating Point FFT/IFFT 8-point Processor

Verilog of an 8-point Fast Fourier Transform (FFT) and Inverse FFT (IFFT) processor using IEEE 16-bit floating-point arithmetic.

## Features

- **Radix-2 Decimation-in-Time (DIT) algorithm** for efficient computation
- **IEEE 754 half-precision (16-bit) floating-point** arithmetic
- **Supports both FFT and IFFT** operations with mode selection
- **Bit-reversal reordering** for correct output ordering
- **Twiddle factor ROM** with precomputed values
- **Error detection** for invalid inputs (NaN/Infinity)
- **Complex number support** with separate real/imaginary components

## Modules Overview

### Core Components

1. **IEEE 16-bit Floating Point Units**
   - `ieee16bitmultiplier`: Floating-point multiplier
   - `ieee16bitaddition`: Floating-point adder
   - `ieee16bitsubtraction`: Floating-point subtractor

2. **Complex Number Operations**
   - `multi_two_imaginary`: Complex number multiplier
   - `butterfly_unit`: FFT butterfly computation unit

3. **FFT-Specific Modules**
   - `bit_reversal_8point`: Bit-reversal reordering
   - `twiddle_factor_rom`: Precomputed twiddle factors
   - `fft_8point`: Complete 8-point FFT/IFFT processor

### Testbench
- Comprehensive test cases including:
  - Infinity input detection
  - Basic FFT operation
  - IFFT operation
  - All-zeros input test

## Implementation Details

### Floating-Point Format
- 16-bit IEEE 754 half-precision:
  - 1 sign bit
  - 5 exponent bits
  - 10 mantissa bits (with implicit leading 1)

### FFT Algorithm
1. Input bit-reversal reordering
2. Three stages of butterfly computations:
   - Stage 1: 4 parallel butterflies
   - Stage 2: 2 parallel butterflies with twiddle factors
   - Stage 3: Final butterfly computations with twiddle factors
### IFFT Algorithm
 1.Input bit-reversal reordering
 2.Reorder the input data based on bit-reversed indices.
 3.Three stages of butterfly computations (inverse FFT processing):
   -Stage 1: 4 parallel butterflies (basic butterfly operations).
   -Stage 2: 2 parallel butterflies with inverse twiddle factors.
   -Stage 3: Final butterfly computations with inverse twiddle factors.
 4.Normalize the output (divide each value by N, where N is the FFT size).
### Twiddle Factors
Precomputed values for 8-point FFT:
- W₈⁰ = 1 + j0
- W₈¹ = (1/√2) - j(1/√2)
- W₈² = 0 - j1
- W₈³ = -(1/√2) - j(1/√2)
Precomputed values for 8-point FFT:
- W₈⁰ = 1 + j0
- W₈¹ = (1/√2) + j(1/√2)
- W₈² = 0 + j1
- W₈³ = -(1/√2) + j(1/√2)

## Simulation Results

The testbench verifies:
- Correct handling of special cases (zero, infinity)
- Accurate FFT computation
- Proper IFFT operation (reconstruction of original signal)
- Error detection for invalid inputs

# Applications of FFT and IFFT  

## Overview  
FFT (Fast Fourier Transform) and IFFT (Inverse Fast Fourier Transform) are widely used mathematical techniques for analyzing and manipulating signals in the frequency domain. They have applications in various fields, including signal processing, communications, and medical imaging.  

## Applications  

### 1. Signal & Audio Processing  
- Noise reduction  
- Equalization  
- Pitch detection  
### 2. Image Processing  
- Compression (JPEG)  
- Edge detection  
- Image reconstruction  
### 3. Communication Systems  
- Used in OFDM (WiFi, 4G, 5G) for modulation and demodulation  
- Spectrum analysis  
### 4. Medical Imaging  
- MRI and CT scan image reconstruction  
- Frequency domain transformations for better visualization  
### 5. Radar & Sonar  
- Doppler shift analysis  
- Object detection and tracking  
### 6. Computational Physics & Engineering  
- Solving differential equations  
- Applications in quantum mechanics and fluid dynamics  
### 7. Data Compression & Reconstruction  
- MP3 audio compression  
- JPEG image encoding  
- Adaptive filtering  

## Contributors  
- [Aalok Moliya](https://github.com/AalokMoliya)  
- [Mayank Gangwar](https://github.com/MayankGangwar1234)  
- [Shudhanshu Bhadana](https://github.com/SHUDHANSHU-BHADANA) 
## Conclusion  
FFT is used to transform signals into the frequency domain, while IFFT reconstructs them back into the time domain. Their applications make them essential tools in modern digital signal processing and computational fields.  

### License  
This project is open-source and available for use under the MIT License.
