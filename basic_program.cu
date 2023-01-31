#include <stdio.h>
#include <stdlib.h>
#include <cublas_v2.h>

__global__
void fill_in_array(const int n, double *x) {
  const int idx    = threadIdx.x;
  const int stride = blockDim.x;

  for(int i=idx;i<n;i+=stride)
    x[i] = i+1;
}

int main() {

  printf("Beginning C basic program...\n");

  int n = 1024;
  double *x;
  cudaMalloc(&x, sizeof(double)*n);

  fill_in_array<<<1, 1>>>(n, x);
  cudaError_t err = cudaGetLastError();
  if(err) {
    printf("Error name   : %s\n", cudaGetErrorName(err));
    printf("Error message: %s\n", cudaGetErrorString(err));
  }

  cublasHandle_t handle;
  cublasCreate(&handle);

  double sum;
  cublasDasum(handle, n, x, 1, &sum);

  double exact = n*(n+1)/2.0;

  if( fabs(1.0 - sum/exact) > 1e-15 ) {
    fprintf(stderr, "Sum does not match: %.15e != %.15e\n", sum, exact);
    exit(1);
  }

  cublasDestroy(handle);
  cudaFree(x);

  printf("Finished test with no errors\n");

  return 0;
}
