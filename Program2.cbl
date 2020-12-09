       program-id. Program2 as "Program2".

       environment division.
       FILE-CONTROL.
       SELECT STUDENT-FILE
           ASSIGN TO "C:\Users\Administrator\Downloads\STUFILE4.TXT"
               ORGANIZATION IS INDEXED
               ACCESS IS RANDOM
               RECORD KEY IS IND-STUDENT-NUMBER
               ALTERNATE RECORD KEY IS IND-TUITION-OWED WITH            
               DUPLICATES
               FILE STATUS IS STATUS-FIELD.

       data division.
       FILE SECTION.
       FD STUDENT-FILE.
       01 INDEXED-FILE-RECORD.
           05 IND-STUDENT-NUMBER  PIC 9(6).
           05 IND-TUITION-OWED    PIC 9(4)V99.
           05 IND-STUDENT-NAME    PIC X(40).
           05 IND-PROGRAM-OF-STUDY    PIC X(5).
           05 IND-COURSE-CODE-1   PIC X(7).
           05 IND-AVERAGE-1       PIC 9(3).
           05 IND-COURSE-CODE-2   PIC X(7).
           05 IND-AVERAGE-2       PIC 9(3).
           05 IND-COURSE-CODE-3   PIC X(7).
           05 IND-AVERAGE-3       PIC 9(3).
           05 IND-COURSE-CODE-4   PIC X(7).
           05 IND-AVERAGE-4       PIC 9(3).
           05 IND-COURSE-CODE-5   PIC X(7).
           05 IND-AVERAGE-5       PIC 9(3).
       
       working-storage section.
       01 STATUS-FIELD PIC X(2).
       01 FLAGS-AND-CONTROLS.
         05 TRANS-FLAG-WS PIC X(1).
         05 STUDENT-NUMBER-WS PIC 9(6).
         05 TUTION-OWNED-WS PIC 9(5)V99.
         05 INPUT-DATA-FLAG PIC X(4).
         
       SCREEN SECTION.
       01 ONLINE-TRANSACTION-SEREEN.
         05 VALUE "ONLINE TRANSACTION" LINE 3 COL 3.
         05 VALUE "TRANSACTION TO ENTER?" LINE 5 COL 5.
         05 TRANS-IN-FLAG  LINE 5 COL 25 PIC X(1) TO TRANS-FLAG-WS.
         05 VALUE "STUDENT NUMBER?" LINE 7 COL 5.
         05 STUDENT-NUMBER-TRANS LINE 7 COL 25 PIC 9(6) TO 
         STUDENT-NUMBER-WS.
         05 VALUE "TUITION OWNED?" LINE 9 COL 5.
         05 TUTION-OWNED-TRANS LINE 9 COL 25 PIC 9(5)V99 TO 
         TUTION-OWNED-WS.
       01 STUDENT-NUMBER-SCREEN.
         05 VALUE "STUDENT NUMBER: " LINE 15 COL 4.
         05 STUDENT-NUMBER-TRANS LINE 15 COL 20 PIC 9(6) FROM 
         STUDENT-NUMBER-WS.
       01 MESSAGE-REC-UPDATED-SCREEN.
           05 VALUE "; Record Updated.    " LINE 15 COL 29.
       01 MESSAGE-REC-NOT-FOUND-SCREEN.
           05 VALUE "; Record Not Found.  " LINE 15 COL 29.
       01 MESSAGE-INPUT-INVALID-SCREEN.
           05 VALUE "; Input Data Invalid." LINE 15 COL 29.
           

       procedure division.
       100-UPDATE-INDEXED-STUDENT-FILE.
           PERFORM 201-INTIATE-UPDATE-INDEXED-STUDENT-FILE.
           PERFORM 202-UPDATE-INDEXED-STUDENT-FILE UNTIL 
             TRANS-FLAG-WS = "N" OR TRANS-FLAG-WS = "n".                
           PERFORM 203-TERMINATE-UPDATE-INDEXED-STUDENT-FILE.
           STOP RUN.
       
       201-INTIATE-UPDATE-INDEXED-STUDENT-FILE.                         
           PERFORM 701-OPEN-INDEXED-STUDENT-FILE.
       
       202-UPDATE-INDEXED-STUDENT-FILE.
           DISPLAY ONLINE-TRANSACTION-SEREEN.
           ACCEPT ONLINE-TRANSACTION-SEREEN.
           IF TRANS-FLAG-WS = "Y" OR TRANS-FLAG-WS = "y"
               PERFORM 702-CHECK-ACCEPT-DATA
                   IF INPUT-DATA-FLAG = "GOOD"
                       PERFORM 703-UPDATE-STUDENT-RECORD
                   END-IF
           END-IF.
       
       203-TERMINATE-UPDATE-INDEXED-STUDENT-FILE.
           PERFORM 704-CLOSE-UPDATE-STUDENT-FILE.
           
       701-OPEN-INDEXED-STUDENT-FILE.
           OPEN I-O STUDENT-FILE.
           MOVE "Y" TO TRANS-FLAG-WS.
       
       702-CHECK-ACCEPT-DATA.
           DISPLAY STUDENT-NUMBER-SCREEN.
           IF STUDENT-NUMBER-WS = 111111 AND TUTION-OWNED-WS = 500.00
               MOVE "GOOD" TO INPUT-DATA-FLAG
           ELSE IF STUDENT-NUMBER-WS = 411119 AND 
           TUTION-OWNED-WS = 50.00
               MOVE "GOOD" TO INPUT-DATA-FLAG
           ELSE
               MOVE "BAD" TO INPUT-DATA-FLAG
               DISPLAY MESSAGE-INPUT-INVALID-SCREEN
           END-IF.
       
       703-UPDATE-STUDENT-RECORD.
           MOVE STUDENT-NUMBER-WS TO IND-STUDENT-NUMBER.
           READ STUDENT-FILE
               INVALID KEY DISPLAY MESSAGE-REC-NOT-FOUND-SCREEN
               NOT INVALID KEY PERFORM UPDATE-STUFILE-RECORD
           END-READ.
       
       UPDATE-STUFILE-RECORD.
           MOVE TUTION-OWNED-WS TO IND-TUITION-OWED.
           REWRITE INDEXED-FILE-RECORD
               INVALID KEY DISPLAY MESSAGE-REC-NOT-FOUND-SCREEN
               NOT INVALID KEY DISPLAY MESSAGE-REC-UPDATED-SCREEN
           END-REWRITE.
       
       704-CLOSE-UPDATE-STUDENT-FILE.
           CLOSE STUDENT-FILE.
       
       end program Program2.
