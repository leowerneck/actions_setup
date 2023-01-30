#include <iostream>

int main() {

  std::cout << "Beginning C++ basic program...\n";

  int n = 1000;
  double *x = new double[n];

#pragma omp parallel for
  for(int i=0;i<n;i++)
    x[i] = i+1;

  double sum = 0;
#pragma omp parallel for reduction(+: sum)
  for(int i=0;i<n;i++)
    sum += x[i];

  double exact = n*(n+1)/2.0;

  if( std::abs(1.0 - sum/exact) > 1e-15 ) {
    std::cerr.precision(15);
    std::cerr << std::scientific << "Sum does not match: " << sum << " != " << exact << std::endl;
    exit(1);
  }

  delete[] x;

  std::cout << "Finished test with no errors\n";

  return 0;
}
