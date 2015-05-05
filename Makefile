cpu : cpu.v
	iverilog -o cpu cpu.v

run : cpu
	timeout 10 ./cpu
