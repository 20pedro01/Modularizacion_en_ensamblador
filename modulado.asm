; ==========================================================
; Proyecto: Programa Informatica - Unidad 3
; Tema: Simulador de Ahorro para Retiro (Version Hiper-Modulada V10)
; Descripcion: Arquitectura de Alto Nivel con Meta Dinamica.
; Equipo: Pedro, Brenda, Gabriel, Karla.
; ==========================================================

Include irvine32.inc

; --- MACROS ATOMICAS ---

mSetColor macro color
    push eax
    mov eax, color
    call SetTextColor
    pop eax
endm

mPrint macro cadena
    push edx
    mov edx, offset cadena
    call WriteString
    pop edx
endm

mBorde macro color
    mSetColor color
    mPrint borde
    call Crlf
endm

mSeparador macro color
    mSetColor color
    mPrint separador
    call Crlf
endm

; --- MACROS DE CAPTURA ---

mCaptura macro msgQuery, variable, color, modo
    call ResetBuffer
    mSetColor color
    mPrint msgQuery
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    push offset msgQuery
    push modo
    call ValidarEntrada
    mov variable, eax
endm

; --- MACROS DE FASE ---

mFaseInicial macro
    call Clrscr
    call MostrarLogo
endm

mFaseCaptura macro
    mCaptura msgMetaP, metaAhorro, 14, 0
    mCaptura msgCap, capital, 14, 0
    mCaptura msgMes, mensual, 14, 0
    mCaptura msgTasa, tasa, 14, 0
    mCaptura msgAnios, anios, 14, 1
endm

mFaseSimulacion macro
    mSeparador 8
    call EjecutarCicloFinanciero
    mSeparador 8
endm

mFaseResultados macro
    call InformarResultadosFinales
endm

mFaseFinal macro
    mSetColor 7
    call Crlf
    mPrint msgEnter
    call WaitMsg
    exit
endm

.data
    titulo      byte "   >>> SIMULADOR DE AHORRO PARA EL RETIRO <<<   ", 0
    borde       byte " =============================================== ", 0
    separador   byte " ----------------------------------------------- ", 0
    
    ; Prompts Dinamicos
    msgMetaP    byte " Ingrese su meta de ahorro deseada ($): ", 0
    msgCap      byte " Ingrese capital inicial ($): ", 0
    msgMes      byte " Ingrese ahorro mensual ($):  ", 0
    msgTasa     byte " Ingrese tasa (ej: 8.35): ", 0
    msgAnios    byte " Ingrese plazo en a", 164, "os (entero): ", 0
    
    ; Errores
    errNeg      byte " [Error] No se permiten numeros negativos. ", 0
    errChar     byte " [Error] Caracter no numerico detectado. ", 0
    errLimit    byte " [Error] Maximo 2 decimales permitidos. ", 0
    errPunto    byte " [Error] Formato de punto invalido (solo un punto). ", 0
    errNoDec    byte " [Error] El plazo en a", 164, "os debe ser ENTERO. ", 0

    msgYear     byte "  [!] A", 164, "o ", 0
    msgSaldo    byte " -> Saldo: $", 0
    msgTotal    byte " >>> SALDO FINAL PROYECTADO: $", 0
    msgFelic    byte 173, "FELICIDADES! Ha superado su objetivo de $", 0
    msgNoMeta   byte " Siga ahorrando para alcanzar la libertad financiera. ", 0
    msgEnter    byte " Presione cualquier tecla...", 0
    punto_str   byte ".", 0

    buffer      byte 32 dup(0)
    bufferLen   dword ?
    capital     dword ?
    mensual     dword ?
    tasa        dword ?
    anios       dword ?
    metaAhorro  dword ?
    balance     dword ?

.code
main proc
    mFaseInicial
    mFaseCaptura
    mFaseSimulacion
    mFaseResultados
    mFaseFinal
main endp

; --- PROCEDIMIENTOS ---

MostrarLogo proc
    mBorde 13
    mSetColor 13
    mPrint titulo
    call Crlf
    mBorde 13
    call Crlf
    ret
MostrarLogo endp

EjecutarCicloFinanciero proc
    push eax
    push ebx
    push ecx
    push edx
    mov eax, capital
    mov balance, eax
    mov ecx, 1
L_Ciclo:
    cmp ecx, anios
    jg L_FinCiclo
    mov eax, mensual
    mov ebx, 12
    mul ebx
    add balance, eax
    mov eax, balance
    mul tasa
    push 10000
    xor edx, edx
    div dword ptr [esp]
    add esp, 4
    add balance, eax
    mSetColor 3
    mPrint msgYear
    mov eax, ecx
    call WriteDec
    mSetColor 11
    mPrint msgSaldo
    push balance
    call ImprimirMoneda
    call Crlf
    inc ecx
    jmp L_Ciclo
