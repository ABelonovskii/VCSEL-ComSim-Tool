# VCSEL-ComSim-Tool

This project is designed to connect MATLAB with COMSOL Multiphysics for the calculation of VCSEL (Vertical-Cavity Surface-Emitting Laser) emission parameters. It automates the parameter tuning and simulations to provide efficient and accurate analysis of VCSEL performance.

## Installation

To use this project, ensure you have MATLAB and COMSOL Multiphysics installed on your system. Follow these steps to set up the environment:

1. Install MATLAB if it's not already installed. Visit [MATLAB's official site](https://www.mathworks.com/products/matlab.html) for installation instructions.
2. Install COMSOL Multiphysics, ensuring you have the correct version that supports integration with MATLAB. Visit [COMSOL's official site](https://www.comsol.com) for more details.
3. Set up MATLAB with COMSOL Multiphysics:
   ```matlab
   addpath('C:\Program Files\COMSOL\COMSOL61\Multiphysics\mli');
   mphstart('localhost', 2036);
   ```
   
## Usage

To operate this simulation tool, follow these steps:

1. Open the MATLAB application on your computer.
2. Navigate to the directory containing the project files, or open the file `vertical_cavity_surface_emitting_laser.m` directly from your MATLAB environment.
3. Execute the script by pressing `Run`.

## Features

- **COMSOL Integration**: Directly connects MATLAB with COMSOL Multiphysics to facilitate seamless simulation setups and executions. This integration allows users to manipulate and run COMSOL models from within the MATLAB environment, streamlining the workflow for VCSEL parameter analysis.

- **Database Connectivity**: Utilizes a SQLite database to manage input and output data efficiently. The system fetches initial VCSEL parameters from the database, applies them in simulations, and then updates the database with the new results, ensuring that all data is centrally stored and easily accessible.

- **Automated Simulations**: Empowers users to conduct large-scale simulations across a range of parameters without manual intervention. This feature is particularly useful for exploring various configurations and understanding their impact on VCSEL performance.

### Copyright

© 2024, Aleksei Belonovskii
