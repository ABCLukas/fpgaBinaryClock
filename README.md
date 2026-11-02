# FPGA Binary Clock

This project implements a six-bit binary clock for the Tang Nano 9K FPGA board. The clock input and LED pin assignments are defined in `tangnano9k.cst`.

## Prerequisites

Install the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) and make sure the Tang Nano 9K is connected over USB. Run the following commands from this project directory.

## Build and Flash

1. Load the OSS CAD Suite environment:

	```sh
	source ~/oss-cad-suite/environment
	```

2. Synthesize the Verilog design into a JSON netlist:

	```sh
	yosys -p "read_verilog binaryClock.v; synth_gowin -top binaryClock -json binaryClock.json"
	```

3. Place and route the netlist using the Tang Nano 9K device and constraints:

	```sh
	nextpnr-himbaechel \
	  --device GW1NR-LV9QN88PC/I5 \
	  --json binaryClock.json \
	  --write pnr.json \
	  --vopt family=GW1N-9C \
	  --vopt cst=tangnano9k.cst
	```

4. Pack the place-and-route output into a Gowin bitstream:

	```sh
	gowin_pack -d GW1N-9C -o pack.fs pnr.json
	```

5. Flash the bitstream to the connected Tang Nano 9K:

	```sh
	openFPGALoader -b tangnano9k pack.fs
	```

The generated files are `binaryClock.json`, `pnr.json`, and `pack.fs`. Re-running the build overwrites these files.
