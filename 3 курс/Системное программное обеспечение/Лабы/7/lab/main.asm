.386
.model flat

extrn ExitProcess: dword
extrn MessageBoxA: dword
extrn GetSystemTime: dword
extrn wsprintfA: dword


.data

date1 struct
    wYear dw 0
    wMonth dw 0
    wDayOfWeek dw 0
    wDay dw 0
    wHour dw 0
    wMinute dw 0
    wSecond dw 0
    wMilliseconds dw 0
date1 ends


dt_data date1<0>
AppTitle db "Program", 0

dateString db "Time: %u:%u:%u Date: %u.%u.%u", 0
msg db 200 dup (0)

.code

_start:
    push offset dt_data
    call GetSystemTime

    mov ax, dt_data.wYear
    push eax

    mov ax, dt_data.wMonth
    push eax

    mov ax, dt_data.wDay
    push eax

    mov ax, dt_data.wSecond
    push eax

    mov ax, dt_data.wMinute
    push eax

    mov ax, dt_data.wHour
    push eax

    push offset  dateString
    push offset msg

    call wsprintfA

    push 40h
    push offset AppTitle
    push offset msg
    push 0
    call MessageBoxA

    push 0
    call ExitProcess

end _start