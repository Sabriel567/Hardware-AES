VFILES=$(wildcard *.v)

cpu : $(VFILES) Makefile
	iverilog -o -Wall cpu $(VFILES)

run : cpu
	timeout 10 ./cpu

test:
	@timeout 10 ./cpu > test.out 2>&1
	@((diff -b test.out test.ok > /dev/null 2>&1) && echo "pass") || (echo "fail" ; echo "\n\n----------- expected ----------"; cat test.ok ; echo "\n\n------------- found ----------"; cat test.out)

