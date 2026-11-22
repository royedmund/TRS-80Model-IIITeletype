; TELETYPE/CMD - TRS-80 Model III / LDOS 5.3
; Serial terminal for 300 baud, 8 data bits, no parity, 1 stop bit
; Direct Model III RS-232 port access. No BASIC required.
; Ctrl-] (ASCII 1DH) quits to LDOS. Remote echo expected.
        ORG     6000H
START:  LD      A,1CH
        CALL    0033H
        LD      HL,BANNER
        CALL    PRINT
        XOR     A
        OUT     (0E8H),A
        LD      A,055H
        OUT     (0E9H),A
        LD      A,068H
        OUT     (0EAH),A
LOOP:   IN      A,(0EAH)
        BIT     7,A
        JR      Z,KEYBOARD
        IN      A,(0EBH)
        AND     07FH
        CP      0AH
        JR      Z,KEYBOARD
        CP      00H
        JR      Z,KEYBOARD
        CALL    0033H
KEYBOARD:
        CALL    002BH
        OR      A
        JR      Z,LOOP
        CP      01DH
        JR      Z,QUIT
        LD      B,A
TXWAIT: IN      A,(0EAH)
        BIT     6,A
        JR      Z,TXWAIT
        LD      A,B
        OUT     (0EBH),A
        JR      LOOP
QUIT:   LD      HL,GOODBYE
        CALL    PRINT
        LD      HL,0000H
        JP      402DH
PRINT:  LD      A,(HL)
        OR      A
        RET     Z
        PUSH    HL
        CALL    0033H
        POP     HL
        INC     HL
        JR      PRINT
BANNER: DEFB    'TELETYPE - TRS-80 MODEL III',0DH
        DEFB    '300 BAUD  8N1  -  CTRL-] TO EXIT',0DH,0DH,00H
GOODBYE: DEFB   0DH,'EXITING TELETYPE',0DH,00H
        END     START
