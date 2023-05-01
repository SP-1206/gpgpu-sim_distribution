#include<stdio.h>
__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main() {
    cuda_hello<<<5,3>>>(); 
    return 0;
}
