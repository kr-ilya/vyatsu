119
42
mov al, 00001010b
������� ����� � ����
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

mov al, 11110000b
CW7 (����������� ������)
out 2Bh, al
->CW7
nop 
�������� ���������
jmp 0Fh













































































































































































































push all

in al, 2Bh

and al, 40h

jz 7Fh

call beep

mov al, 11000010b
CW6
out 2Bh, al
->CW6
jmp 81h

in al, 2Ah

out 2Ah, al

pop all

iret



































































































































































































































































































































































































































































































































































































































































































































































