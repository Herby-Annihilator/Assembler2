AddNumbers macro first, second
	mov eax,first
	mov ebx,second
	add eax,ebx
endm

SubNumbers macro first,second
	mov eax,first
	mov ebx,second
	sub eax,ebx
endm

AskUserToInputData macro message
	invoke WriteConsoleA,			; ��������� ������ � �������
                      hConsoleOutput,	; ����� ������
                        ADDR msg1310,	; ����� ������ msg1310
                      SIZEOF msg1310,	; ������ ������ msg1310
           ADDR NumberOfCharsWritten,	; ���� ������� ������� ����� ��������
                                   0	; lpReserved ��������, ��� ����

	invoke WriteConsoleA,			; ����� message
                      hConsoleOutput,
                           ADDR message,
                         SIZEOF message,
           ADDR NumberOfCharsWritten,
                                   0

	invoke WriteConsoleA,			; ��������� ������
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
endm

ReadData macro variableWhereToRead
	
endm

CreateQuadroMatrix macro memorySize, memorySize4
	invoke GetProcessHeap  ; �������� ����� ���� ������ ��������
	mov edi,eax
	mov eax, memorySize
	mov ebx, 4
	imul ebx
	mov memorySize4,eax
	push ecx
	invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4
	pop ecx  ; ������ ��� ����� ���� �������� ��� �������

	mov ebx,eax   ; � ebx ����� ������ ������� ����������
	mov ecx,memorySize 
	cycle:
		invoke GetProcessHeap
		mov edi,eax
		push ecx
		invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4  ; eax �������� ����� ������� ����� ������
		pop ecx  ; ������ ��� ����� ���� �������� ��� �������
		mov edi,eax                                   ; edi �������� ����� ������� ����� ������
		mov eax,memorySize
		sub eax,ecx  ; eax �������� ��������, ������� ����� �������� �� 4
		mov edx,4
		imul edx       ; ��������� � eax
		mov [ebx + eax],edi
	loop cycle
	mov eax,ebx			
endm