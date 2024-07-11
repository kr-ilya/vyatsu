#pragma once
extern "C" __declspec(dllexport) HWND initMain(int w, int h, HINSTANCE hInstance);
extern "C" __declspec(dllexport) HWND initChild(int w, int h, HINSTANCE hInstance, HWND parentWnd);
