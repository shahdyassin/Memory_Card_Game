.model small
.stack 100h

.data
    cards db 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D' 
    revealed db 8 dup(0)                            
    matches db 0                                    
    input1 db 0                                     
    input2 db 0                                     
    newline db 13, 10, '$'                          
    msg_board db 'Board: ', '$'                     
    msg_input db 'Enter two positions (1-8): ', '$' 
    msg_win db 'You won! Game over.', '$'           

.code
main proc
    mov ax, @data
    mov ds, ax

start_game:
    call display_cards          
    call get_input              
    call check_match            
    cmp matches, 4              
    je game_over
    jmp start_game              

game_over:
    mov ah, 09h                 
    lea dx, newline
    int 21h
    lea dx, msg_win
    mov ah, 09h
    int 21h
    mov ah, 4Ch                 
    int 21h

display_cards proc
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, msg_board
    int 21h

    mov cx, 8                   
    lea si, cards               
    lea di, revealed            
display_loop:
    mov al, [di]
    cmp al, 1                   
    je show_card
    mov dl, '*'                 
    jmp display_next
show_card:
    mov dl, [si]                
display_next:
    mov ah, 02h
    int 21h
    mov ah, 02h
    mov dl, ' '
    int 21h
    inc si
    inc di
    loop display_loop
    ret
display_cards endp

get_input proc
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, msg_input
    int 21h
    call get_digit              
    mov input1, al
    call get_digit              
    mov input2, al
    ret
get_input endp

check_match proc
    mov al, input1              
    dec al                      
    mov ah, 0                   
    lea si, cards               
    add si, ax                  

    mov al, input2              
    dec al                      
    mov ah, 0                   
    lea di, cards
    add di, ax                  

    mov al, [si]                
    mov bl, [di]                
    cmp al, bl                  
    jne no_match                

   
    lea si, revealed
    mov al, input1
    dec al
    mov ah, 0
    add si, ax
    mov byte ptr [si], 1

    lea di, revealed
    mov al, input2
    dec al
    mov ah, 0
    add di, ax
    mov byte ptr [di], 1

    inc matches                 

no_match:
    ret
check_match endp

get_digit proc
    mov ah, 01h     
    int 21h
    sub al, '0'     
    ret
get_digit endp

end main
