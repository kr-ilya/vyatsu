119
42
mov al, 00010100b
������� ��������
out 2Bh, al
->CW0
mov al, 00110101b
K=21
out 2Bh, al
->CW1
mov al, 01000000b
CW2 (����� �-���)
out 2Bh, al
->CW2
mov al, 10010000b
CW4 (����� ����)
out 2Bh, al
->CW4
mov al, 11010000b
CW6 (����. �����)
out 2Bh, al
->CW6
in al, 2Bh
������ PSW
and al, 80h
�������� ��������� �������
jnz 0Ah

mov di, 100h

call Copy_ALLMOZU

nop 
�������� ���������
jmp 0Fh













































































































































































































push all

mov di, 110h

call Copy_ALLMOZU

mov si, 110h

mov di, 100h

mov cx, 8h

mov bx, 1h

call COMPARE

out 2Ah, al

pop all

iret





































































































































































































































































































































































































































































































































































































































































































































































