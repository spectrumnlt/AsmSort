.386
.model flat,stdcall
.stack 4096
STD_OUTPUT_HANDLE EQU -11
; STD_INPUT_HANDLE EQU -10
GetStdHandle PROTO, nStdHandle: DWORD 
WriteConsoleA PROTO, handle: DWORD, lpBuffer:PTR BYTE, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR DWORD, lpReserved:DWORD  
; ReadConsole PROTO, handle:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToRead:DWORD, lpNumberOfCharsRead:PTR DWORD, lpInputControl:PTR DWORD	 
ExitProcess PROTO, dwExitCode:DWORD	

.data
consoleOutHandle dd ? 
consoleInHandle dd ?
bytesWritten dd ?
arr db 100 dup(?)

.code
main PROC
	mov edx, offset arr
	push edx 
	push 5 ; len
	push 1 ; step
	push 97 ; init
	push 1 ; idx

	call fillArray 

	mov eax, 10
	pushad
	call printf
	popad

	invoke ExitProcess, 0
main ENDP

fillArray PROC
	; in stack - index, initial, step, len, arr 

	push ebp        ; save old base pointer
	mov ebp, esp     ; use the current stack pointer as new base pointer

	mov ecx, [ebp + 8] ; index
	mov ebx, [ebp + 12] ; initial
	mov eax, [ebp + 16] ; step
	mov esi, [ebp + 20] ; len
	mov edx, [ebp + 24] ; arr ptr
	
	body:
		mov [edx + ecx], ebx
		inc ecx
		add ebx, eax
		cmp ecx, esi
		jl body

	pop ebp        ; restore old base pointer
	ret 20       ; return, popping the extra 4 bytes of the arguments in the process
		
fillArray ENDP

;scanf PROC	
;	invoke	GetStdHandle, STD_INPUT_HANDLE
;	mov consoleInHandle, eax
;	pushad
;	invoke
;	popad
;scanf ENDP

printf PROC
	; edx - string
	; eax - length of message
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleOutHandle, eax 
	pushad   
	invoke WriteConsoleA, consoleOutHandle, edx, eax, offset bytesWritten, 0
	popad
	ret
printf ENDP	

END main