#!/bin/bash

iverilog -o sim $1 $2 && ./sim
