program main

  implicit none
  integer i, n
  real*8 sum, exact
  real*8, allocatable :: x(:)

  n=100
  allocate(x(n))

  !$omp parallel do
  do i=1,n
     x(i) = i
  end do

  sum = 0
  !$omp parallel do reduction(+: sum)
  do i=1,n
     sum = sum + x(i)
  end do

  exact = n*(n+1)/2.0d0;

  if( abs(1.0d0 - sum/exact) > 1.0d-15 ) then
     write(*, '(A,ES22.15,A,ES22.15)') "Error: sum does not match", sum, " !=", exact
     call exit(1)
  end if

  deallocate(x)

  write(*, '(A)') "Finished test with no errors"
  
end program main
