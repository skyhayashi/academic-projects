// Libraries
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define TAG_INITA  1 // tag for sending/receiving Matrix A
#define TAG_INITB  2 // tag for sending/receiving Matrix B
#define TAG_RESULT 3 // tag for collecting result Matrix C

int main(int argc, char *argv[]){
  // Variables
  double *matA, *matB, *matC;
  int size, rank;
  int n; // matrix dimension
  int extraRows, rowsperprocess;
  int i, j, k;
  double t;
  MPI_Status status;

  MPI_Init(&argc, &argv); // start up MPI
  MPI_Comm_size(MPI_COMM_WORLD, &size); // get number of processes
  MPI_Comm_rank(MPI_COMM_WORLD, &rank); // get process rank

  n = atoi(argv[1]); // get matrix dimension from command line
  rowsperprocess = n/(size-1);
  extraRows = n%(size-1);

  matB = (double *)calloc(n*n, sizeof(double)); // allocate memory for matB
  if(rank==0){ // master
    matA = (double *)calloc(n*n, sizeof(double)); // allocate memory for matA
    matC = (double *)calloc(n*n, sizeof(double)); // allocate memory for matC

    for(i=0; i<n*n; i++){ // initialize matrices
      matA[i] = 1.0;
      matB[i] = 2.0;
      matC[i] = 0.0;
    }

    t = MPI_Wtime(); // start timer

    for(i=1; i<size; i++){ // send matB and chunk of matA to each slave
      MPI_Send(matB, n*n, MPI_DOUBLE, i, TAG_INITB, MPI_COMM_WORLD);
      if(i==size-1){
        MPI_Send(matA+(i-1)*rowsperprocess*n, (rowsperprocess+extraRows)*n, MPI_DOUBLE, i, TAG_INITA, MPI_COMM_WORLD);
      }
      else{
        MPI_Send(matA+(i-1)*rowsperprocess*n, rowsperprocess*n, MPI_DOUBLE, i, TAG_INITA, MPI_COMM_WORLD);
      }
    }
  }
  else{ // slaves
    if(rank==size-1){
      rowsperprocess += extraRows;
    }

    matA = (double *)calloc(rowsperprocess*n, sizeof(double)); // allocate memory for matA
    matC = (double *)calloc(rowsperprocess*n, sizeof(double)); // allocate memory for matC

    // Receive matB and matA
    MPI_Recv(matB, n*n, MPI_DOUBLE, 0, TAG_INITB, MPI_COMM_WORLD, &status);
    MPI_Recv(matA, rowsperprocess*n, MPI_DOUBLE, 0, TAG_INITA, MPI_COMM_WORLD, &status);
  }

  if(rank>0){ // slaves
    for(i=0; i<rowsperprocess; i++){ // each slave does computation of received portion
      for(j=0; j<n; j++){
        matC[i*n+j] = 0.0;
        for(k=0; k<n; k++){
          matC[i*n+j] += matA[i*n+k]*matB[k*n+j];
        }
      }
    }

    // Send result to master
    MPI_Send(matC, rowsperprocess*n, MPI_DOUBLE, 0, TAG_RESULT, MPI_COMM_WORLD);
  }
  else{ // master
    for(i=1; i<size; i++){ // receive result
      if(i==size-1){
        MPI_Recv(matC+(i-1)*rowsperprocess*n, (rowsperprocess+extraRows)*n, MPI_DOUBLE, i, TAG_RESULT, MPI_COMM_WORLD, &status);
      }
      else{
        MPI_Recv(matC+(i-1)*rowsperprocess*n, rowsperprocess*n, MPI_DOUBLE, i, TAG_RESULT, MPI_COMM_WORLD, &status);
      }
    }

    t = MPI_Wtime()-t; // stop timer
    printf("Total computation time is %f seconds.\n", t);

    if(n<=16){ // print result if n<=16
      printf("Result C:\n");
      for(i=0; i<n*n; i++){
        if(i%n==0){
          printf("\n");
        }
        printf("%6.2f\t", matC[i]);
      }
    }
    printf("\n");
  }

  // Free memory
  free(matA);
  free(matB);
  free(matC);

  MPI_Finalize(); // shut down MPI
  return 0;
}
