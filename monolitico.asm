; ==========================================================
; Proyecto: Programa Informatica - Unidad 3
; Tema: Simulador de Ahorro para Retiro (Version Monolitica SUYA)
; Descripcion: Codigo lineal con Meta Dinámica y Validacion Detallada.
; Equipo: Pedro, Brenda, Gabriel, Karla.
; ==========================================================

Include irvine32.inc

.data
    titulo      byte "   >>> SIMULADOR DE AHORRO PARA EL RETIRO <<<   ", 0
    borde       byte " =============================================== ", 0
    separador   byte " ----------------------------------------------- ", 0
    
    ; Prompts
    msgMetaP    byte " Ingrese su meta de ahorro deseada ($): ", 0
    msgCap      byte " Ingrese su capital inicial ($): ", 0
    msgMes      byte " Ingrese su ahorro mensual ($): ", 0
    msgTasa     byte " Ingrese tasa anual (ej: 8.35): ", 0
    msgAnios    byte " Ingrese plazo en a", 164, "os (entero): ", 0
    
    ; Mensajes de Error Detallados
    errNeg      byte " [Error] No se permiten numeros negativos. ", 0
    errChar     byte " [Error] Caracter no numérico detectado. ", 0
    errLimit    byte " [Error] Maximo 2 decimales permitidos. ", 0
    errPunto    byte " [Error] Formato de punto invalido (solo un punto). ", 0
    errNoDec    byte " [Error] El plazo en a", 164, "os debe ser ENTERO. ", 0

    msgYear     byte "  [!] A", 164, "o ", 0
    msgSaldo    byte " -> Saldo acumulado: $", 0
    msgTotal    byte " >>> SALDO FINAL PROYECTADO: $", 0
    msgFelic    byte 173, "FELICIDADES! Ha superado su objetivo de $", 0
    msgNoMeta   byte " Siga ahorrando para alcanzar la libertad financiera. ", 0
    msgEnter    byte " Presione cualquier tecla...", 0
    punto_str   byte ".", 0

    buffer      byte 32 dup(0)
    bufferLen   dword ?
    dotFound    byte 0
    decCount    byte 0
    tempVal     dword 0

    capital     dword ?
    mensual     dword ?
    tasa        dword ?
    anios       dword ?
    metaAhorro  dword ?
    balance     dword ?
    aportAnual  dword ?
    diez_mil    dword 10000
    cien        dword 100

.code
main proc
    call Clrscr

    ; --- ENCABEZADO ---
    mov eax, 13
    call SetTextColor
    mov edx, offset borde
    call WriteString
    call Crlf
    mov edx, offset titulo
    call WriteString
    call Crlf
    mov edx, offset borde
    call WriteString
    call Crlf
    call Crlf

    ; --- CAPTURA META ---
PedirMeta:
    mov eax, 14
    call SetTextColor
    mov edx, offset msgMetaP
    call WriteString
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    mov dotFound, 0
    mov decCount, 0
    mov tempVal, 0
    mov esi, offset buffer
    mov ecx, bufferLen
    cmp ecx, 0
    je PedirMeta
LM:
    mov al, [esi]
    cmp al, '-'
    je ErrorNeg0
    cmp al, '.'
    je EsPunto0
    cmp al, '0'
    jb ErrorChar0
    cmp al, '9'
    ja ErrorChar0
    sub al, '0'
    movzx eax, al
    push eax
    mov eax, tempVal
    mov ebx, 10
    mul ebx
    pop edx
    add eax, edx
    mov tempVal, eax
    cmp dotFound, 1
    jne SM
    inc decCount
    cmp decCount, 2
    ja ErrorLimit0
    jmp SM
EsPunto0:
    cmp dotFound, 1
    je ErrorPunto0
    mov dotFound, 1
SM:
    inc esi
    loop LM
    mov eax, tempVal
    cmp dotFound, 0
    je EM_100
    cmp decCount, 0
    je EM_100
    cmp decCount, 1
    je EM_10
    jmp MetaOK
EM_100: 
    mov ebx, 100 
    mul ebx 
    jmp MetaOK
EM_10:  
    mov ebx, 10 
    mul ebx
MetaOK: 
    mov metaAhorro, eax
    jmp PedirCap

ErrorNeg0:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errNeg 
    call WriteString 
    call Crlf 
    jmp PedirMeta
ErrorChar0:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errChar 
    call WriteString 
    call Crlf 
    jmp PedirMeta
ErrorLimit0:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errLimit 
    call WriteString 
    call Crlf 
    jmp PedirMeta
ErrorPunto0:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errPunto 
    call WriteString 
    call Crlf 
    jmp PedirMeta

    ; --- CAPTURA CAPITAL ---
