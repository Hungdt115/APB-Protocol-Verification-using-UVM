# APB UVM Environment - Main Repository

## Project Overview

This repository contains a Universal Verification Methodology (UVM) based testbench for verifying an Advanced Peripheral Bus (APB) slave device. It is structured to facilitate the development, simulation, and analysis of the APB slave design.

![Block Diagram](doc/overview.png)

## Directory Structure

*   `apb_top.sv`: The top-level SystemVerilog file that instantiates the Design Under Test (DUT) and the UVM testbench environment.
*   `README.md`: This file, providing an overview of the project structure and execution.
*   `image.png`: A diagram or image related to the project.
*   `env/`: Contains UVM environment components.
*   `log/`: Stores simulation logs and output files.
*   `rep/`: Intended for reports (e.g., coverage reports).
*   `script/`: Contains utility scripts, such as the UVM log parser.
*   `sim/`: Holds simulation-related files, including build scripts and run commands.
*   `src/`: Contains the source code for the Design Under Test (DUT) and interfaces.
*   `test/`: Contains UVM test classes and sequences.

## Key Components

*   **DUT:** `src/apb_dut.v`
*   **UVM Environment:** `env/apb_env.sv`
*   **Base Test:** `test/test_classes/apb_base_test.sv`
*   **Simulation Entry Point:** `apb_top.sv`

## How to Run Simulations

To execute simulations, you typically need to navigate into the `sim/` directory and use the provided batch scripts.

1.  **Navigate to the simulation directory:**
    ```bash
    cd sim
    ```
2.  **Run a specific test (e.g., `apb_directed_test`):**
    ```bash
    sim_go.bat apb_dut apb_top apb_directed_test
    ```
    *   `apb_dut`: The name of the DUT module.
    *   `apb_top`: The name of the top-level testbench module.
    *   `apb_directed_test`: The name of the UVM test to execute.

3.  **Clean simulation artifacts:**
    ```bash
    clean.bat
    ```

## Getting Started

To get started with this APB UVM environment, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd 07_APB-Protocol-Verification-using-UVM
    ```

2.  **Ensure SystemVerilog/UVM simulator is installed:**
    This project requires a SystemVerilog simulator with UVM support (e.g., QuestaSim, VCS, Xcelium, Vivado XSim).

3.  **Run a simulation:**
    Navigate to the `sim` directory and execute one of the provided batch scripts. For example, to run the `apb_random_test`:
    ```bash
    cd sim
    sim_go.bat apb_dut apb_top apb_random_test
    ```

4.  **View logs and waveforms:**
    Simulation logs will be generated in the `log/` directory. Waveforms (if enabled in `apb_top.sv`) will be generated as `waveform.vcd` in the project root.

## References

*   [APB Protocol Verification using UVM](https://github.com/PRADEEPCHANGAL/APB-Protocol-Verification-using-UVM)
