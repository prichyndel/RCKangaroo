CC := g++
NVCC := /usr/local/cuda-11.8/bin/nvcc
CUDA_PATH ?= /usr/local/cuda-11.8

CCFLAGS := -O3 -I$(CUDA_PATH)/include
NVCCFLAGS := -O3 -gencode=arch=compute_89,code=compute_89 -gencode=arch=compute_86,code=compute_86
LDFLAGS := -L$(CUDA_PATH)/lib64 -lcudart -pthread

CPU_SRC := RCKangaroo.cpp GpuKang.cpp Ec.cpp utils.cpp
GPU_SRC := RCGpuCore.cu

CPP_OBJECTS := $(CPU_SRC:.cpp=.o)
CU_OBJECTS := $(GPU_SRC:.cu=.o)

TARGET := rckangaroo

all: $(TARGET)

$(TARGET): $(CPP_OBJECTS) $(CU_OBJECTS)
	$(CC) $(CCFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cpp
	$(CC) $(CCFLAGS) -c $< -o $@

%.o: %.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

clean:
	rm -f $(CPP_OBJECTS) $(CU_OBJECTS) $(TARGET) 
