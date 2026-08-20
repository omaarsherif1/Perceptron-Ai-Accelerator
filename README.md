# Single Perceptron AI Hardware Accelerator

A parameterized Verilog RTL implementation of a single-perceptron AI hardware accelerator and scalable neural network layer. Designed for embedded hardware systems requiring real-time streaming inference with optimized area and low latency.

---

## Key Features

* **Parameterized Architecture**: Default configuration uses 8-bit signed inputs (`DATA_WIDTH = 8`) and a 32-bit signed accumulator (`ACC_WIDTH = 32`) to prevent numerical overflow.
* **Resource Efficient**: Uses MSB bit-checking for hardware-friendly Rectified Linear Unit (ReLU) activation.
* **Control Unit**: Integrated Finite State Machine (FSM) managing tracking counter, accumulation cycles, and completion signaling.
* **Pipelined Optimization**: Includes an optimized pipelined MAC architecture to break the critical path between multiplication and accumulation stages.
* **Scalable Layer Integration**: Support for multi-neuron fully connected layers using vector flattening and reduction logic (`perceptron_layer`).

---

## Hardware Architecture

The accelerator follows a feed-forward datapath:

$$\text{Output} = \text{ReLU}\left( \sum_{i=0}^{N-1} (X_i \cdot W_i) + \text{Bias} \right)$$

```
 +-------+       +-------------------+       +---------------+       +------+
 | X_bus | ----> |                   | ----> |               | ----> |      | ----> final_output
 | W_bus | ----> |  MAC Accumulator  |       | Bias Addition |       | ReLU |
 +-------+       +-------------------+       +---------------+       +------+
                           ^
                           |
                     +-----------+
                     |    FSM    |
                     +-----------+
```

## Hardware Schematics & Module Breakdown

### Single Perceptron Top Module (`perceptron_top`)
The top-level single perceptron integrates the FSM controller, MAC unit, bias adder, and ReLU activation module into a single unified datapath.

![Single Perceptron Top Schematic](Documentation/Schematics/Screenshot%202026-08-13%20144934.png)

---

### Parallel Perceptron Layer (`perceptron_layer`)
Scales multiple perceptron cores in parallel using a vector-flattened interface and reduction-AND logic to coordinate `layer_done` status across all units.

![Perceptron Layer Schematic](Documentation/Schematics/Screenshot%202026-08-13%20145814.png)
---

## Repository Structure

```text
Perceptron-Ai-Accelerator/
├── Documentation/
│   ├── accelerator.pdf                   # Complete project documentation
│   ├── Presentation2                     # Project presentation slide deck
│   ├── Project Proposal V3 - Google Docs # Initial project design proposal
│   └── schematics/                       # Hardware schematic renders[
│       ├── Screenshot 2026-08-13 144934
│       └── Screenshot 2026-08-13 145814
├── RTL/                                  # Synthesizable Verilog source code
│   ├── mac_unit.v
│   ├── mac_unit_pipelined.v
│   ├── Bias_Add_Unit.v
│   ├── RelU.v
│   ├── fsm_controller.v
│   ├── perceptron_top.v
│   └── perceptron_layer.v
├── Testbench/                            # Verification testbenches & setups
│   ├── tb_mac_unit.v
│   └── tb_perceptron_top.v
├── LICENSE                               # Open-source license
└── README.md                             # Project overview & documentation
```
## Team Contributions & Project Roles

| Team Member | Module / Role | Key Engineering Contributions |
| :--- | :--- | :--- |
| **Amr Khaled Mohamed Ali** | **System Integration & Architecture Lead** | • Designed top-level wrappers (`perceptron_top`, `perceptron_layer`)[cite: 1, 2].<br>• Implemented spatial parallelism via `generate` loops & dynamic indexing (`+:`).<br>• Designed pipeline registers & sign-extension logic for timing closure. |
| **Omar Sherif Zaki** | **Verification & Testing Engineer** | • Developed testbenches (`tb_perceptron_layer`) for system verification[cite: 1].<br>• Managed stimulus generation, signal timing checks, and test scenario coverage. |
| **Omar Mohamed Salem** | **MAC Unit Designer** | • Implemented the Multiply-Accumulate (`mac_unit`) hardware core[cite: 1, 2].<br>• Integrated 2's complement arithmetic & signed accumulation logic. |
| **Mariam Hossam Mohamed** | **Control Unit Engineer** | • Designed the Finite State Machine (`fsm_controller`)[cite: 1, 2].<br>• Managed system handshaking, synchronization signals (`mac_en`, `clear`), and state flow. |
| **Roaa Sheriff Sayed** | **Data Post-Processing Engineer** | • Designed the `Bias_Add_Unit` with bit-width sign expansion[cite: 1, 2].<br>• Implemented the non-linear `ReLU` activation function module. |
---

## Interface Specifications

| Port Name | Width | Direction | Description |
| :--- | :--- | :--- | :--- |
| `clk` | 1 | Input | System clock signal |
| `rst_n` | 1 | Input | Active-low asynchronous reset |
| `start` | 1 | Input | Trigger signal to initialize execution |
| `data_valid` | 1 | Input | High when input features on bus are valid |
| `x_in` | `DATA_WIDTH` | Input | Streaming signed input feature |
| `w_in` | `DATA_WIDTH` | Input | Streaming signed weight value |
| `bias` | `DATA_WIDTH` | Input | Signed bias offset |
| `final_output` | `ACC_WIDTH` | Output | Evaluated post-activation decision value |
| `done` | 1 | Output | Asserted when computation cycle completes |

---

## Verification & Simulation Results

The design was verified using ModelSim across comprehensive operational scenarios

1. **Standard Positive Inputs**: Verified basic MAC and accumulation logic.
2. **Asynchronous Reset Recovery**: Confirmed state recovery and accumulator clearing mid-execution.
3. **Signed Negative Arithmetic**: Evaluated negative weight/feature interactions and ReLU zero-clamping.
4. **Boundary Extreme Multiplications**: Validated mathematical handling at full signed boundaries (e.g., $-128 \times 127$).
5. **Accumulator Stress Test**: Confirmed 32-bit accumulator dynamic range without dynamic overflow.
6. **Bias Offset Verification**: Validated sign extension and negative bias subtraction.

---

## Team & Acknowledgments

* **Project Team**: Mariam Hossam Mohamed, Omar Sherif Zaki, Amr Khaled Mohamed, Roaa Sheriff Sayed, Omar Mohamed Salem.
* **Program**: NTI Digital Design Using FPGA Training Program.
