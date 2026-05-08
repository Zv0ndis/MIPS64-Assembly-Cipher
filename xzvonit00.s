; Autor reseni: tomas zvonicek xzvonit00

; Projekt 2 - INP 2025
; Souhlaskove modulovana samohlaskova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "tomaszvonicek" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           
                ; Inicializace ukazatelu a konstant
                daddi   r1, r0, msg         ; r1 = ukazatel na zdrojovou zpravu
                daddi   r2, r0, cipher      ; r2 = ukazatel na vystupni sifru
                daddi   r10, r0, 26         ; r10 = 26 
                daddi   r11, r0, 26         ; r11 = klic
                daddi   r12, r0, 97         ; r12 = 'a' 
                
loop:           
                lbu     r3, 0(r1)           ; r3 = aktualni znak
                beq     r3, r0, done        ; pokud znak == 0, jdi na konec
                
                ; Kontrola samohlasky
                daddi   r4, r3, -97         ; r4 = znak - 'a'
                slti    r5, r4, 26          ; r5 = 1 pokud je to pismeno
                beq     r5, r0, store_char  ; neni pismeno, uloz
                
                ; Kontrola jednotlivych samohласek
                beq     r3, r12, is_vowel   ; 'a'
                daddi   r4, r0, 101
                beq     r3, r4, is_vowel    ; 'e'
                daddi   r4, r0, 105
                beq     r3, r4, is_vowel    ; 'i'
                daddi   r4, r0, 111
                beq     r3, r4, is_vowel    ; 'o'
                daddi   r4, r0, 117
                beq     r3, r4, is_vowel    ; 'u'
                daddi   r4, r0, 121
                beq     r3, r4, is_vowel    ; 'y'
                
                ; souhlaska = aktualizace klice
                dsub    r11, r3, r12        ; r11 = znak - 'a' 
                daddi   r11, r11, 1         
                
store_char:
                sb      r3, 0(r2)           ; uloz znak
                daddi   r1, r1, 1           ; dalsi vstupni znak
                daddi   r2, r2, 1           ; dalsi vystupni pozice
                j       loop
                
is_vowel:       
                ; posunuti samohlasky
                dsub    r5, r3, r12         
                dadd    r5, r5, r11         
                

                slt     r6, r5, r10         
                bne     r6, r0, no_wrap    
                dsub    r5, r5, r10         
                
no_wrap:       
                dadd    r3, r5, r12         
                j       store_char          ; uloz znak
                
done:           
                sb      r0, 0(r2)           
                daddi   r4, r0, cipher     
                jal     print_string        





; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
