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
	invoke WriteConsoleA,			; переводим строку в консоли
                      hConsoleOutput,	; хэндл вывода
                        ADDR msg1310,	; адрес строки msg1310
                      SIZEOF msg1310,	; размер строки msg1310
           ADDR NumberOfCharsWritten,	; сюда функци€ запишет число символов
                                   0	; lpReserved передаем, как ноль

	invoke WriteConsoleA,			; пишем message
                      hConsoleOutput,
                           ADDR message,
                         SIZEOF message,
           ADDR NumberOfCharsWritten,
                                   0

	invoke WriteConsoleA,			; переводим строку
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
endm

ReadData macro variableWhereToRead
	
endm

CreateQuadroMatrix macro memorySize, memorySize4
	invoke GetProcessHeap  ; получаем адрес кучи нашего процесса
	mov edi,eax
	mov eax, memorySize
	mov ebx, 4
	imul ebx
	mov memorySize4,eax
	push ecx
	invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4
	pop ecx  ; потому что хрень выше обнул€ет мне регистр

	mov ebx,eax   ; в ebx адрес начала массива указателей
	mov ecx,memorySize 
	cycle:
		invoke GetProcessHeap
		mov edi,eax
		push ecx
		invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4  ; eax содержит адрес нововго куска пам€ти
		pop ecx  ; потому что хрень выше обнул€ет мне регистр
		mov edi,eax                                   ; edi содержит адрес нововго куска пам€ти
		mov eax,memorySize
		sub eax,ecx  ; eax содержит смещение, которое нужно умножить на 4
		mov edx,4
		imul edx       ; результат в eax
		mov [ebx + eax],edi
	loop cycle
	mov eax,ebx			
endm