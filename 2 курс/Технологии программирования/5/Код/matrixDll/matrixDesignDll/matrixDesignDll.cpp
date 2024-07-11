#pragma once
#include "pch.h"
#include <windows.h>
#include <windowsx.h>
#include "matrixDesignDll.h"

HWND initMain(int w, int h, HINSTANCE hInstance) {
	return CreateWindowEx(
		NULL,
		L"MainWndClass",
		L"Lab3",
		WS_DLGFRAME | WS_SYSMENU | WS_MINIMIZEBOX,
		CW_USEDEFAULT, // x
		0, // y
		w, // width
		h, // height
		NULL, // id родительского окна
		NULL,
		hInstance,
		NULL
	);
}


HWND initChild(int w, int h, HINSTANCE hInstance, HWND parentWnd) {
	return CreateWindowEx(
		NULL,
		L"ChildWndClass",
		L"Result",
		WS_DLGFRAME,
		CW_USEDEFAULT, // x
		0, // y
		w, // width
		h, // height
		parentWnd, // id родительского окна
		NULL,
		hInstance,
		NULL
	);
}