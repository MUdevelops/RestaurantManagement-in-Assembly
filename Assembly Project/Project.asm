                                  ; =====================================================
;  RESTAURANT MANAGEMENT SYSTEM  -  8086 Assembly
;  Written for emu8086 (MASM/TASM style, .model small)
;
;  Features:
;   - Displays a menu with 5 items and prices
;   - Lets the cashier/customer pick item + quantity
;     repeatedly (order as many items as needed)
;   - Keeps a running total
;   - On checkout (option 0), prints an itemized bill
;     showing each ordered item, quantity, subtotal,
;     and the grand total
; =====================================================

.model small
.stack 100h

.data
    ; ---------- Menu text ----------
    welcome_msg db 0dh,0ah,"     WELCOME TO THE ASSEMBLY RESTAURANT",0dh,0ah,'$'
    menu_title  db 0dh,0ah,"===================================",0dh,0ah
                db "            RESTAURANT MENU",0dh,0ah
                db "===================================",0dh,0ah,'$'
    item1_txt   db "1. Burger        - Rs. 150",0dh,0ah,'$'
    item2_txt   db "2. Pizza         - Rs. 300",0dh,0ah,'$'
    item3_txt   db "3. Pasta         - Rs. 250",0dh,0ah,'$'
    item4_txt   db "4. Cold Drink    - Rs. 50",0dh,0ah,'$'
    item5_txt   db "5. Dessert       - Rs. 100",0dh,0ah,'$'
    item0_txt   db "0. Checkout & Print Bill",0dh,0ah
                db "-------------------------------------",0dh,0ah,'$'

    prompt_choice db 0dh,0ah,"Enter item number (0 to checkout): $"
    prompt_qty    db "Enter quantity: $"
    msg_added     db 0dh,0ah,"  -> Item added to your order.",0dh,0ah,'$'
    msg_invalid   db 0dh,0ah,"  !! Invalid choice, please try again.",0dh,0ah,'$'

    ; ---------- Bill text ----------
    bill_title    db 0dh,0ah,"===================================",0dh,0ah
                  db "             YOUR BILL",0dh,0ah
                  db "===================================",0dh,0ah,'$'
    bill_sep      db "-------------------------------------",0dh,0ah,'$'
    bill_total_msg db 0dh,0ah,"TOTAL AMOUNT DUE : Rs. $"
    thank_you      db 0dh,0ah,0dh,0ah,"   Thank you for dining with us!",0dh,0ah,'$'

    sep_x   db " x $"
    sep_eq  db "  = Rs. $"
    crlf    db 0dh,0ah,'$'

    ; ---------- Item names (dollar-terminated, used on the bill) ----------
    name1 db "Burger$"
    name2 db "Pizza$"
    name3 db "Pasta$"
    name4 db "Cold Drink$"
    name5 db "Dessert$"

    name_table dw offset name1, offset name2, offset name3, offset name4, offset name5

    ; ---------- Prices / quantities (parallel arrays, index 0..4 = item 1..5) ----------
    prices dw 150, 300, 250, 50, 100
    qty    dw 0, 0, 0, 0, 0

    total  dw 0

.code
main proc
    mov ax, @data
    mov ds, ax

    ; clear screen / reset video mode
    mov ax, 3
    int 10h

    lea dx, welcome_msg
    call print_str

main_loop:
    call print_menu
    call read_num        ; bx = item choice
    mov si, bx            ; keep choice safe in si

    cmp si, 0
    je checkout

    cmp si, 5
    ja invalid_choice
    cmp si, 1
    jb invalid_choice

    ; ---- valid item chosen: ask quantity ----
    lea dx, prompt_qty
    call print_str
    call read_num         ; bx = quantity entered

    ; di = word-index of this item (si-1)*2
    mov di, si
    dec di
    shl di, 1

    add qty[di], bx       ; accumulate ordered quantity

    mov ax, prices[di]
    mul bx                ; dx:ax = price * quantity
    add total, ax         ; add to running total

    lea dx, msg_added
    call print_str
    jmp main_loop

invalid_choice:
    lea dx, msg_invalid
    call print_str
    jmp main_loop

checkout:
    call print_bill
    lea dx, thank_you
    call print_str

    mov ax, 4c00h
    int 21h
main endp

; -----------------------------------------------------
; print_menu : displays the menu and the choice prompt
; -----------------------------------------------------
print_menu proc
    lea dx, menu_title
    call print_str
    lea dx, item1_txt
    call print_str
    lea dx, item2_txt
    call print_str
    lea dx, item3_txt
    call print_str
    lea dx, item4_txt
    call print_str
    lea dx, item5_txt
    call print_str
    lea dx, item0_txt
    call print_str
    lea dx, prompt_choice
    call print_str
    ret
print_menu endp

; -----------------------------------------------------
; print_bill : walks the qty[] array and prints every
;              ordered item, its quantity, subtotal,
;              then the grand total
; -----------------------------------------------------
print_bill proc
    lea dx, bill_title
    call print_str

    mov si, 0             ; si = item index 0..4

pb_loop:
    cmp si, 5
    jae pb_done

    mov di, si
    shl di, 1             ; di = word offset

    mov bx, qty[di]
    cmp bx, 0
    je pb_skip

    ; print item name
    mov dx, name_table[di]
    call print_str

    lea dx, sep_x
    call print_str

    mov ax, bx            ; quantity
    call print_num

    lea dx, sep_eq
    call print_str

    mov ax, prices[di]
    mul bx                ; ax = price * qty (subtotal)
    call print_num

    call print_newline

pb_skip:
    inc si
    jmp pb_loop

pb_done:
    lea dx, bill_sep
    call print_str
    lea dx, bill_total_msg
    call print_str
    mov ax, total
    call print_num
    call print_newline
    ret
print_bill endp

; -----------------------------------------------------
; read_num : reads digits from keyboard until ENTER,
;            returns the value in bx (simple decimal
;            input, no error checking on non-digits)
; -----------------------------------------------------
read_num proc
    push ax
    push cx
    xor bx, bx

rn_loop:
    mov ah, 01h
    int 21h               ; al = key pressed (echoed to screen)
    cmp al, 0dh            ; Enter?
    je rn_done

    sub al, '0'
    cbw
    push ax
    mov ax, bx
    mov cx, 10
    mul cx                 ; ax = bx * 10
    mov bx, ax
    pop ax
    add bx, ax
    jmp rn_loop

rn_done:
    pop cx
    pop ax
    ret
read_num endp

; -----------------------------------------------------
; print_num : prints the unsigned number in ax as
;             decimal digits
; -----------------------------------------------------
print_num proc
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    mov cx, 0             ; digit counter

    cmp ax, 0
    jne pn_split
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp pn_end

pn_split:
    cmp ax, 0
    je pn_print
    xor dx, dx
    div bx                ; ax = ax/10, dx = remainder
    push dx
    inc cx
    jmp pn_split

pn_print:
    cmp cx, 0
    je pn_end
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    dec cx
    jmp pn_print

pn_end:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

; -----------------------------------------------------
; print_str : prints a $-terminated string pointed to
;             by dx
; -----------------------------------------------------
print_str proc
    mov ah, 09h
    int 21h
    ret
print_str endp

; -----------------------------------------------------
; print_newline : prints CR LF
; -----------------------------------------------------
print_newline proc
    push ax
    push dx
    lea dx, crlf
    mov ah, 09h
    int 21h
    pop dx
    pop ax
    ret
print_newline endp

end main