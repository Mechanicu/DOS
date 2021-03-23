CODE SEGMENT
ASSUME CS:CODE;
START:
    MOV AX, 20H;
    MOV DS, AX;without initialing BX
    MOV CX, 40H;
    AGAIN:
        MOV [BX], BX;
        INC BX;
        LOOP AGAIN;
    MOV AH, 4CH;
    INT 21H;
CODE ENDS
END START

    