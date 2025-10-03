# Verilog Cache Controller Project

## Overview
This project implements a **synchronous 4-way set-associative cache** in Verilog/SystemVerilog. It includes:  

- **Cache controller with FSM** for managing reads, writes, hits, misses, allocation, and eviction.  
- **4-way set-associative cache** with round-robin victim replacement using T flip-flops.  
- **Single-block storage modules** with tag, valid, and dirty bits.  
- **19-bit registers and flip-flops** for tag storage and control.  
- **Testbench** to simulate cache operations with read/write sequences.

The cache supports **read and write requests**, tracks hits and misses, and handles evictions of dirty blocks when needed.

---

## Project Structure

```
.
├── ffd.sv              # D flip-flop with async reset and enable
├── reg19.sv            # 19-bit register built from ffd
├── t_flipflop.sv       # T flip-flop with enable
├── block.sv            # Single cache block with tag, valid, and dirty bits
├── set.sv              # 4-way cache set with 4 blocks and victim selection
├── cache.sv            # Top-level cache module (128 sets)
├── cache_controller.sv # Cache controller connecting FSM and sets
├── fsm.sv              # Finite state machine for cache control
├── testbench.sv        # Testbench for simulating read/write sequences
└── README.md           # Project documentation
```

---

## Cache Architecture

1. **Cache Controller**
   - Decodes 32-bit address into:
     - **Tag (19 bits)**  
     - **Set index (7 bits for 128 sets)**  
   - Routes read/write requests to the appropriate cache set.  
   - Interfaces with FSM to control allocation, eviction, and hit checking.

2. **FSM (Finite State Machine)**
   - States:
     - `IDLE` – Wait for valid request  
     - `CHECK` – Determine hit or miss  
     - `READ_HIT` / `WRITE_HIT` – Handle hits  
     - `READ_MISS` / `WRITE_MISS` – Handle misses  
     - `EVICT` – Evict dirty block if necessary  
     - `ALLOC` – Allocate block for new data  
   - Generates control signals (`rdy`, `alloc`, `change`, `check`, `lru`) for the cache sets.

3. **Cache Set**
   - 4-way associative (`block[0..3]`)  
   - **T flip-flops** implement round-robin victim selection.  
   - Tracks **valid**, **dirty**, and **tag** for each block.  
   - Generates **hit**, **dirty**, and **valid** outputs.

4. **Cache Block**
   - Stores a **tag** in a 19-bit register (`reg19`).  
   - Stores **valid** and **dirty** bits in single-bit flip-flops (`ffd`).  

---

## Simulation / Testbench
- `testbench.sv`:
  - Initializes clock and reset.
  - Performs a sequence of reads and writes to different addresses.
  - Monitors FSM state, ready signal, hit/miss, and cache behavior.
- Waveforms can be dumped to `dump.vcd` for viewing in GTKWave.

---

## Usage
1. Compile all files using a Verilog/SystemVerilog simulator (e.g., Icarus Verilog, ModelSim):
   ```bash
   iverilog -g2012 -o cache_tb ffd.sv reg19.sv t_flipflop.sv block.sv set.sv cache.sv cache_controller.sv fsm.sv testbench.sv
   ```
2. Run the simulation:
   ```bash
   vvp cache_tb
   ```
3. Open the waveform file (`dump.vcd`) in GTKWave to inspect cache behavior:
   ```bash
   gtkwave dump.vcd
   ```

---

## Features
- 128 sets (7-bit index)  
- 4-way set-associative  
- Round-robin victim replacement  
- Dirty and valid bit tracking  
- Tag storage with 19-bit registers  
- Fully synchronous design with FSM control  

---

## Future Improvements
- Add **write-back memory interface** for evicted dirty blocks.  
- Extend to **parameterized cache size / associativity**.  
- Add **LRU replacement** instead of simple round-robin.  
- Add **more comprehensive testbench** with random access patterns.  

---
