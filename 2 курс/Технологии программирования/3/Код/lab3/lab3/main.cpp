#include <windows.h>
#include <windowsx.h>
#include <string>
#include <cmath>
#include <utility>
#include <sstream>

using namespace std;

HWND mainWindow, childWindow;
HWND sizeMatrixText, resultText, resultSumText;
HWND editSizeMatrix;
HWND submitButton1, submitButton2, radioButton1, radioButton2, resultButton, closeButton;
HWND matrixEdit[10][10], matrixEdit2[10][10];

LRESULT CALLBACK WndMainProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam);
LRESULT CALLBACK WndChildProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam);

// ������� �������� ����
const int widthMainWnd = 410;
const int heightMainWnd = 400;

// ������� ��������� ����
const int widthChildWnd = 410;
const int heightChildWnd = 400;
const int heightChildWndSm = 120;

int m = 0;
int oldm;
double** masMatrix;
char operationType = -1;
char matrState = 0;

void clearMatrix(double **&matrx, int s) {
	if (matrx != nullptr)
	{
		for (int i = 0; i < s; i++)
		{
			if (matrx[i] != nullptr)
			{
				delete[] matrx[i];
				matrx[i] = nullptr;
			}
		}
		delete[] matrx;
		matrx = nullptr;
	}
}

void copyMatrix(double** a, double** b, int n)
{
	for (int i = 0; i < n; i++)
	{
		a[i] = new double[n];

		for (int j = 0; j < n; j++)
		{
			a[i][j] = b[i][j];
		}
	}
}


char get_trangle_matrix(double** matrx, double**&a,  int n) {
	for (int i = 0; i < n; i++)
	{
		// ����� �������� ��������
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

		// ������ ���
		for (int j = i + 1; j < n; j++)
		{
			double m = -a[j][i] / a[i][i];
			for (int k = i; k < n; k++)
				a[j][k] += a[i][k] * m;
		}
	}
	return 0;
}

double diagonal_sum(double** matrx, int n)
{
	double sum = 0;
	for (int i = 0; i < n; i++)
	{
		sum += matrx[i][i];
	}
	return sum;
}


// ����� �����
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdline, int nShowCmd)
{
	MSG msg;
	memset(&msg, 0, sizeof(msg));

	// ������� ����
	WNDCLASSEX wndMain;
	memset(&wndMain, 0, sizeof(wndMain));
	wndMain.cbSize = sizeof(wndMain); // ������ ���������
	wndMain.style = CS_VREDRAW | CS_VREDRAW; // ����������� ��� ��������� �������� ����
	wndMain.lpfnWndProc = (WNDPROC)WndMainProc; // ���������� ����
	wndMain.hInstance = hInstance; // ���������� ����������
	wndMain.hbrBackground = (HBRUSH)COLOR_WINDOW; // ��� ����
	wndMain.lpszClassName = L"MainWndClass";

	if (!RegisterClassEx(&wndMain))
	{
		int nResult = GetLastError();
		MessageBox(NULL, L"����� �������� ���� �� ��� ������!", L"������", MB_ICONERROR);
	}

	mainWindow = CreateWindowEx(
		NULL,
		L"MainWndClass",
		L"Lab3",
		WS_DLGFRAME | WS_SYSMENU | WS_MINIMIZEBOX,
		CW_USEDEFAULT, // x
		0, // y
		widthMainWnd, // width
		heightMainWnd, // height
		NULL, // id ������������� ����
		NULL,
		hInstance,
		NULL
	);

	if (!mainWindow)
	{
		MessageBox(NULL, L"������� ���� �� ���� �������!", L"������", MB_ICONERROR);
	}

	// �������� ����
	WNDCLASSEX wndChild;
	memset(&wndChild, 0, sizeof(wndChild));
	wndChild.cbSize = sizeof(wndChild); // ������ ���������
	wndChild.style = CS_VREDRAW | CS_VREDRAW; // ����������� ��� ��������� �������� ����
	wndChild.lpfnWndProc = (WNDPROC)WndChildProc; // ���������� ����
	wndChild.hInstance = hInstance; // ���������� ����������
	wndChild.hbrBackground = (HBRUSH)COLOR_WINDOW; // ��� ����
	wndChild.lpszClassName = L"ChildWndClass";

	if (!RegisterClassEx(&wndChild))
	{
		int nResult = GetLastError();
		MessageBox(NULL, L"����� ��������� ���� �� ��� ������!", L"������", MB_ICONERROR);
	}

	childWindow = CreateWindowEx(
		NULL,
		L"ChildWndClass",
		L"Result",
		WS_DLGFRAME,
		CW_USEDEFAULT, // x
		0, // y
		widthChildWnd, // width
		heightChildWnd, // height
		mainWindow, // id ������������� ����
		NULL,
		hInstance,
		NULL
	);

	if (!childWindow)
	{
		MessageBox(NULL, L"�������� ���� �� ���� �������!", L"������", MB_ICONERROR);
	}


	ShowWindow(mainWindow, SW_SHOW);
	UpdateWindow(mainWindow);

	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return 0;
}