L_FinCiclo:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
EjecutarCicloFinanciero endp

InformarResultadosFinales proc
    mSetColor 10
    mPrint msgTotal
    push balance
    call ImprimirMoneda
    call Crlf
    mov eax, balance
    cmp eax, metaAhorro
    jae L_OkMeta
    mPrint msgNoMeta
    jmp L_FinMeta
L_OkMeta:
    mPrint msgFelic
    push metaAhorro
    call ImprimirMoneda
    call Crlf
L_FinMeta:
    ret
InformarResultadosFinales endp

ImprimirMoneda proc
    push ebp
    mov ebp, esp
    push eax
    push edx
    mov eax, [ebp+8]
    xor edx, edx
    mov ebx, 100
    div ebx
    call WriteDec
    mPrint punto_str
    mov eax, edx
    cmp eax, 10
    jae L_P_Imp
    push eax
    mov eax, 0
    call WriteDec
    pop eax
L_P_Imp:
    call WriteDec
    pop edx
    pop eax
    pop ebp
    ret 4
ImprimirMoneda endp

ResetBuffer proc
    push ecx
    push edi
    mov ecx, 32
    mov al, 0
    mov edi, offset buffer
    rep stosb
    pop edi
    pop ecx
    ret
ResetBuffer endp

ValidarEntrada proc
    push ebp
    mov ebp, esp
    sub esp, 12
L_Reentrar:
    mov dword ptr [ebp-4], 0
    mov byte ptr [ebp-8], 0
    mov byte ptr [ebp-12], 0
    mov esi, offset buffer
    mov ecx, bufferLen
    cmp ecx, 0
    je L_Reentrar
L_LoopAnalisis:
    mov al, [esi]
    cmp al, '-'
    je L_Err1
    cmp al, '.'
    je L_EsPunto
    cmp al, '0'
    jb L_Err2
    cmp al, '9'
    ja L_Err2
    sub al, '0'
    movzx eax, al
    push eax
    mov eax, [ebp-4]
    mov ebx, 10
    mul ebx
    pop edx
    add eax, edx
    mov [ebp-4], eax
    cmp byte ptr [ebp-8], 1
    jne L_SigChar
    inc byte ptr [ebp-12]
    cmp byte ptr [ebp-12], 2
    ja L_Err3
    jmp L_SigChar
L_EsPunto:
    cmp dword ptr [ebp+8], 1
    je L_Err5
    cmp byte ptr [ebp-8], 1
    je L_Err4
    mov byte ptr [ebp-8], 1
L_SigChar:
    inc esi
    loop L_LoopAnalisis
    mov eax, [ebp-4]
    cmp byte ptr [ebp-8], 0
    je L_S100
    cmp byte ptr [ebp-12], 0
    je L_S100
    cmp byte ptr [ebp-12], 1
    je L_S10
    jmp L_S_Exit
L_S100:
    cmp dword ptr [ebp+8], 1
    je L_S_Exit
    mov ebx, 100
    mul ebx
    jmp L_S_Exit
L_S10: 
    mov ebx, 10 
    mul ebx
L_S_Exit:
    add esp, 12
    pop ebp
    ret 8
L_Err1: 
    mov ebx, 2
    jmp L_Muestra
L_Err2: 
    mov ebx, 3
    jmp L_Muestra
L_Err3: 
    mov ebx, 4
    jmp L_Muestra
L_Err4: 
    mov ebx, 5
    jmp L_Muestra
L_Err5: 
    mov ebx, 6
    jmp L_Muestra
L_Muestra:
    push ebx
    call DesplegarErrorMensaje
    call Crlf
    mSetColor 14
    mov edx, [ebp+12]
    call WriteString
    mov edx, offset buffer
    mov ecx, 31
    call ReadString
    mov bufferLen, eax
    jmp L_Reentrar
ValidarEntrada endp

DesplegarErrorMensaje proc
    push ebp
    mov ebp, esp
    mSetColor 12
    mov eax, [ebp+8]
    cmp eax, 2
    je L_M2
    cmp eax, 3
    je L_M3
    cmp eax, 4
    je L_M4
    cmp eax, 5
    je L_M5
    cmp eax, 6
    je L_M6
    jmp L_MFin
L_M2: 
    mPrint errNeg
    jmp L_MFin
L_M3: 
    mPrint errChar
    jmp L_MFin
L_M4: 
    mPrint errLimit
    jmp L_MFin
L_M5: 
    mPrint errPunto
    jmp L_MFin
L_M6: 
    mPrint errNoDec
L_MFin:
    pop ebp
    ret 4
DesplegarErrorMensaje endp
end main