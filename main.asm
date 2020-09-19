.386
.model flat,stdcall
option casemap :none

include C:\masm32\include\windows.inc	; STD_INPUT_HANDLE,
					; STD_OUTPUT_HANDLE

include <C:\masm32\include\kernel32.inc>
include <C:\masm32\include\user32.inc>
include <C:\masm32\include\masm32.inc>

includelib <C:\masm32\lib\kernel32.lib>
includelib <C:\masm32\lib\user32.lib>
includelib <C:\masm32\lib\masm32.lib>
;include <C:\masm32\macros\macros.asm>
include <macro.inc>


.stack 4096

.data

elementSize dword 4;
matrixSize dword 3
matrixSize4 dword ?

message1 byte "Lets fill first matrix", 0
message2 byte "Input number ", 0
msg1310 byte 13, 10	

hConsoleOutput dword ?
hConsoleInput dword ?
matrixAdress dword ?
whereToReadData dword 128 dup(?)
NumberOfCharsWritten dword ?
NumberOfCharsRead dword ?


.code
main proc
	
	invoke AllocConsole			; запрашиваем у Windows консоль

    invoke GetStdHandle, STD_INPUT_HANDLE	; получаем хэндл консоли для ввода
    mov hConsoleInput, EAX			; записываем хэндл в переменную

    invoke GetStdHandle, STD_OUTPUT_HANDLE	; получаем хэндл консоли для вывода
    mov hConsoleOutput, EAX			; записываем хэндл в переменную

	CreateQuadroMatrix matrixSize, matrixSize4
	mov matrixAdress, eax


	AskUserToInputData message1
	mov ecx, matrixSize
	firstFor:
		mov eax, matrixSize   ; число элементов в строке матрицы
		sub eax, ecx
		mov ebx, elementSize
		imul ebx   ; в eax относительный адрес нужного указателя
		mov edi, ebx
		push ecx
		mov ecx, matrixSize
		secondFor:           ; на данном моменте заняты регистры: ecx, edi - относительный адрес нужного указателя
			push ecx    ; потому что код ниже изменяет ecx
			mov eax, matrixSize
			sub eax, ecx
			mov ebx, elementSize
			imul ebx
			mov esi, eax  ; в esi индекс (умноженный на 4) элемента, в который записываем
			
			invoke WriteConsole, hConsoleOutput, ADDR message2, (SIZEOF message2) - 1, ADDR NumberOfCharsWritten, 0 ; предлагаем ввести число
			invoke ReadConsole, hConsoleInput, ADDR whereToReadData, SIZEOF whereToReadData, ADDR NumberOfCharsRead, 0
			
			lea ebx, [whereToReadData]        ;удаление символов
			add ebx, [NumberOfCharsRead]        ;перевода строки
			sub ebx, 2                        ;из буфера ввода
			mov [ebx], word ptr 0
			invoke  atodw, ADDR whereToReadData   ; преобразуем строку в число, результат в eax
			
			mov ebx, edi
			add ebx, matrixAdress  ; в  ebx адрес указателя на другой указатель
			mov ebx, [ebx]  ; в ebx укзатель (адрес массива - куска памяти)
			mov [ebx + esi], eax
			pop ecx   ; потому что код выше изменяет ecx
		loop secondFor
		invoke WriteConsoleA,			; переводим строку
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
		pop ecx
		dec ecx
	jnz firstFor		; потому что loop не может допрыгнуть

	invoke ExitProcess,0
main endp
end main
