#include <iostream>
#include <unordered_map>
#include "helpers.h"
#include <fstream>
#include <sstream>
#include <vector>
#include "picosha2.h"
#include <windows.h>
#include <clocale>

const char* filename = "secret.dat";

bool getKeyFromFile(std::wstring &content) {
    std::wifstream file(filename, std::ios::in);
    if(!file.is_open()){
        return false;
    }

    std::wstringstream wss;
    wss << file.rdbuf();
    content = wss.str();
    return true;
}

bool createKey() {
    std::unordered_map<std::wstring, std::wstring> usbData = getUSBinfo();
    if (usbData.empty()){
        return false;
    }

    std::vector<std::wstring> macs = getMACs();
    if (macs.empty()) {
        return false;
    }

    std::wstring selectedUsb;
    if (usbData.size() > 1) {
        std::cout << "Select the USB drive to which the program will be associated [1-" << usbData.size() << "]:" << std::endl;

        int i = 0;
        std::vector<std::wstring> letters;
        for (const auto& [letter, _]: usbData) {
            std::wcout << ++i << ") " << letter << std::endl;
            letters.push_back(letter);
        }
        int n;
        do {
            while (!(std::cin >> n)) {
                std::cin.clear();
                std::cin.ignore(LLONG_MAX, '\n'); 
                std::cout << "incorrect number." << std::endl;
            }

            if (n <= 0 && n > letters.size()) {
                std::cout << "incorrect device number." << std::endl;
            }
        } while (n <= 0 || n > letters.size());

        selectedUsb = letters[n-1];
    } else if (usbData.size() == 1) {
        for (const auto& [letter, _]: usbData) {
            selectedUsb = letter;
        }
        std::wcout << "Confirm the binding of the disk " << selectedUsb << " to the program [Y/n]" << std::endl;
        std::string confirm;
        std::getline(std::cin, confirm);
        if (confirm == "N" || confirm == "n"){ 
            return false;
        }
    } else {
        std::cout << "Connect the USB flash drive." << std::endl;
        return false;
    }

    std::string hash_key;
    picosha2::hash256_hex_string(macs[0] + L"." + usbData[selectedUsb], hash_key);

    std::ofstream keyFile(filename, std::ios::out);
    if(!keyFile.is_open()){
        std::cout << "failed create keyFile" << std::endl;
        return false;
    }

    keyFile << hash_key;
    if (!SetFileAttributesA(filename, FILE_ATTRIBUTE_SYSTEM | FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_READONLY)) {
        std::cerr << "Error setting file attributes!" << std::endl;
        return false;
    }

    std::wcout << "Disk " << selectedUsb << " is associated with the program" << std::endl;
    
    return true;
}


bool checkKey() {
    std::wstring key;
    bool ok = getKeyFromFile(key);
    if (!ok) {
        if(!createKey()) {
            std::cout << "failed create key" << std::endl;
            return false;
        }
        return true;
    }

    std::unordered_map<std::wstring, std::wstring> usbData = getUSBinfo();
    if (usbData.empty()){
        return false;
    }

    std::vector<std::wstring> macs = getMACs();
    if (macs.empty()) {
        return false;
    }

    for (const auto& [_, serialId]: usbData) {
        for (auto mac: macs) {
            std::string hash_key;
            picosha2::hash256_hex_string(mac + L"." + serialId, hash_key);

            std::wstring wkey(hash_key.begin(), hash_key.end());

            if (key == wkey)
                return true;
        }
    }
    return false;
}

int main() {
    std::setlocale(LC_CTYPE, "");
    std::cout << "Hello" << std::endl;

    if (!checkKey()) {
        std::cout << "Access is denied" <<std::endl;
    } else {
        std::cout << "The verification was successful" <<std::endl;
    }
    
    return 0;
}
