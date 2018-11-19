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
	push edx ; arrPtr
	push 10 ; len
	push -1 ; step
	push 110 ; init
	push 0 ; idx

	call fillArray 

	
	mov eax, 10
	pushad
	call printf
	popad

	push edx ; arrPtr
	push 10 ; end
	push 0 ; begin

	call bubbleSort

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

	mov ecx, 0 ; i
	dec ebx ; n - 1
	; j = esi
	loop1:
		inc ecx
		mov esi, ecx
		dec ecx

		jmp loop2

	loop1_f:
		inc ecx
		cmp ecx, ebx
		jl loop1
		jge finish

	loop2:	
		push eax
		push ebx
		mov eax, [edx + esi]
		mov ebx, [edx + ecx]

		cmp eax, ebx

		pop ebx
		pop eax

		jg swap
		jle loop2_f

	loop2_f:
		inc esi
		sub ebx, ecx
		cmp ebx, esi
		add ebx, ecx ; restore
		jl loop2
		jge loop1_f

	swap:
		push eax
		push ebx
		
		mov eax, [edx + esi] ; eax = arr[j]
		mov ebx, [edx + ecx] ; ebx = arr[i]
		mov [edx + esi], ebx ; arr[j] = ebx
		mov [edx + ecx], eax ; arr[i] = eax
				
		pop ebx
		pop eax
		jmp loop2_f
	
	finish:
		pop ebp
		ret 12

bubbleSort ENDP

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