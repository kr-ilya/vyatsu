#define UNICODE

#include <winsock2.h>
#include "helpers.h"
#include <iostream>
#include <windows.h>
#include <Setupapi.h>
#include <devguid.h>
#include "tchar.h"
#include <string>
#include <vector>
#include <unordered_map>
#include <iphlpapi.h>
#include <iomanip>

#include <sstream>

#pragma comment(lib, "setupapi.lib")
#pragma comment(lib, "iphlpapi.lib")

#define LocalFreeIf(Pointer) if(Pointer) { LocalFree(Pointer); Pointer = NULL; }

bool wEquals(const std::wstring& str, char const* c)
{
    std::string c_str(c);
    if (str.size() < c_str.size())
    {
        return false;
    }
    return std::equal(c_str.begin(), c_str.end(), str.begin());
}

std::unordered_map<std::wstring, std::wstring> getUSBinfo() {
    HDEVINFO deviceInfoSet;
    
    const GUID guidDev = { 0x53f5630dL, 0xb6bf, 0x11d0, {0x94, 0xf2, 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b} };
    deviceInfoSet = SetupDiGetClassDevs(&guidDev, NULL, NULL, DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);

    TCHAR buffer [4096];

    std::unordered_map<std::wstring, std::wstring> result;

    int memberIndex = 0;
    int i = 0;
    while (true) {
        SP_DEVICE_INTERFACE_DATA DeviceInterfaceData;
        ZeroMemory(&DeviceInterfaceData, sizeof(SP_DEVICE_INTERFACE_DATA));
        DeviceInterfaceData.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);

        SP_DEVINFO_DATA deviceInfoData;
        ZeroMemory(&deviceInfoData, sizeof(SP_DEVINFO_DATA));
        deviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);

        PSP_DEVICE_INTERFACE_DETAIL_DATA_W pDeviceInterfaceDetailData = NULL;

        if (SetupDiEnumDeviceInterfaces(deviceInfoSet, 0, &guidDev, memberIndex, &DeviceInterfaceData) == FALSE) {
            if (GetLastError() == ERROR_NO_MORE_ITEMS) {
                break;
            }
        }

        ULONG RequiredLength = 0;
        while ( !SetupDiGetDeviceInterfaceDetailW(deviceInfoSet, 
            &DeviceInterfaceData, pDeviceInterfaceDetailData, RequiredLength, &RequiredLength, &deviceInfoData ) )
        {
            if( GetLastError() == ERROR_INSUFFICIENT_BUFFER )
            {
                LocalFreeIf( pDeviceInterfaceDetailData );
                pDeviceInterfaceDetailData = (PSP_DEVICE_INTERFACE_DETAIL_DATA_W)LocalAlloc(LMEM_FIXED, (RequiredLength + 2) * sizeof(WCHAR));
                pDeviceInterfaceDetailData->cbSize = sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA_W);
            } 
            else 
            {
                SetupDiDestroyDeviceInfoList(deviceInfoSet);
                break;
            }
        }
        WCHAR Volume[256] = { 0 };
        WCHAR Letter[256] = { 0 };
        if( wcsstr(pDeviceInterfaceDetailData->DevicePath, L"usbstor") ) {

            // get serial number from tom id
            std::wstring wdevPath(pDeviceInterfaceDetailData->DevicePath);
            size_t revPos = wdevPath.find(L"&rev_")+5;
            size_t startSerialPos = wdevPath.find(L"#", revPos)+1;
            size_t endSerialPos = wdevPath.find(L"#", startSerialPos);
            size_t ampPos = wdevPath.find(L"&", revPos);
            if (ampPos != std::wstring::npos && ampPos < endSerialPos) {
                endSerialPos = ampPos;
            } 

            std::wstring serialNumber = wdevPath.substr(startSerialPos, endSerialPos - startSerialPos);
            
            // get volume letter
            DWORD len = wcslen( pDeviceInterfaceDetailData->DevicePath );
            pDeviceInterfaceDetailData->DevicePath[len]     = L'\\';
            pDeviceInterfaceDetailData->DevicePath[len + 1] = L'\0';

            if (GetVolumeNameForVolumeMountPointW(pDeviceInterfaceDetailData->DevicePath, Volume, 255)) {

                if (GetVolumePathNamesForVolumeNameW(Volume, Letter, 255, &RequiredLength))
                {
                    std::wstring let(Letter);
                    result[let] = serialNumber;        
                } else {
                    LocalFreeIf(pDeviceInterfaceDetailData);
                    SetupDiDestroyDeviceInfoList(deviceInfoSet);
                }
            } else{
                LocalFreeIf(pDeviceInterfaceDetailData);
                SetupDiDestroyDeviceInfoList(deviceInfoSet);
            }
        }

        ++memberIndex;
    }

    return result;
}

std::vector<std::wstring> getMACs() {
    ULONG outBufLen = 0;
    DWORD dwRetVal = 0;

    std::vector<std::wstring> result;

    // Запрашиваем размер буфера
    if (GetAdaptersAddresses(AF_UNSPEC, GAA_FLAG_INCLUDE_PREFIX, nullptr, nullptr, &outBufLen) != ERROR_BUFFER_OVERFLOW) {
        std::cerr << "Failed to get adapter addresses." << std::endl;
        return result;
    }

    // Выделяем буфер для хранения информации об адаптерах
    IP_ADAPTER_ADDRESSES* pAddresses = reinterpret_cast<IP_ADAPTER_ADDRESSES*>(new BYTE[outBufLen]);
    
    // Запрашиваем информацию об адаптерах
    if (GetAdaptersAddresses(AF_UNSPEC, GAA_FLAG_INCLUDE_PREFIX, nullptr, pAddresses, &outBufLen) != ERROR_SUCCESS) {
        std::cerr << "Failed to get adapter addresses." << std::endl;
        delete[] reinterpret_cast<BYTE*>(pAddresses);
        return result;
    }

    // Цикл по всем адаптерам
    for (IP_ADAPTER_ADDRESSES* adapter = pAddresses; adapter != nullptr; adapter = adapter->Next) {
        if (adapter->PhysicalAddressLength != 0) {
            if (adapter->IfType == IF_TYPE_ETHERNET_CSMACD || adapter->IfType == IF_TYPE_IEEE80211) {
                std::wstringstream wss;
                for (ULONG i = 0; i < adapter->PhysicalAddressLength; ++i) {
                    wss << std::hex << std::setw(2) << std::setfill(L'0') << static_cast<int>(adapter->PhysicalAddress[i]);
                    if (i < adapter->PhysicalAddressLength - 1) {
                        wss << L":";
                    }
                }

                result.push_back(wss.str());

            }
        }
    }

    delete[] reinterpret_cast<BYTE*>(pAddresses);

    return result;
}