PedirCap:
    mov eax, 14
    call SetTextColor
    mov edx, offset msgCap
    call WriteString
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    mov dotFound, 0
    mov decCount, 0
    mov tempVal, 0
    mov esi, offset buffer
    mov ecx, bufferLen
    cmp ecx, 0
    je PedirCap
L1:
    mov al, [esi]
    cmp al, '-'
    je ErrorNeg1
    cmp al, '.'
    je EsPunto1
    cmp al, '0'
    jb ErrorChar1
    cmp al, '9'
    ja ErrorChar1
    sub al, '0'
    movzx eax, al
    push eax
    mov eax, tempVal
    mov ebx, 10
    mul ebx
    pop edx
    add eax, edx
    mov tempVal, eax
    cmp dotFound, 1
    jne S1
    inc decCount
    cmp decCount, 2
    ja ErrorLimit1
    jmp S1
EsPunto1:
    cmp dotFound, 1
    je ErrorPunto1
    mov dotFound, 1
S1:
    inc esi
    loop L1
    mov eax, tempVal
    cmp dotFound, 0
    je E1_100
    cmp decCount, 0
    je E1_100
    cmp decCount, 1
    je E1_10
    jmp CapOK
E1_100: 
    mov ebx, 100 
    mul ebx 
    jmp CapOK
E1_10:  
    mov ebx, 10 
    mul ebx
CapOK:  
    mov capital, eax
    jmp PedirMes

ErrorNeg1:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errNeg 
    call WriteString 
    call Crlf 
    jmp PedirCap
ErrorChar1:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errChar 
    call WriteString 
    call Crlf 
    jmp PedirCap
ErrorLimit1:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errLimit 
    call WriteString 
    call Crlf 
    jmp PedirCap
ErrorPunto1:
    mov eax, 12 
    call SetTextColor
    mov edx, offset errPunto 
    call WriteString 
    call Crlf 
    jmp PedirCap

    ; --- CAPTURA MENSUAL ---
PedirMes:
    mov eax, 14
    call SetTextColor
    mov edx, offset msgMes
    call WriteString
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    mov dotFound, 0
    mov decCount, 0
    mov tempVal, 0
    mov esi, offset buffer
    mov ecx, bufferLen
    cmp ecx, 0
    je PedirMes
L2:
    mov al, [esi]
    cmp al, '-'
    je ErrorNeg2
    cmp al, '.'
    je EsPunto2
    cmp al, '0'
    jb ErrorChar2
    cmp al, '9'
    ja ErrorChar2
    sub al, '0'
    movzx eax, al
    push eax
    mov eax, tempVal
    mov ebx, 10
    mul ebx
    pop edx
    add eax, edx
    mov tempVal, eax
    cmp dotFound, 1
    jne S2
    inc decCount
    cmp decCount, 2
    ja ErrorLimit2
    jmp S2
EsPunto2:
    cmp dotFound, 1
    je ErrorPunto2
    mov dotFound, 1
S2:
    inc esi
    loop L2
    mov eax, tempVal
    cmp dotFound, 0
    je E2_100
    cmp decCount, 0
    je E2_100
    cmp decCount, 1
    je E2_10
    jmp MesOK
E2_100: 
    mov ebx, 100 
    mul ebx 
    jmp MesOK
E2_10:  
    mov ebx, 10 
    mul ebx
MesOK:  
    mov mensual, eax
    jmp PedirTasa

ErrorNeg2:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errNeg 
    call WriteString 
    call Crlf 
    jmp PedirMes
ErrorChar2:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errChar 
    call WriteString 
    call Crlf 
    jmp PedirMes
ErrorLimit2:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errLimit 
    call WriteString 
    call Crlf 
    jmp PedirMes
ErrorPunto2:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errPunto 
    call WriteString 
    call Crlf 
    jmp PedirMes

    ; --- CAPTURA TASA ---
PedirTasa:
    mov eax, 14
    call SetTextColor
    mov edx, offset msgTasa
    call WriteString
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    mov dotFound, 0
    mov decCount, 0
    mov tempVal, 0
    mov esi, offset buffer
    mov ecx, bufferLen
    cmp ecx, 0
    je PedirTasa
L3:
    mov al, [esi]
    cmp al, '-'
    je ErrorNeg3
    cmp al, '.'
    je EsPunto3
    cmp al, '0'
    jb ErrorChar3
    cmp al, '9'
    ja ErrorChar3
    sub al, '0'
    movzx eax, al
    push eax
    mov eax, tempVal
    mov ebx, 10
    mul ebx
    pop edx
    add eax, edx
    mov tempVal, eax
    cmp dotFound, 1
    jne S3
    inc decCount
    cmp decCount, 2
    ja ErrorLimit3
    jmp S3
EsPunto3:
    cmp dotFound, 1
    je ErrorPunto3
    mov dotFound, 1
