; Realization simple console on the assembly languale (FASM) 
;
; Functions
; 1) Help - output on the console help data
; 2) Clear - clear console 
; 3) Processing unknown functions


data  SEGMENT 
    
    var1 db 'help'
    len1 equ $ - var1
    
    var2 db 'clear'
    len2 equ $ - var2
    
    unknown db 'Unknown command$', 0ah, 0dh, 3eh, 00h
     
    text db 'Commands:', 0ah, 0dh, 31h, 29h, 00h, 'help', 0ah, 0dh, 32h, 29h, 00h, 'clear' 
    lenText equ $ - text
    
    kash db 1ah, 'Kashaev Team', 1bh, 24h, 0dh
ENDS
bss   SEGMENT
    input db ?
ENDS
stack SEGMENT
   db 20 dup(99)

ENDS

code SEGMENT 
    start: 
        MOV ax, data
        MOV ds, ax
        MOV ax, bss
        MOV es, ax
        MOV cl, 00h
        MOV ah, 09h
        MOV dx, offset kash
        INT 21h
        MOV ah, 02h 
        MOV dl, 0dh
        INT 21h
        MOV dl, 0ah
        INT 21h
        MOV dl, 3eh
        INT 21h 
        MOV dl, 20h
        INT 21h 
         
    next:
        MOV  ah, 01h
        INT  21h
        CMP  al, 0dh    
        JE   nline
        CMP  al, 08h  
        JE   erase
        INC  cl 
        MOV  es:[bx], al
        MOV  es:[bx + 1], 24h
        INC  bx
        JNE  next 
        
    erase:
        CMP  bx, 00h
        JE   empty
        DEC  bx
        MOV  es:[bx], 24h 
        MOV  es:[bx + 1], 00h
        
    empty:
        CMP  cl, 00h
        JE   eraseNB
        DEC  cl
        MOV  ah, 02h
        MOV  dl, 00h
        INT  21h   
        MOV  ah, 02h    
        MOV  dl, 08h
        INT  21h
        MOV  al, 00h
        JMP  next
        
    eraseNB:
        MOV  ah, 02h
        MOV  dl, 00h
        INT  21h 
        JMP  next
        
    nline:  
        MOV  bx, 00h
        CMP  cl, 05h
        PUSH cx
        JE   equals2 
        JA   error
        CMP  cl, 04h
        JE   equals
        JB   error
        
    equals:
        MOV  dh, ds:[bx]  
        MOV  dl, es:[bx]
        CMP  dh, dl
        JNE  helpMenu
        INC  bl
        LOOP equals
        
    helpMenu:    
        MOV  cx, 0104h
        CMP  bl, cl
        JE   outtext
        MOV  bx, 00h
        MOV  cl, 00h    
        MOV  ah, 02h
        MOV  dl, 0ah
        INT  21h
        MOV  dl, 0dh
        INT  21h
        MOV  dl, 3eh
        INT  21h 
        MOV  dl, 20h
        INT  21h
        MOV  bl, 0h
        JMP  next 
            
    equals2:
        MOV  dh, ds:[bx + 4]  
        MOV  dl, es:[bx]
        CMP  dh, dl
        JNE  cls   
        INC  bl
        LOOP equals2     
        
    cls:  
        POP  CX 
        CMP  bl, cl
        JE   clear 
        MOV  bx, 00h
        MOV  cl, 00h
        MOV  ah, 02h
        MOV  dl, 0ah
        INT  21h
        MOV  dl, 0dh
        INT  21h
        MOV  dl, 3eh
        INT  21h 
        MOV  dl, 20h
        INT  21h
        MOV  bl, 0h 
        JMP  next

    clear:
        MOV  ax, 0600h
        MOV  bh, 07h
        MOV  cx, 0000h
        MOV  dx, 184Fh
        INT  10h 
        MOV  ah,2
        MOV  bh,0
        MOV  dx,00
        INT  10h  
        JMP  cls          
        
    outtext:  
        MOV  cx, lentext 
        MOV  bl, offset text
        MOV  ah, 02h
        MOV  dl, 0ah
        INT  21h
             
    nextSym:
        MOV  dl, ds:[bx]           
        MOV  ah, 02h
        INT  21h
        INC  bx
        LOOP nextSym 
        JMP  helpMenu 
        
    error:
        MOV  bx, 00h
        MOV  cl, 00h    
        MOV  ah, 02h
        MOV  dl, 0ah
        INT  21h
        MOV  dl, 0dh
        INT  21h
        MOV  bl, 0h        
        MOV  ah,09h
        MOV  dx, offset unknown
        INT  21h 
        MOV  ah, 02h
        MOV  dl, 0ah
        INT  21h
        MOV  dl, 0dh
        INT  21h
        MOV  dl, 3eh
        INT  21h 
        MOV  dl, 20h
        INT  21h   
        JMP  next  
        
ENDS