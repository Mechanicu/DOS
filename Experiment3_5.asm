DATA SEGMENT
    DATA1 DW 0FFFFH;initialize target word unit
    REZ DB 4 DUP(0);initialize ouput array
    STRING1 DB 0D,0AH,"RESULT:$"
DATA ENDS
SSEG SEGMENT
    DB 100 DUP(?);
SSEG ENDS
CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:SSEG;
    MAIN PROC;define main function
    START:
        MOV AX, DATA;
        MOV DS, AX;
        MOV AX, SSEG;
        MOV SS, AX;
        MOV BX, 16;
        MOV AX, DATA1;
        XOR AH, AH;
        DIV BL;change two low order position to hexadecimal
        MOV REZ[0], AH;
        MOV REZ[1], AL;store the two in the array
        MOV AX, DATA1;
        XOR AL, AL;
        ;DIV 32
        SHR AX, 8;
        DIV BL;change two high order position to hexadecimal
        MOV REZ[2], AH;
        MOV REZ[3], AL;store the two in the array
        CALL PRINT;call function
        MOV DL, 'H';
        MOV AH, 06H;
        INT 21;
        MOV AH, 4CH;
        INT 21H;
    MAIN ENDP;end main function
        PRINT PROC;define subfunction
            MOV DX, OFFSET STRING1;
            MOV AH, 09H;
            INT 21H;
            MOV CX, 4;
            MOV SI, 3;
            AGAIN:;loop four times to output the array data
                MOV DL, REZ[SI];
                CMP DL, 10;
                JL L
                    ADD DL, 'A' - 10;
                    JMP NEXT;change data to its ASC code
                L:
                    ADD DL, '0';change data to its ASC code
                NEXT: 
                MOV AH, 06H;
                INT 21H;output data
                DEC SI;
                DEC CX;
                JNZ AGAIN;continue loop if CX != 0
            RET;
        PRINT ENDP
CODE ENDS
    END START