# Binary Clock

Binary clock implemented in Verilog for the Sipeed Tang Nano 9K FPGA board.

The six LEDs display a binary counter. The counter advances once per second
when the design is built for the board's 27 MHz clock.

## Requirements

- [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)
- Sipeed Tang Nano 9K
- USB connection to the board

## Build and program

From the repository directory, load the OSS CAD Suite environment:

```sh
source ~/oss-cad-suite/environment
```

### 1. Synthesis

Convert the Verilog source into a JSON netlist:

```sh
yosys -p "read_verilog binaryClock.v; synth_gowin -top binaryClock -json binaryClock.json"
```

### 2. Place and route

Map the netlist and constraints to the Tang Nano 9K FPGA:

```sh
nextpnr-himbaechel \
  --device GW1NR-LV9QN88PC/I5 \
  --json binaryClock.json \
  --write pnr.json \
  --vopt family=GW1N-9C \
  --vopt cst=tangnano9k.cst
```

### 3. Generate the bitstream

Pack the place-and-route output into a Gowin bitstream:

```sh
gowin_pack -d GW1N-9C -o pack.fs pnr.json
```

### 4. Program the FPGA

Load the bitstream into the board's SRAM:

```sh
openFPGALoader -b tangnano9k pack.fs
```

The bitstream is volatile and must be loaded again after power is removed.