S3:
    inc esi
    loop L3
    mov eax, tempVal
    cmp dotFound, 0
    je E3_100
    cmp decCount, 0
    je E3_100
    cmp decCount, 1
    je E3_10
    jmp TasaOK
E3_100: 
    mov ebx, 100 
    mul ebx 
    jmp TasaOK
E3_10:  
    mov ebx, 10 
    mul ebx
TasaOK: 
    mov tasa, eax
    jmp PedirAnio

ErrorNeg3:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errNeg 
    call WriteString 
    call Crlf 
    jmp PedirTasa
ErrorChar3:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errChar 
    call WriteString 
    call Crlf 
    jmp PedirTasa
ErrorLimit3:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errLimit 
    call WriteString 
    call Crlf 
    jmp PedirTasa
ErrorPunto3:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errPunto 
    call WriteString 
    call Crlf 
    jmp PedirTasa

    ; --- CAPTURA PLAZO ---
PedirAnio:
    mov eax, 14
    call SetTextColor
    mov edx, offset msgAnios
    call WriteString
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    mov tempVal, 0
    mov esi, offset buffer
    mov ecx, bufferLen
    cmp ecx, 0
    je PedirAnio
L4:
    mov al, [esi]
    cmp al, '-'
    je ErrorNeg4
    cmp al, '.'
    je ErrorNoDec4
    cmp al, '0'
    jb ErrorChar4
    cmp al, '9'
    ja ErrorChar4
    sub al, '0'
    movzx eax, al
    push eax
    mov eax, tempVal
    mov ebx, 10
    mul ebx
    pop edx
    add eax, edx
    mov tempVal, eax
    inc esi
    loop L4
    mov eax, tempVal
    mov anios, eax
    jmp Iniciar

ErrorNeg4:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errNeg 
    call WriteString 
    call Crlf 
    jmp PedirAnio
ErrorChar4:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errChar 
    call WriteString 
    call Crlf 
    jmp PedirAnio
ErrorNoDec4:
    mov eax, 12 
    call SetTextColor 
    mov edx, offset errNoDec 
    call WriteString 
    call Crlf 
    jmp PedirAnio

Iniciar:
    mov eax, capital
    mov balance, eax
    mov eax, mensual
    mov ebx, 12
    mul ebx
    mov aportAnual, eax
    mov eax, 8 
    call SetTextColor 
    call Crlf
    mov edx, offset separador 
    call WriteString 
    call Crlf
    mov ecx, 1          
Ciclo:
    cmp ecx, anios
    jg FinSim
    mov eax, aportAnual
    add balance, eax
    mov eax, balance
    mul tasa
    div diez_mil
    add balance, eax
    mov eax, 3 
    call SetTextColor 
    mov edx, offset msgYear 
    call WriteString
    mov eax, ecx 
    call WriteDec
    mov eax, 11 
    call SetTextColor 
    mov edx, offset msgSaldo 
    call WriteString
    mov eax, balance 
    xor edx, edx 
    div cien 
    call WriteDec
    push edx 
    mov edx, offset punto_str 
    call WriteString 
    pop eax
    cmp eax, 10 
    jae P1 
    push eax 
    mov eax, 0 
    call WriteDec 
    pop eax
P1: 
    call WriteDec 
    call Crlf 
    inc ecx 
    jmp Ciclo

FinSim:
    mov eax, 8 
    call SetTextColor 
    call Crlf
    mov edx, offset separador 
    call WriteString 
    call Crlf
    mov eax, 10 
    call SetTextColor 
    mov edx, offset msgTotal 
    call WriteString
    mov eax, balance 
    xor edx, edx 
    div cien 
    call WriteDec
    push edx 
    mov edx, offset punto_str 
    call WriteString 
    pop eax
    cmp eax, 10 
    jae P2 
    push eax 
    mov eax, 0 
    call WriteDec 
    pop eax
P2: 
    call WriteDec 
    call Crlf 
    call Crlf
    mov eax, balance
    cmp eax, metaAhorro
    jae Meta
    mov eax, 10 
    call SetTextColor 
    mov edx, offset msgNoMeta 
    call WriteString 
    jmp Salir
Meta: 
    mov eax, 10 
    call SetTextColor 
    mov edx, offset msgFelic 
    call WriteString
    mov eax, metaAhorro 
    xor edx, edx 
    div cien 
    call WriteDec
    push edx 
    mov edx, offset punto_str 
    call WriteString 
    pop eax
    cmp eax, 10 
    jae P3 
    push eax 
    mov eax, 0 
    call WriteDec 
    pop eax
P3: 
    call WriteDec 
    call Crlf
Salir:
    call Crlf 
    call Crlf 
    mov eax, 7 
    call SetTextColor 
    mov edx, offset msgEnter 
    call WriteString
    call WaitMsg 
    exit
main endp
end main