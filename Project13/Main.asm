.386
.model flat, stdcall
.stack 4096
STD_OUTPUT_HANDLE EQU -11
STD_INPUT_HANDLE EQU -10
GetStdHandle PROTO, nStdHandle: DWORD 
WriteConsoleA PROTO, handle: DWORD, lpBuffer:PTR BYTE, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR DWORD, lpReserved:DWORD  
ReadConsoleA PROTO, handle:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToRead:DWORD, lpNumberOfCharsRead:PTR DWORD, lpInputControl:PTR DWORD	 
ExitProcess PROTO, dwExitCode:DWORD	

.data
consoleOutHandle dd ? 
consoleInHandle dd ?
bytesWritten dd ?
bytesRead dd ?
arr db 100 dup(?)

.code
main PROC
	mov ecx, offset arr
	mov edx, 10
	pushad
	call scanf
	popad

	mov edx, offset arr
	mov eax, 10
	pushad
	call printf	
	popad

	invoke ExitProcess, 0
main ENDP

fillArray PROC
	; in stack - index, initibh, step, len, arr 

	push ebp        ; save old base pointer
	mov ebp, esp     ; use the current stack pointer as new base pointer

	mov ecx, [ebp + 8] ; index
	mov ebx, [ebp + 12] ; initibh
	mov eax, [ebp + 16] ; step
	mov esi, [ebp + 20] ; len
	mov edx, [ebp + 24] ; arr ptr
	
	body:
		mov [edx + ecx], ebx ; arr[i] = vbh
		inc ecx ; ++i
		add ebx, eax ; vbh += step
		cmp ecx, esi
		jl body ; if i < n

	pop ebp        ; restore old base pointer
	ret 20       ; return, popping the extra 4 bytes of the arguments in the process
		
fillArray ENDP

bubbleSort PROC
	; in stack - beginIdx, endIdx, arrPtr
	
	push ebp
	mov ebp, esp
	
	; eax - start index
	; ebx - end index
	; edx - array address

	mov eax, [ebp + 8] ; start
	mov ebx, [ebp + 12] ; end
	mov edx, [ebp + 16] ; arr

	dec ebx ; n - 1
	; j = ecx
	; i = eax
	loop1:
		mov ecx, 0 ; j = 0

		jmp loop2 ; start loop2

	loop1_f:
		inc eax ; ++i
		cmp eax, ebx 
		jl loop1 ; if i < n - 1
		jge finish

	loop2:	
		push eax
		push ebx

		mov ah, [edx + ecx] ; ah = arr[j]
		inc ecx
		mov bh, [edx + ecx] ; bh = arr[j + 1]
		dec ecx

		cmp ah, bh

		pop ebx
		pop eax

		jg swap ; if arr[j] > arr[j + 1]
		jle loop2_f ; else 

	loop2_f:
		inc ecx ; ++j
		cmp ecx, ebx ; compare i and j
		
		jl loop2 ; if j < n - i - 1
		jge loop1_f ; finish the loop

	swap:		
		push eax
		push ebx

		mov ah, [edx + ecx] ; ah = arr[j]
		inc ecx
		mov bh, [edx + ecx] ; bh = arr[j + 1]
		dec ecx
		mov [edx + ecx], bh ; arr[j] = bh
		inc ecx
		mov [edx + ecx], ah ; arr[j + 1] = ah
		dec ecx

		pop ebx
		pop eax
		
		jmp loop2_f
	
	finish:
		pop ebp
		ret 12

bubbleSort ENDP

scanf PROC	
	; ecx - array address
	; edx - length to read

	invoke GetStdHandle, STD_INPUT_HANDLE
	mov consoleInHandle, eax
	pushad
	invoke ReadConsoleA, consoleInHandle, ecx, edx, offset bytesRead, 0
	popad
	ret
scanf ENDP

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