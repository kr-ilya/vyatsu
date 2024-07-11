#pragma once

#include "pch.h"
#include <utility>
#include <cmath>
#include "matrixDll.h"


using namespace std;

char get_trangle_matrix(double**& a, int n) {
	for (int i = 0; i < n; i++)
	{
		// поиск опорного элемента
		int z = i;
		char f = 0;
		for (int h = z + 1; h < n; h++)
		{
			if (abs(a[z][i]) < abs(a[h][i]) || a[z][i] == 0)
			{
				if (a[z][i] == 0)
					f = 1;

				if (a[h][i] != 0)
					swap(a[z], a[h]);
			}
		}

		if (f == 1) {
			return 1;
		}

		// прямой ход
		for (int j = i + 1; j < n; j++)
		{
			double m = -a[j][i] / a[i][i];
			for (int k = i; k < n; k++)
				a[j][k] += a[i][k] * m;
		}
	}
	return 0;
}

