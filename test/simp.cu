#include <stdio.h>

__global__ void addOne(int* arr, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        arr[idx] += 1;
    }
}

int main() {
    const int size = 5000;
    int arr[size];
    int* d_arr;

    // Allocate memory on device
    cudaMalloc(&d_arr, sizeof(int) * size);

    // Initialize array values
    for (int i = 0; i < size; i++) {
        arr[i] = i + 1;
    }

    // Copy array to device
    cudaMemcpy(d_arr, arr, sizeof(int) * size, cudaMemcpyHostToDevice);

    // Launch kernel to add 1 to array values
    int threadsPerBlock = 256;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;
    addOne<<<blocksPerGrid, threadsPerBlock>>>(d_arr, size);

    // Copy array back to host
    cudaMemcpy(arr, d_arr, sizeof(int) * size, cudaMemcpyDeviceToHost);

    // Print array values
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    // Free memory on device
    cudaFree(d_arr);

    return 0;
}

