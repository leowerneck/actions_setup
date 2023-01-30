#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main() {

  int n = 1000;
  double *x = (double *)malloc(sizeof(double)*n);

#pragma omp parallel for
  for(int i=0;i<n;i++)
    x[i] = i;

  double sum = 0;
#pragma omp parallel for reduction(+: sum)
  for(int i=0;i<n;i++)
    sum += x[i];

  double exact = (n-1)*n/2.0;

  if( fabs(1.0 - sum/exact) > 1e-15 ) {
    fprintf(stderr, "Sum does not match: %.15e != %.15e\n", sum, exact);
    exit(1);
  }

  free(x);

  printf("Finished test with no errors\n");
  
  return 0;
}
