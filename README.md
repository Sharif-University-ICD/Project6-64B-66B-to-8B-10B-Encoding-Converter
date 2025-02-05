# 64B/66B to 8B/10B Encoding Converter

This repository contains a Verilog-based implementation of a **64B/66B to 8B/10B encoding converter**, along with error injection modules to study error detection and robustness at different stages of the encoding process.

## Project Structure

The repository consists of three main directories:

### Converter (`converter/`)
- Implements the **64B/66B to 8B/10B encoding conversion**.
- Takes **64B/66B formatted input data** and encodes it into **8B/10B format**.
- Ensures proper encoding as per the 8B/10B encoding standard.

### Middle Error Injection (`middle error injection/`)
- Contains Verilog modules for the converter, **but introduces errors** during conversion.
- Specifically, an **error is inserted in every 8-bit chunk** before the 8B/10B encoding process.
- Helps analyze how errors affect encoding before the final conversion step.

### Final Error Injection (`final error injection/`)
- Similar to the `converter/` module, but **introduces errors at the 80-bit output** of the converter.
- Used to evaluate how errors propagate through the encoding process and impact decoding reliability.

---

## Project Goals & Analysis
- **Verify correctness** of the **64B/66B to 8B/10B encoding process**.
- **Evaluate error resilience** by introducing errors at different stages.
- **Analyze error detection capabilities** of the encoding scheme.

---

## Team Members
- Rozhin Taghizadegan
- Ashkan Tariverdi
