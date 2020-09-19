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
	
	invoke AllocConsole			; ����������� � Windows �������

    invoke GetStdHandle, STD_INPUT_HANDLE	; �������� ����� ������� ��� �����
    mov hConsoleInput, EAX			; ���������� ����� � ����������

    invoke GetStdHandle, STD_OUTPUT_HANDLE	; �������� ����� ������� ��� ������
    mov hConsoleOutput, EAX			; ���������� ����� � ����������

	CreateQuadroMatrix matrixSize, matrixSize4
	mov matrixAdress, eax


	AskUserToInputData message1
	mov ecx, matrixSize
	firstFor:
		mov eax, matrixSize   ; ����� ��������� � ������ �������
		sub eax, ecx
		mov ebx, elementSize
		imul ebx   ; � eax ������������� ����� ������� ���������
		mov edi, ebx
		push ecx
		mov ecx, matrixSize
		secondFor:           ; �� ������ ������� ������ ��������: ecx, edi - ������������� ����� ������� ���������
			push ecx    ; ������ ��� ��� ���� �������� ecx
			mov eax, matrixSize
			sub eax, ecx
			mov ebx, elementSize
			imul ebx
			mov esi, eax  ; � esi ������ (���������� �� 4) ��������, � ������� ����������
			
			invoke WriteConsole, hConsoleOutput, ADDR message2, (SIZEOF message2) - 1, ADDR NumberOfCharsWritten, 0 ; ���������� ������ �����
			invoke ReadConsole, hConsoleInput, ADDR whereToReadData, SIZEOF whereToReadData, ADDR NumberOfCharsRead, 0
			
			lea ebx, [whereToReadData]        ;�������� ��������
			add ebx, [NumberOfCharsRead]        ;�������� ������
			sub ebx, 2                        ;�� ������ �����
			mov [ebx], word ptr 0
			invoke  atodw, ADDR whereToReadData   ; ����������� ������ � �����, ��������� � eax
			
			mov ebx, edi
			add ebx, matrixAdress  ; �  ebx ����� ��������� �� ������ ���������
			mov ebx, [ebx]  ; � ebx �������� (����� ������� - ����� ������)
			mov [ebx + esi], eax
			pop ecx   ; ������ ��� ��� ���� �������� ecx
		loop secondFor
		invoke WriteConsoleA,			; ��������� ������
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
		pop ecx
		dec ecx
	jnz firstFor		; ������ ��� loop �� ����� ����������

	invoke ExitProcess,0
main endp
end main
