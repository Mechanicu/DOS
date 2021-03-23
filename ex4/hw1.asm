ASSUME CS:CODE;
CODE SEGMENT
    MOV AX, CODE;
    MOV DS, AX;
    MOV AX, 20H;
    MOV ES, AX;
    MOV CX, 10H;decided by IP when debuging
    S:
        MOV AL, [BX];
        MOV ES:[BX], AL;
        INC BX;
        LOOP S;
    MOV AH, 4CH;
    INT 21H;
CODE ENDS
END
