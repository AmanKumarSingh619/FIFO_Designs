# 🚀 FIFO Designs

This repository contains Verilog implementations of **Synchronous** and **Asynchronous FIFOs**, complete with testbenches and documentation. These designs are ideal for understanding FIFO concepts and can be used in larger digital systems.

---

## 🛠️ **Overview**

A FIFO (First-In-First-Out) buffer is a fundamental building block in digital systems. It temporarily stores data and ensures it is read in the same order it was written.

### **Implemented Designs**
1. **Synchronous FIFO**:
   - Operates under a single clock domain.
   - Handles full and empty conditions.
   - Simple and efficient for systems without clock domain crossing.

2. **Asynchronous FIFO**:
   - Operates under two different clock domains (write and read).
   - Implements Gray code-based pointer synchronization for clock domain crossing.
   - Ideal for interfacing subsystems with different clock speeds.
