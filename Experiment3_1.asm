DATA SEGMENT
    REZ DW 0;
    INPUT1 DB 2 DUP(?);
    INPUT2 DB 2 DUP(?);
    H DB 16;
    STRING1 DB 0DH,0AH,'RESULT:$';
DATA ENDS
SSEG SEGMENT
    DB 100 DUP(?);
SSEG ENDS
CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:SSEG;
    START:
        MOV AX, DATA;
        MOV DS, AX;
        MOV AX, SSEG;
        MOV SS, AX;
        ;input first data
        ;input high-order position
        MOV AH, 01H;
        INT 21H;
        MOV INPUT1[0], AL;
        ;input low-order position
        MOV AH, 01H;
        INT 21H;
        MOV INPUT1[1], AL;

        ;input second data
        ;input high-order position
        MOV AH, 01H;
        INT 21H;
        MOV INPUT2[0], AL;
        ;input low-order position
        MOV AH, 01H;
        INT 21H;
        MOV INPUT2[1], AL;

        MOV BL, 10;
        ;change first data to binary data, store in INPUT2[1]
        SUB INPUT1[0], '0';
        MOV AL, INPUT1[0];
        MUL BL;
        SUB INPUT1[1], '0';
        ADD AL, INPUT1[1];
        XOR AH, AH;
        MOV REZ, AX;
        ;change second data to binary data, store in INPUT2[1]
        SUB INPUT2[0], '0';
        MOV AL, INPUT2[0];
        MUL BL;
        SUB INPUT2[1], '0'; 
        ADD AL, INPUT2[1];
        ;store the result in REZ
        ADD REZ, AX;
        
        MOV DX, OFFSET STRING1;
        MOV AH, 09H;
        INT 21H;
        MOV AX, REZ;
        DIV H;calculate high and low order positions

        MOV BX, AX;
        CMP BL, 10;
        JL High;
            ADD BL, 'A' - 10;
            JMP NEXTH;
        High:
            ADD BL, '0';
        NEXTH:
            MOV DL, BL;
            MOV AH, 06H;
            INT 21H;print high-order position

        CMP BH, 10;
        JL Low;
            ADD BH, 'A' - 10;
            JMP NEXTL;
        Low:
            ADD BH, '0';
        NEXTL:
            MOV DL, BH;
            MOV AH, 06H;
            INT 21H;print low-order position
        MOV AH, 4CH;
        INT 21H;
CODE ENDS
END START