DATA SEGMENT
    UPC_UP DB 5AH;
    UPC_DOWN DB 41H;
    LOWC_UP DB 7AH;
    LOWC_DOWN DB 61H;
    WARNING DB 0DH,0AH,'ERROR! PLEASE INPUT AGAIN.',0DH,0AH,'$';
DATA ENDS
SSEG SEGMENT STACK
    DB 100 DUP(?);
SSEG ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:SSEG;
    start:        
        MOV AX,DATA;
        MOV DS,AX;change first data to binary data, store in INPUT2[1],AX;
        MOV AX,SSEG;
        MOV SS,AX;
        AGAIN:
            MOV AH,1;
            INT 21H;
            U:
                CMP AL,41H;
                JL WRONG;
                CMP AL,5AH;
                JG L;
                ADD AL,'a'-'A';CHANGE
                MOV AH,4CH;
                INT 21H;
            L:
                CMP AL,61H;
                JL WRONG;
                CMP AL,7AH;
                JG WRONG;                
                SUB AL,'a'-'A';CHANGE
                MOV AH,4CH;
                INT 21H;
            WRONG:
                MOV DX, OFFSET WARNING;
                MOV AH, 9;
                INT 21H;
                JMP AGAIN;
CODE ENDS
END start