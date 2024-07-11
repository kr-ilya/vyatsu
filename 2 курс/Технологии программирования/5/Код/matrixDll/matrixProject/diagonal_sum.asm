.MODEL FLAT, C
public _get_sum
.code 
	_get_sum PROC near
		push ebp
		mov ebp, esp

		mov esi, dword ptr [ebp+8] ; **martix
		mov ecx, dword ptr [ebp+12] ; n

		; i = 0 (esi)
		; j = 0 (edx)

		mov edx, [esi] ; matrix[i]
		fld qword ptr [edx] ; st(0) <- matrix[i][j]

		mov eax, 0 ; offset (matrix[i][j + offset])

		sub ecx, 1 ;  n-1
		cmp ecx, 0 ; ecx == 0?
		JE the_end

	L:
		add esi, 4 ; i + 1
		add eax, 8 ; offset + 1

		mov edx, [esi] ; matrix[i]
		fld qword ptr [edx+eax] ; st(0) <- matrix[i][j+offset]

		FADDP st(1), st(0) ; st(0) = st(1) + st(0)

		loop L ; while, ecx -= 1

	the_end:
		pop ebp
		RET
	_get_sum ENDP
END