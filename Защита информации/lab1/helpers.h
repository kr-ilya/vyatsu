#pragma once
#include <vector>
#include <sstream>
#include <unordered_map>

std::unordered_map<std::wstring, std::wstring> getUSBinfo();

std::vector<std::wstring> getMACs();