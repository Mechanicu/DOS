DATA SEGMENT
	COUNT    DB 10                     	;loop times
	BUFSIZE1 DB 25                     	;
	ACTLEN1  DB ?                      	;
	INPUT1   DB 25 DUP(0)              	;store the first string
	BUFSIZE2 DB 25                     	;
	ACTLEN2  DB ?                      	;
	INPUT2   DB 25 DUP(0)              	;store the second string
	STRING_IN1 DB 0AH, 0DH, "FIRST  ONE:$";
	STRING_IN2 DB 0AH, 0DH, "SECOND ONE:$"
	STRING1  DB 0DH, 0AH, "LARGE ONE:$"	;
	STRING2  DB 0DH, 0AH, "SMALL ONE:$"	;
	OUTPUT_L DB 25 DUP(' ')	;store the shorter string
DATA ENDS
SSEG SEGMENT
	DB 100 DUP(?);
SSEG ENDS
CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:SSEG, ES:DATA; ES and DS use the same segment DATA
MAIN PROC
	START:        
	    MOV    AX, DATA                          	;
        MOV    DS, AX                            	
        MOV    AX, SSEG                          	;
        MOV    SS, AX                            	;
	    MOV    AX, DATA                          	;
	    MOV    ES, AX                            	;
	AGAIN:        
		MOV	   DX, OFFSET STRING_IN1				;
		MOV    AH, 09H								;	
		INT    21H									;
	    MOV    DX, OFFSET BUFSIZE1               	;
	    MOV    AH, 0AH                           	;
	    INT    21H 									;input first string			
		MOV    DX, OFFSET STRING_IN2                ;
		MOV    AH, 09H								;
		INT    21H									;
	    MOV    DX, OFFSET BUFSIZE2               	;
	    MOV    AH, 0AH                           	;
	    INT    21H                               	;input second string	
	    MOV    BL, BUFSIZE1[1]                   	;
	    XOR    BH, BH                            	;
	    MOV    BUFSIZE1[BX+2], '$'               	;change the tail of first string to '$'
	    MOV    BL, BUFSIZE2[1]                   	;
	    XOR    BH, BH                            	;
	    MOV    BUFSIZE2[BX+2], '$'               	;change the tail of second string to '$'

	    MOV    AL, BUFSIZE1[1]                   	;
	    MOV    BL, BUFSIZE2[1]                   	;
	    XOR    BH, BH                            	;
	    CMP    AL, BL                            	;compare the length of two strings
	    JG     NEXT                              	;if the first is longer than the second, the jmp to next
	    JE     OUTPUTS                           	;if they have same length, then directly output
	    
		MOV    CL, BUFSIZE1[1]                   	;if the second is longer than the first, then continue
	    INC    CL                                	;
	    XOR    CH, CH                            	;
        PUSH   CX;
	    STD                                      	;
	    LEA    DI, OUTPUT_L[BX]						;
		PUSH   BX                  					;
	    MOV    BL, AL                            	;
	    LEA    SI, INPUT1[BX]                    	;
		POP    BX									;
	    REP    MOVSB                             	;move the shorter one to OUTPUT_L
	    CALL   OUTPUT_INPUT2                        ;
        CALL   OUTPUT_OUTPUT_L						;output the longer and the shorter
		;CALL   CLEAR_OUTPUT_L						;
	    JMP    LAST                              	;                               	
	NEXT:         
	    MOV    CL, BUFSIZE2[1]                   	;
	    INC    CL                                	;
	    XOR    CH, CH                            	;
        PUSH   CX;
	    STD                                      	;
	    LEA    SI, INPUT2[BX]                   	;
	    MOV    BL, AL                            	;
	    LEA    DI, OUTPUT_L[BX]						;
	    REP    MOVSB                             	;move the shorter one to OUTPUT_L
	    CALL   OUTPUT_INPUT1                        ;
        CALL   OUTPUT_OUTPUT_L						;output the longer and the shorter
        ;CALL   CLEAR_OUTPUT_L                     	;
        JMP    LAST;
	OUTPUTS:      
	    CALL   OUTPUT_INPUT1                     	;
	    CALL   OUTPUT_INPUT2                      	;	
	LAST:    
	    ;DEC    COUNT                             	;
	    ;JNZ    AGAIN                             	;
	    MOV    AH, 4CH                           	;
	    INT    21H                               	;
MAIN ENDP
OUTPUT_INPUT1 PROC
	    MOV    DX, OFFSET STRING1                	;
	    MOV    AH, 09H                           	;
	    INT    21H                               	;
	    MOV    DX, OFFSET INPUT1                 	;
	    MOV    AH, 09H                           	;
	    INT    21H                               	;
        RET;
OUTPUT_INPUT1 ENDP
OUTPUT_INPUT2 PROC
	    MOV    DX, OFFSET STRING1                	;
	    MOV    AH, 09H                           	;
	    INT    21H                               	;
	    MOV    DX, OFFSET INPUT2                 	;
	    MOV    AH, 09H                           	;
	    INT    21H                               	;
        RET;
OUTPUT_INPUT2 ENDP
OUTPUT_OUTPUT_L PROC                    	;
        MOV    DX, OFFSET STRING2;
        MOV    AH, 09H;
        INT    21H;
        MOV    DX, OFFSET OUTPUT_L;
        MOV    AH, 09H;
        INT    21H;
		RET;
OUTPUT_OUTPUT_L ENDP
CODE ENDS
    END START