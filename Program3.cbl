       program-id. Program3 as "Program3".

       environment division.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT INDEXED-STUDENT-FILE-IN
           ASSIGN TO "C:\Users\Administrator\Downloads\STUFILE4.TXT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS IND-STUDENT-NUMBER
               ALTERNATE RECORD KEY IS IND-TUITION-OWED WITH            
               DUPLICATES.
       SELECT PROGRAM-FILE-IN
           ASSIGN TO "C:\Users\Administrator\Downloads\PROGRAM.TXT"
               ORGANIZATION IS LINE SEQUENTIAL.
       SELECT STUDENT-REPORT-OUT
           ASSIGN TO 
           "C:\Users\Administrator\Downloads\STUDENT-REPORT.TXT"
           ORGANIZATION IS LINE SEQUENTIAL.
        
       configuration section.
       
       data division.
       FILE SECTION.
       FD INDEXED-STUDENT-FILE-IN.
       01 INDEXED-FILE-RECORD.
           05 IND-STUDENT-NUMBER  PIC 9(6).
           05 IND-TUITION-OWED    PIC 9(6)V99.
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
       FD PROGRAM-FILE-IN.
       01 COURSE-RECORD.
         05 COURSE-CODE PIC X(5).
         05 COURSE-NAME PIC X(20).
       FD STUDENT-REPORT-OUT.
       01 STUDENT-REPORT-RECORD-OUT PIC X(81).
       
       working-storage section.
       01 STATUS-FIELD PIC X(2).
       01 STUDENT-REPORT-RECORD.
         05 STUDENT-NAME-OUT PIC X(40).
         05 FILLER PIC X(2) VALUE SPACES.
         05 STUDENT-AVERAGE-OUT PIC 9(3).
         05 FILLER PIC X(4) VALUE SPACES.
         05 PROGRAM-NAME-OUT PIC X(20).
         05 FILLER PIC X(4) VALUE SPACES.
         05 TUITION-OWED-OUT PIC Z,ZZ9.99.
       01 COLUMN-HEADER.
         05 FILLER PIC X(12) VALUE "STUDENT NAME".
         05 FILLER PIC X(19) VALUE SPACES.
         05 FILLER PIC X(7) VALUE "AVERAGE".
         05 FILLER PIC X(1) VALUE SPACES.
         05 FILLER PIC X(12) VALUE "PROGRAM NAME".
         05 FILLER PIC X(8) VALUE SPACES.
         05 FILLER PIC X(12) VALUE "TUITION OWED".
       01 FLAG-COUNTERS.
         05 EOF-FLAG PIC X(3) VALUE "NO".
         05 EOF-FLAG-TBL PIC X(3) VALUE "NO".
         05 READ-COUNTER PIC 9(3) VALUE ZERO.
         05 WRITE-COUNTER PIC 9(3) VALUE ZERO.
         05 SUB PIC 9(2).
         05 FOUND-FLAG PIC X(3) VALUE "NO".
       01 PROGRAM-NAMES-RECORDS.
         05 PROGRAM-TBL-RECORD OCCURS 20 TIMES.
           10 PROGRAM-CODE-TBL PIC X(5).
           10 PROGRAM-NAME-TBL PIC X(20).
       

       procedure division.
       100-PRODUCE-STUDENT-REPORTS.
           PERFORM 201-INIT-STUDENT-REPORTS.
           PERFORM 202-PRODUCE-ONE-STUDENT-REPORT
               UNTIL EOF-FLAG = "YES".
           PERFORM 203-TERMINATE-STUDENT-REPORT.
           STOP RUN.
       
       201-INIT-STUDENT-REPORTS.
           PERFORM 301-OPEN-FILES.
           PERFORM 302-LOAD-PROGRAM-TBL
               VARYING SUB FROM 1 BY 1
                UNTIL EOF-FLAG-TBL = "YES"
                OR SUB > 20.
           PERFORM 305-READ-STUDENT-RECORD.
           PERFORM 304-WRITE-COLUMN-HDR.
       
       202-PRODUCE-ONE-STUDENT-REPORT.
           PERFORM 306-CALCULATE-AVERAGE.
           PERFORM 307-SEARCH-PROGRAM-NAME
               VARYING SUB FROM 1 BY 1
                UNTIL SUB > 20 OR FOUND-FLAG = "YES".
           PERFORM 308-WRITE-STUDENT-REPORT.
           PERFORM 305-READ-STUDENT-RECORD.
       
       203-TERMINATE-STUDENT-REPORT.
           PERFORM 309-CLOSE-FILES.
           PERFORM 310-DISPLAY-COUNTERS.
       
       301-OPEN-FILES.
           OPEN INPUT INDEXED-STUDENT-FILE-IN
                      PROGRAM-FILE-IN.
           OPEN OUTPUT STUDENT-REPORT-OUT.
           DISPLAY "OPEN SUCCESS!".
          
       302-LOAD-PROGRAM-TBL.
           READ PROGRAM-FILE-IN
               AT END MOVE "YES" TO EOF-FLAG-TBL
                      NOT AT END MOVE COURSE-RECORD
                                   TO PROGRAM-TBL-RECORD(SUB).
       304-WRITE-COLUMN-HDR.
           WRITE STUDENT-REPORT-RECORD-OUT FROM COLUMN-HEADER.
       
       305-READ-STUDENT-RECORD.
           READ INDEXED-STUDENT-FILE-IN
               AT END MOVE "YES" TO EOF-FLAG
                      NOT AT END ADD 1 TO READ-COUNTER.
       
       306-CALCULATE-AVERAGE.
           COMPUTE STUDENT-AVERAGE-OUT
             = (IND-AVERAGE-1 + IND-AVERAGE-2 + IND-AVERAGE-3 + 
             IND-AVERAGE-4 + IND-AVERAGE-5) / 5.
       
       307-SEARCH-PROGRAM-NAME.
           MOVE "NO" TO FOUND-FLAG.
           IF COURSE-CODE = PROGRAM-CODE-TBL(SUB)
               MOVE "YES" TO FOUND-FLAG
               MOVE PROGRAM-CODE-TBL(SUB) TO PROGRAM-NAME-OUT
           END-IF.
       
       308-WRITE-STUDENT-REPORT.
           MOVE IND-STUDENT-NAME TO STUDENT-NAME-OUT.
           MOVE IND-TUITION-OWED TO TUITION-OWED-OUT.
           WRITE STUDENT-REPORT-RECORD-OUT FROM STUDENT-REPORT-RECORD.
           ADD 1 TO WRITE-COUNTER.
       
       309-CLOSE-FILES.
           CLOSE INDEXED-STUDENT-FILE-IN
                 PROGRAM-FILE-IN
                 STUDENT-REPORT-OUT.
       
       310-DISPLAY-COUNTERS.
           DISPLAY READ-COUNTER WRITE-COUNTER.

       end program Program3.
