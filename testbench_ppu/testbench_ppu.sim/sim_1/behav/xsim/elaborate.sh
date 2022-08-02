#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Mon Aug 01 21:30:24 EDT 2022
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 0f52afdc69ad4634ab812817db43238d --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_ppu_behav xil_defaultlib.tb_ppu -log elaborate.log"
xelab -wto 0f52afdc69ad4634ab812817db43238d --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_ppu_behav xil_defaultlib.tb_ppu -log elaborate.log

