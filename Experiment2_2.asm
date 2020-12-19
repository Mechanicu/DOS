DATA SEGMENT
    RES1 DB 0;
    RES2 DB 0;
    RES3 DB 0;
    RS1 DB 0DH,0AH,'RES1:$';
    RS2 DB 0DH,0AH,'RES2:$';
    RS3 DB 0DH,0AH,'RES3:$';
    BUF DB -1, 20, 3, 30, -5, 15, 100, -54, 0, 4, 78, 99, -12, 32, 3, 23, -7, 24, 60,-51
    ;
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
    MOV CX, 20;initialize loop times
    MOV SI, 20;pointer point at the end of the BUF array 
        NEXT:
            DEC SI;
            CMP BUF[SI], 0;
            JL R1;if BUF[SI] less than 0, then RES1++
            CMP BUF[SI], 5;
            JG R3;if BUF[SI] more than 5, then RES3++
            INC RES2;else RES2++
            JMP AGAIN;
            R1:
                INC RES1;
                JMP AGAIN;
            R3: 
                INC RES3;
            AGAIN:
                DEC CX;
                JNZ NEXT;
        MOV DX, OFFSET RS1;
        MOV AH, 09H;print "RES1:"
        INT 21H;
        MOV DL, RES1;print the number of RES1
        ADD DL, 30H;
        MOV AH, 02H;
        INT 21H;

        MOV DX, OFFSET RS2;
        MOV AH, 09H;print "RES2:"
        INT 21H;
        MOV DL, RES2;print the number of RES2
        ADD DL, 30H;
        MOV AH, 02H;
        INT 21H;

        MOV DX, OFFSET RS3;
        MOV AH, 09H;print "RES3:"
        INT 21H;
        MOV DL, RES3;print the number of RES3
        ADD DL, 'A' - 10;
        MOV AH, 02H;
        INT 21H;
    MOV AH, 4CH;
    INT 21H;
CODE ENDS
END START