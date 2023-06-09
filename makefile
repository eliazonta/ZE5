# =============================================================================
# Filename: makefile
# Author: Zonta Elia 
# ============================================================================

CUDA_HOME=/usr/local/cuda-12.1
NVCC = $(CUDA_HOME)/bin/nvcc
CC = c++
NVCC_FLAG = -std=c++14
GPU_ARCH = -arch=sm_70 -m64
# GPU_ARCH := -arch=sm_52 # try
LIBS = -L${CUDA_HOME}/lib64
OPT = -std=c++14 -O3
#OPT = -O3 -g

# name
NAME := ZE5
NN := main
INCLUDE := dep.h
BIN_FOLDER := bin
SRC_FOLDER := src
OBJ_FOLDER := obj
BATCH_OUT_FOLDER := out
INCLUDE_FOLDER := include
DATA_FOLDER := data

OBJS := $(OBJ_FOLDER)/$(NN)
MAIN := $(NN).cu

################################################

all : $(NAME)

$(NAME) : $(BIN_FOLDER)/$(NN)

debug : OPT += -DDEBUG -g
debug : NVCC_FLAG += -G
debug : all

$(BIN_FOLDER)/$(NN) : $(SRC_FOLDER)/$(MAIN)
	@mkdir -p $(@D)	
	@mkdir -p $(BATCH_OUT_FOLDER)
	$(NVCC) $^ -o $@ $(GPU_ARCH) $(NVCC_FLAG) $(LIBS) $(OPT)

clean:
	rm -r $(BIN_FOLDER) $(OBJ_FOLDER)/*.o

clean_batch_outputs:
	rm -r $(BATCH_OUT_FOLDER)

download_datasets: check_python
	python3 scripts/download_datasets.py

check_python:
# checks if python exists
	@python3 --version > /dev/null 2>&1 || { echo >&2 "Python3 is required but it's not installed.  Aborting."; exit 1; }

clear_datasets: 
	rm $(DATA_FOLDER)/*