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
arr db 108, 99, 105, 96

.code
main PROC

	mov eax, offset arr
	mov [eax], 107

	mov edx, offset arr
	mov eax, 4
	pushad
	call printf
	popad

	invoke ExitProcess, 0
main ENDP

fillArray PROC
	
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