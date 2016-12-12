%include "io.inc"

section .data
    %include "input.inc"
    print_invalid db "Baza incorecta", 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    mov eax, [baza]         ;salvam baza in eax
    cmp eax, 2
    jl invalid_base         ;daca baza este mai mica ca 2, jump to invalid_base
    cmp eax, 16
    jg invalid_base         ;sau daca este mai mare decat 16
    mov ecx, dword [numar]  ;salvam initial numarul ce va fi convertit in ecx
    mov ebx, 0              ;in ebx vom numara de cate ori se va da push pe stiva
    jmp convert             ;label-ul in care se realizeaza conversia
    
invalid_base:                   ;label-ul in cazul unei baze invalide
    PRINT_STRING print_invalid  ;afiseaza mesajul corespunzator
    jmp end                     ;termina programul

convert:
    push ebx                ;salvam valoarea din ebx pe stiva(numarul de "push-uri")
    mov edx, 0              ;punem valoarea 0 in edx
    mov eax, ecx            ;punem numarul de convertit in eax
    mov ebx, dword [baza]   ;punem baza in ebx
    div ebx                 ;se realizeaza impartirea
    pop ebx                 ;returnam valoarea lui ebx
    inc ebx                 ;si o incrementam
    push edx                ;punem restul impartirii pe stiva
    mov ecx, eax            ;catul impartirii devine noul deimpartit
    cmp ecx, 0              ;se compara catul cu 0
    jg convert              ;daca nu e 0 inca, continuam impartirile si operatiile de push
    jmp display             ;daca e 0, s-a ajuns la finalul conversiei si vom afisa numarul
    
display:                    ;label-ul principal pentru afisare
    cmp ebx,0               ;comparam ebx(nr. de push-uri) cu 0
    jg display2             ;daca nu este 0 inca continuam spre afisare
    jmp end                 ;daca este 0, afisarea a luat sfarsit si terminam programul
    
display2:                   ;label-ul de afisare a cifrelor
    dec ebx                 ;decrementam ebx
    pop edx                 ;returnam valoarea restului de pe stiva
    cmp edx, 10             ;comparam cu 10
    jge display3            ;daca este >= vom merge spre display3 pentru afisarea de litere
    add edx, '0'            ;altfel, adaugam la edx valoarea lui '0'
    PRINT_CHAR edx          ;printam restul folosind macro-ul PRINT_CHAR
    jmp display             ;continuam pana ebx=0;
    
display3:                   ;label pentru afisarea de litere
    sub edx, 10             ;scadem 10 valori din edx
    add edx, 'a'            ;adaugam valoarea lui 'a' pentru a obtine literele a,b,c,d,e,f
    PRINT_CHAR edx          ;printam litera
    jmp display             ;continuam pana ebx=0;
       
end:                        ;label-ul care termina programul
    xor eax, eax
    ret
    