LRESULT CALLBACK WndMainProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	unsigned int tLength;
	char *editValue = nullptr;
	char *err = NULL;

	switch (message)
	{
	case WM_CREATE:
		
		sizeMatrixText = CreateWindow(L"STATIC", L"������ ������� �������:", WS_VISIBLE | WS_CHILD, 20, 20, 200, 20, hwnd, NULL, NULL, NULL);
		editSizeMatrix = CreateWindow(L"EDIT", L"", WS_VISIBLE | WS_CHILD | WS_BORDER | ES_NUMBER, 260, 20, 40, 20, hwnd, NULL, NULL, NULL);
		Edit_LimitText(editSizeMatrix, 1); // ����������� ���-�� �������� � ���� �����

		submitButton1 = CreateWindow(L"BUTTON", L"�������", WS_VISIBLE | WS_CHILD | WS_BORDER, 320, 20, 60, 20, hwnd, (HMENU)1, NULL, NULL);

		radioButton1 = CreateWindow(L"BUTTON", L"����������� ���", WS_CHILD | WS_VISIBLE | BS_AUTORADIOBUTTON,
			20, 300, 150, 20, hwnd, (HMENU)3, NULL, NULL);
		radioButton2 = CreateWindow(L"BUTTON", L"����� ��-� ��. ���������", WS_CHILD | WS_VISIBLE | BS_AUTORADIOBUTTON,
			20, 320, 200, 20, hwnd, (HMENU)4, NULL, NULL);

		resultButton = CreateWindow(L"BUTTON", L"���������", WS_VISIBLE | WS_CHILD | WS_BORDER, 300, 320, 80, 20, hwnd, (HMENU)5, NULL, NULL);

		break;
	
	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case 1: // ������� ������� �������
			oldm = m;
			tLength = GetWindowTextLength(editSizeMatrix) + 1;
			editValue = new char[tLength];
			GetWindowTextA(editSizeMatrix, editValue, tLength + 1);
			m = atoi(editValue);
			delete[] editValue;

			if (m < 1)
			{
				MessageBox(hwnd, L"���������� ��������: �� 1 �� 9", L"������", MB_OK);
				return 0;
			}

			clearMatrix(masMatrix, oldm);

			for (int i = 0; i < oldm; i++)
			{
				for (int j = 0; j < oldm; j++)
				{
					DestroyWindow(matrixEdit[i][j]);
				}
			}
			DestroyWindow(submitButton2);

			//�������� ������
			for (int i = 0; i < m; i++)
			{
				for (int j = 0; j < m; j++)
				{
					matrixEdit[i][j] = CreateWindow(L"EDIT", L"0", WS_VISIBLE | WS_CHILD | WS_BORDER,
						j * 40 + 20, i * 25 + 55, 40, 25, hwnd, NULL, NULL, NULL);
					Edit_LimitText(matrixEdit[i][j], 3); // ����������� ���-�� �������� � ���� �����
				}
			}

			submitButton2 = CreateWindow(L"BUTTON", L"�������", WS_VISIBLE | WS_CHILD | WS_BORDER,
				m * 20, m * 25 + 60, 80, 20, hwnd, (HMENU)2, NULL, NULL);

			matrState = 0;

			break;
		case 2: // ������� �������
			if (matrState == 0)
			{
				try
				{
					masMatrix = new double* [m];
					for (int i = 0; i < m; i++)
					{
						masMatrix[i] = new double[m];
						for (int j = 0; j < m; j++)
						{
							tLength = GetWindowTextLength(matrixEdit[i][j]) + 1;
							editValue = new char[tLength];
							GetWindowTextA(matrixEdit[i][j], editValue, tLength + 1);
							masMatrix[i][j] = strtod(editValue, &err);
							Edit_Enable(matrixEdit[i][j], false);
							if (*err)
							{
								throw 100;
							}
							delete[] editValue;
						}
					}
					SetWindowText(submitButton2, L"��������");
					matrState = 1;
				}
				catch (...)
				{
					for (int i = 0; i < m; i++)
					{
						for (int j = 0; j < m; j++)
						{
							Edit_Enable(matrixEdit[i][j], true);
						}
					}

					MessageBox(hwnd, L"������� �����!", L"������", MB_OK);
					return -1;
				}
			}
			else
			{
				clearMatrix(masMatrix, m);
				matrState = 0;
				SetWindowText(submitButton2, L"�������");
				for (int i = 0; i < m; i++)
				{
					for (int j = 0; j < m; j++)
					{
						Edit_Enable(matrixEdit[i][j], true);
					}
				}
			}
			
			break;

		case 3: // radio 1;
			switch (Button_GetCheck(radioButton1))
			{
			case BST_CHECKED:
				operationType = 0;
				break;
			}

			break;
		case 4: // radio 2;
			switch (Button_GetCheck(radioButton2))
			{
			case BST_CHECKED:
				operationType = 1;
				break;
			}

			break;
		case 5: // ����������
			if (operationType == -1){
				MessageBox(hwnd, L"���������� ������� ��������", L"������", MB_OK);
			}
			else if (matrState == 0)
			{
				MessageBox(hwnd, L"���������� ������� �������", L"������", MB_OK);
			}
			else
			{
				EnableWindow(mainWindow, false);
				ShowWindow(childWindow, SW_SHOW);
				SetFocus(childWindow);
			}
			break;
		}
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hwnd, message, wParam, lParam);
	}
}


