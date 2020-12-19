DATA SEGMENT
    VRX DB 9;
    VRY DB 6;
    VRZ DB ?;  
DATA ENDS
SSEG SEGMENT STACK
    DB 100 DUP(?);
SSEG ENDS
CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:SSEG;
    start:
        ;inicialize data and sseg
        MOV AX,DATA;
        MOV DS,AX;
        MOV AX,SSEG;
        MOV SS,AX;
        ;calculate
        ;clear bx and ax
        XOR AX,AX;
        MOV BX,AX;
        MOV AL,VRX;
        MOV BL,VRY;
        MOV CL,2;
        MOV CH,5;
        MUL CH;
        XCHG AX,BX;
        MUL CL;
        CLC;
        ADC AX,BX;
        CLC
        ADC AX,7;
        DIV CL;
        MOV VRZ,AL;
        MOV AH,4CH;
        INT 21H;
CODE ENDS
END start