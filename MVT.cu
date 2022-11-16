#include <cstdio>
#include <cuda_runtime.h>
#include <stdlib.h>
#if defined(NDEBUG)
#define CUDA_CHECK(X) (X)
#else
#define CUDA_CHECK(X) do{\
	(X);\
	cudaError_t e = cudaGetLastError();\
	if(cudaSuccess != e){\
		printf("cuda failure %s at %s : %d",cudaGetErrorString(e), __FILE__, __LINE__);\
		exit(1);\
	}\
}while(0)
#endif



__global__ void mulKernel(int* c, const int* a, const int* b, const int WIDTH) {
	int x = threadIdx.x;
	int y = threadIdx.y;
	int i = y * WIDTH + x;

	int sum = 0;
	for (int k = 0; k < WIDTH; k++) {
		sum += a[y * WIDTH + k] * b[k * WIDTH + x];
	}
	c[i] = sum;
}

int main()
{
    int WIDTH;
    
    printf("\n INGRESAR TAMAÑO DE LAS MATRICES:");
    scanf("%d",&WIDTH);
	
	int a[WIDTH][WIDTH];
	int b[WIDTH][WIDTH];
	int c[WIDTH][WIDTH] = { 0 };

	for (int y = 0; y < WIDTH; y++) {
		for (int x = 0; x < WIDTH; x++) {
			a[y][x] = rand() % 20;
			b[y][x] = rand() % 20;
		}
	}
/*
    //imprimiendo matriz A
    printf("VALORES DE MATRIZ A \n");
	for (int y = 0; y < WIDTH; y++)
	{
		for (int x = 0; x < WIDTH; x++)
		{
			printf("%5d", a[y][x]);
		}
		printf("\n");
	}
	
	printf("\n\n VALORES DE MATRIZ B \n");
	for (int y = 0; y < WIDTH; y++)
	{
		for (int x = 0; x < WIDTH; x++)
		{
			printf("%5d", b[y][x]);
		}
		printf("\n\n");
	}
*/	
	//device side data
	int* dev_a = 0;
	int* dev_b = 0;
	int* dev_c = 0;

	//allocate device memory
	cudaMalloc((void**)&dev_a, WIDTH * WIDTH * sizeof(int));
	cudaMalloc((void**)&dev_b, WIDTH * WIDTH * sizeof(int));
	cudaMalloc((void**)&dev_c, WIDTH * WIDTH * sizeof(int));
    
    
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    
	//copy from host to device
	cudaMemcpy(dev_a, a, WIDTH * WIDTH * sizeof(int), cudaMemcpyHostToDevice);	//dev_a = a
	cudaMemcpy(dev_b, b, WIDTH * WIDTH * sizeof(int), cudaMemcpyHostToDevice);	//dev_b = b

	//launch a kernel on the GPU with one thread for each element
	dim3 dimBlock(WIDTH, WIDTH, 1);	//x,y,z
	cudaEventRecord(start);
	mulKernel << <1, dimBlock >> > (dev_c, dev_a, dev_b, WIDTH);
	cudaEventRecord(stop);
	CUDA_CHECK(cudaPeekAtLastError());

	//copy from device to host
	cudaMemcpy(c, dev_c, WIDTH * WIDTH * sizeof(int), cudaMemcpyDeviceToHost);
	cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

	//free device memory
	cudaFree(dev_c);
	cudaFree(dev_a);
	cudaFree(dev_b);

/*	//print the result
	printf("RESULTADO DE MULTIPLICACION -> MATRIZ C \n");
	for (int y = 0; y < WIDTH; y++) {
		for (int x = 0; x < WIDTH; x++) {
			printf("%10d", c[y][x]);
		}
		printf("\n");
	}
*/	
	printf("%fn <-TIME ", milliseconds);
	return 0;
}

