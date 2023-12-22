// Cannon's algorithm
#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>
#include<math.h>
#include <cstdlib>

void matrixMultiply(double *aBlock, double *bBlock, double *cBlock, int size)
{
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            double temp = 0;
            for (int k = 0; k < size; k++)
                temp += aBlock[i * size + k] * bBlock[k * size + j];
            cBlock[i * size + j] = temp;
        }
    }
}

void printMatrix(double *matrix, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++)
            printf("%8.2f ", matrix[i * size + j]);
        printf("\n");
    }
}

void RandomDataInitialization(double *aMatrix, double *bMatrix, int size) {
    int i, j;
    srand(unsigned(10));
    for (i = 0; i < size; i++)
        for (j = 0; j < size; j++)
        {
            aMatrix[i * size + j] = rand() / double(1000);
            bMatrix[i * size + j] = rand() / double(1000);
        }
}

void PrintTime(double x1, double x2)
{
    printf("\nTime: ");
    printf("%15.10f s \n", (x2 - x1));
}

int main(int argc, char* argv[]) {
	MPI_Comm cartComm;
	int dim[2], period[2], reorder;
	int coord[2], id;

	double *A, *B, *C;
	double *blockA, *blockB, *blockC;
	int count = 0;
	int worldSize;
	int procDim;
	int blockSize;
	int left, right, up, down;
	int bCastData[3];
    double t1, t2;
    
    if (argc < 2) {
        printf("run: main <matrix size> <print_matrix> (ex: main 500 1)\n");
        printf("<print_matrix> - optional, default = 0\n");
        return 0;
    }

    

    int size = std::atoi(argv[1]);     // размер матрицы
    int needPrintMatrix = 0; // выводить/не выводить матрицы
    
    if (argc == 3) {
        needPrintMatrix = std::atoi(argv[2]);
    }

	// Initialize the MPI environment
	MPI_Init(&argc, &argv);

	// World size
	MPI_Comm_size(MPI_COMM_WORLD, &worldSize);
	
	// Get the rank of the process
	int rank = 0;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if (rank == 0) {
		int n;
		char ch;
        A = new double[size * size];
        B = new double[size * size];
        C = new double[size * size];
        RandomDataInitialization(A, B, size);

		double sqroot = sqrt(worldSize);
		if ((sqroot - floor(sqroot)) != 0) {
			fprintf(stderr, "[ERROR] Number of processes must be a perfect square!\n");
			MPI_Abort(MPI_COMM_WORLD, 1);
		}

		int intRoot = (int)sqroot;
		if (size % intRoot != 0) {
			fprintf(stderr, "[ERROR] matrix size not divisible by %d!\n", intRoot);
			MPI_Abort(MPI_COMM_WORLD, 2);
		}

		procDim = intRoot;
		blockSize = size / intRoot;

        if (needPrintMatrix) {
            printf("A:\n");
            printMatrix(A, size);
            printf("\n");

            printf("B:\n");
            printMatrix(B, size);
            printf("\n");
        }

		bCastData[0] = procDim;
		bCastData[1] = blockSize;
		bCastData[2] = size;
	}
	
	// Create 2D Cartesian grid of processes
	MPI_Bcast(&bCastData, 3, MPI_INT, 0, MPI_COMM_WORLD);
	procDim = bCastData[0];
	blockSize = bCastData[1];
	size = bCastData[2];

	dim[0] = procDim; dim[1] = procDim;
	period[0] = 1; period[1] = 1;
	reorder = 1;
	MPI_Cart_create(MPI_COMM_WORLD, 2, dim, period, reorder, &cartComm);

	// Allocate local blocks for A and B
    blockA = new double[blockSize * blockSize];
    blockB = new double[blockSize * blockSize];
    blockC = new double[blockSize * blockSize];
    for (int i = 0; i < blockSize * blockSize; i++) {
        blockC[i] = 0.0;
    }

	// Create datatype to describe the subarrays of the global array
	int globalSize[2] = { size, size };
	int localSize[2] = { blockSize, blockSize };
	int starts[2] = { 0,0 };
	MPI_Datatype type, subarrtype;
	MPI_Type_create_subarray(2, globalSize, localSize, starts, MPI_ORDER_C, MPI_DOUBLE, &type);
	MPI_Type_create_resized(type, 0, blockSize * sizeof(double), &subarrtype);
	MPI_Type_commit(&subarrtype);

	double *globalptrA;
	double *globalptrB;
	double *globalptrC;
	if (rank == 0) {
		globalptrA = A;
		globalptrB = B;
		globalptrC = C;
	}

	// Scatter the array to all processors
	int* sendCounts = new int[worldSize];
	int* displacements = new int[worldSize];

	if (rank == 0) {
		for (int i = 0; i < worldSize; i++) {
			sendCounts[i] = 1;
		}
		int disp = 0;
		for (int i = 0; i < procDim; i++) {
			for (int j = 0; j < procDim; j++) {
				displacements[i * procDim + j] = disp;
				disp += 1;
			}
			disp += (blockSize - 1)* procDim;
		}
	}

	MPI_Scatterv(globalptrA, sendCounts, displacements, subarrtype, blockA,
		size * size / (worldSize), MPI_DOUBLE,
		0, MPI_COMM_WORLD);
	MPI_Scatterv(globalptrB, sendCounts, displacements, subarrtype, blockB,
		size * size / (worldSize), MPI_DOUBLE,
		0, MPI_COMM_WORLD);

	// Initial skew
	MPI_Cart_coords(cartComm, rank, 2, coord);

	MPI_Cart_shift(cartComm, 1, coord[0], &left, &right);
	MPI_Sendrecv_replace(blockA, blockSize * blockSize, MPI_DOUBLE, left, 1, right, 1, cartComm, MPI_STATUS_IGNORE);
	
    MPI_Cart_shift(cartComm, 0, coord[1], &up, &down);
	MPI_Sendrecv_replace(blockB, blockSize * blockSize, MPI_DOUBLE, up, 1, down, 1, cartComm, MPI_STATUS_IGNORE);

    for (int i = 0; i < blockSize*blockSize; i++) {
			blockC[i] = 0;
	}

    t1 = MPI_Wtime();
    double *multiplyRes = new double[blockSize*blockSize];
	for (int k = 0; k < procDim; k++) {
		matrixMultiply(blockA, blockB, multiplyRes, blockSize);

        for (int i = 0; i < blockSize*blockSize; i++) {
			blockC[i] += multiplyRes[i];
		}

		MPI_Cart_shift(cartComm, 1, 1, &left, &right);
		MPI_Cart_shift(cartComm, 0, 1, &up, &down);
		MPI_Sendrecv_replace(blockA, blockSize * blockSize, MPI_DOUBLE, left, 1, right, 1, cartComm, MPI_STATUS_IGNORE);
		MPI_Sendrecv_replace(blockB, blockSize * blockSize, MPI_DOUBLE, up, 1, down, 1, cartComm, MPI_STATUS_IGNORE);
	}
	
	// Gather results
	MPI_Gatherv(blockC, size * size / worldSize, MPI_DOUBLE,
		globalptrC, sendCounts, displacements, subarrtype,
		0, MPI_COMM_WORLD);


    t2 = MPI_Wtime();

	if (rank == 0 && needPrintMatrix) {
		printf("C:\n");
		printMatrix(C, size);
	}

	// Finalize the MPI environment
	MPI_Finalize();

    if (rank == 0) {
        PrintTime(t1, t2);
    }

	return 0;
}
