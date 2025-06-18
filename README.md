FIFO Designs
This repository contains Verilog implementations of Synchronous and Asynchronous FIFOs, complete with testbenches and documentation. These designs are ideal for understanding FIFO concepts and can be used in larger digital systems.

Overview
A FIFO (First-In-First-Out) buffer is a fundamental building block in digital systems. It temporarily stores data and ensures it is read in the same order it was written.

Implemented Designs
Synchronous FIFO:

Operates under a single clock domain.

Handles full and empty conditions.

Simple and efficient for systems without clock domain crossing.

Asynchronous FIFO:

Operates under two different clock domains (write and read).

Implements Gray code-based pointer synchronization for clock domain crossing.

Ideal for interfacing subsystems with different clock speeds.

Features

Synchronous FIFO

Single clock domain.

Full and empty flag handling.

Simple testbench to validate operations.

Asynchronous FIFO

Dual clock domain support.

Gray code pointer synchronization.

Handles metastability and ensures reliable data transfer.