LRESULT CALLBACK WndChildProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
	case WM_SHOWWINDOW:
		for (int i = 0; i < m; i++)
		{
			for (int j = 0; j < m; j++)
			{
				DestroyWindow(matrixEdit2[i][j]);
			}
		}
		DestroyWindow(closeButton);

		if (operationType == 0){
			double** resMatrix = new double* [m];
			copyMatrix(resMatrix, masMatrix, m);

			char trer = get_trangle_matrix(masMatrix, resMatrix, m);
			if (trer == 0)
			{
				SetWindowPos(hwnd, NULL, 0, 0, widthChildWnd, heightChildWnd, SWP_NOMOVE);
				resultText = CreateWindow(L"STATIC", L"����������� �������:", WS_VISIBLE | WS_CHILD, 20, 20, 300, 20, hwnd, NULL, NULL, NULL);
				closeButton = CreateWindow(L"BUTTON", L"�������", WS_VISIBLE | WS_CHILD | WS_BORDER, 300, 320, 80, 20, hwnd, (HMENU)1, NULL, NULL);

				//�������� �������
				for (int i = 0; i < m; i++)
				{
					for (int j = 0; j < m; j++)
					{
						wstringstream wss;
						wss << floor(resMatrix[i][j] * 1000.0 + 0.5) / 1000.0;
						matrixEdit2[i][j] = CreateWindow(
							L"EDIT", wss.str().c_str(), WS_VISIBLE | WS_CHILD | WS_BORDER,
							j * 40 + 20, i * 25 + 55, 40, 25, hwnd, NULL, NULL, NULL);
						Edit_Enable(matrixEdit2[i][j], false);
					}
				}
			}
			else
			{
				SetWindowPos(hwnd, NULL, 0, 0, widthChildWnd, heightChildWndSm, SWP_NOMOVE);
				resultText = CreateWindow(L"STATIC", L"���������� �������� ����������� �������", WS_VISIBLE | WS_CHILD, 20, 20, 300, 20, hwnd, NULL, NULL, NULL);
				closeButton = CreateWindow(L"BUTTON", L"�������", WS_VISIBLE | WS_CHILD | WS_BORDER, 300, 50, 80, 20, hwnd, (HMENU)1, NULL, NULL);
			}
			clearMatrix(resMatrix, m);
		}
		else
		{
			SetWindowPos(hwnd, NULL, 0, 0, widthChildWnd, heightChildWndSm, SWP_NOMOVE);
			resultText = CreateWindow(L"STATIC", L"����� ��������� ������� ���������:", WS_VISIBLE | WS_CHILD, 20, 20, 300, 20, hwnd, NULL, NULL, NULL);
			closeButton = CreateWindow(L"BUTTON", L"�������", WS_VISIBLE | WS_CHILD | WS_BORDER, 300, 50, 80, 20, hwnd, (HMENU)1, NULL, NULL);

			double resSum = diagonal_sum(masMatrix, m);

			wstringstream wss;
			wss << resSum;
			resultSumText = CreateWindow(L"STATIC", wss.str().c_str(), WS_VISIBLE | WS_CHILD, 300, 20, 50, 20, hwnd, NULL, NULL, NULL);
		}
		break;
	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case 1: // �������
			DestroyWindow(resultText);
			ShowWindow(childWindow, SW_HIDE);
			EnableWindow(mainWindow, true);
			SetFocus(mainWindow);
			break;
		}

		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
		break;
	default:
		return DefWindowProc(hwnd, message, wParam, lParam);
	}
}

