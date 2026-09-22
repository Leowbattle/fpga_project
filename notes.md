When trying to use lower baud rates than 115200 you need a larger counter to implement the clock divider. Mine was hardcoded too small, leading to a bug. Verilog does not give a warning and silently overflows.

Bit order of decimal numbers. Instead of using binary as before I wrote the data for the character 'a' using decimal.

Off by one errors matter a lot.