#!/bin/bash
#
#SBATCH --job-name=matMul-parallel
#SBATCH --output=matMul-parallel.txt
#SBATCH --nodes=4
#SBATCH --tasks-per-node=1
#SBATCH --time=05:00

mpiexec matMul-parallel 16
