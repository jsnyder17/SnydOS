org 0x7c00
bits 16
start: jmp boot

boot:
    cli ; no interrupts until the stack is setup 

    ; setup segment registers to point to segment
    xor ax,ax
    mov ds,ax
    mov es,ax

    ; setup the stack 
    mov ax,0x0000
    mov ss,ax
    mov sp,0xFFFF
    sti     ; enable interrupts 

    ; print messages
    call PrintInit

    hlt ; halt system 

PrintInit:
    mov ah,0x0e
    mov bx, statusMessage    ; reference to the welcomeMessage pointer 
    
    ; loop to print each character of the message 
    loop:
        mov al,[bx] ; copy the data from the pointer in bx to the al register
        cmp al,0    ; compare al with the last string char 
        je exit     ; end the loop is cmp is true    
        int 0x10    ; BIOS interrupt (print char to screen)
        inc bx      ; increment the value in bx
        jmp loop   ; loop 
    exit:

    mov bx,welcomeMessage

    welcomeLoop:
        mov al,[bx] ; copy the data from the pointer in bx to the al register
        cmp al,0    ; compare al with the last string char 
        je welcomeExit     ; end the loop is cmp is true    
        int 0x10    ; BIOS interrupt (print char to screen)
        inc bx      ; increment the value in bx
        jmp welcomeLoop  ; loop 
    welcomeExit:

    mov al,0

    statusMessage:
        db '[*] System initialized',13,10

    welcomeMessage:
        db '*=== Welcome to Snyder OS! ===*',13,10
    

times 510 - ($-$$) db 0 ; 512 bytes
dw 0xAA55 ; Boot signature 