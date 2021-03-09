%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    Vector: resd 20

section .text
global main

transform:

    mov ecx,[ebp+8]
    mov ecx,[ecx] 
    
    xor eax,eax     ;va retine numarul convertit
    xor edx,edx   
    input:
        
        mov dl,[ecx]    ;dl contine fiecare caracter     
        cmp dl, '-'     ;verific daca numarul este negativ
        je negativ      
        cmp dl,0        ;verific daca am terminat de convertit
        je return       ;ies din functie
        imul eax, 10    ;
        sub edx, 48     ;
        lea eax,[eax + edx ]    ;
        inc ecx         ;trec la caracterul urmator
        jmp input       ;apelez functia 
    negativ:
        mov bl,-1       ;retin daca numarul este negativ
        inc ecx         ;trec la caracterul urmator
        jmp input       ;apelez functia
    schimba:
        imul eax,-1     ;schimb semnul numarului
        jmp return1     ;ies din functie

    return:
        cmp bl,-1       ;verific daca numarul convertit a fost initial negativ
        je schimba   
        jmp return1     ;ies din functie
    return1:
        leave
        ret
        
  citeste:     
     
    push ebp
    lea ebp,[esp]
    xor ebx, ebx
    mov ebx,[ebp+8]     ;prima valoare din root 
    mov ecx,[ebx]
    mov ecx,[ecx]
    
    cmp ecx,'-'         ;verific daca semnul este -
    je minus            ;merg la functia specifica lui -
    cmp ecx,'+'         ;verific daca semnul este +
    je plus             ;merg la functia specifica lui -
    cmp ecx,'*'         ;verific daca semnul este *
    je inmultire        ;merg la functia specifica lui *
    cmp ecx,'/'         ;verific daca semnul este /
    je impartire        ;merg la functia specifica lui /
   
    jmp transform       ;s-a gasit numar ->apelez functia 
                        ;de transformare numerelor   
    jmp return          ;parasesc functia
    
minus:
    mov ebx,[ebp+8]     ;varful stivei
    mov ebx,[ebx+4]     ;preiau copilul stang
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    mov ecx,eax         ;rezultatul obtinut il pun in ecx
    pop edx             ;eliberez stiva
    
    mov ebx,[ebp+8]         
    mov ebx,[ebx+8]     ;preiau copilul drept
    push ecx            ;adaug pe stiva
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    pop edx             ;eliberez stiva
    pop ecx             ;eliberez stiva

    sub ecx,eax         ;aplic operatia de scadere
    mov eax,ecx         ;mut rezultatul in eax
    jmp print           ;ies din functie
    
    

plus:
    mov ebx,[ebp+8]
    mov ebx,[ebx+4]     ;preiau copilul stang
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    mov ecx,eax         ;rezultatul obtinut in pun in ecx
    pop edx             ;eliberez stiva
    
    mov ebx,[ebp+8]
    mov ebx,[ebx+8]     ;preiau copilul drept
    push ecx            ;adaug pe stiva
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    pop edx             ;eliberez stiva
    pop ecx             ;eliberez stiva

    add ecx,eax         ;aplic operatia de adunare
    mov eax,ecx         ;mut rezultatul in eax
    jmp print           ;parasesc functia
    
inmultire:
    mov ebx,[ebp+8]
    mov ebx,[ebx+4]     ;preiau copilul stang
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    mov ecx,eax         ;rezultatul obtinut in pun in ecx
    pop edx             ;eliberez stiva
    
    mov ebx,[ebp+8]
    mov ebx,[ebx+8]     ;preiau copilul drept
    push ecx            ;adaug pe stiva  
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    pop edx             ;eliberez stiva
    pop ecx             ;eliberez stiva

    imul ecx,eax        ;aplic operatia de inmultire
    mov eax,ecx         ;mut rezultatul in eax
    jmp print           ;ies din functie

impartire:
    mov ebx,[ebp+8]
    mov ebx,[ebx+4]     ;preiau copilul stang
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    mov ecx,eax         ;rezultatul obtinut in pun in ecx
    pop edx             ;eliberez stiva
    
    mov ebx,[ebp+8]
    mov ebx,[ebx+8]     ;preiau copilul drept
    push ecx            ;adaug pe stiva
    push ebx            ;adaug pe stiva
    call citeste        ;verific valoarea copilului
    pop edx             ;eliberez stiva   
    pop ecx             ;eliberez stiva
        
    xchg  eax,ecx       ;aplic operatia de impartire
    cdq                 ;stocheaza rezultatul
    idiv ecx            ;impart numerele
    
    jmp print           ;ies din functie
    
print:
   leave
   ret


main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax

    ; Implementati rezolvarea aici:
    
    mov eax,[root]
    push eax
    call citeste
    PRINT_DEC 4,eax
    pop eax
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret
