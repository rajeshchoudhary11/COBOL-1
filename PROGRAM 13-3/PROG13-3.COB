 IDENTIFICATION DIVISION.
      *
      *
       PROGRAM-ID.    PROG13-3.
      *AUTHOR.        ERIC.
      *INSTALLATION.   WSC.
      *DATE-WRITTEN.  FEB 26,2003.
      *DATE-COMPILED. FEB 26,2003.
      *SECURITY.      NONE.
      *
      *
      *
      * THIS PROGRAM READS AND INPUT FILE AND SORTS IT GIVING 
      * SORTED-EARNINGS.DAT. THE FILE IS SORTED IN ASCENDING
      * ORDER ON THE PAY-CODE FIELD AND THEN DESCENDING ON THE
      * PAY-RATE AND YEAR-TO-DATE FIELDS. FINALLY IT IS SORTED
      * IN DESCENDING ORDER BASED ON THE EMPLOYEES NAME.
      * SORTED-EARNINGS IS THEN READ IN AND USED TO PRODUCE THE
      * PROG13-3_OUT.DAT REPORT. THIS REPORT CONSISTS OF A
      * PAY-CODE, PAY-RATE, YEAR-TO-DATE EARNINGS, LAST NAME,
      * FIRST NAME, AND MIDDLE INITIAL COLUMNS. AT THE END OF THE
      * TOTAL NUMBER OF SALARY AND HOURLY EMPLOYEES IS LISTED.
      *
      *
      *
       ENVIRONMENT DIVISION.
      *
      *
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
           SELECT EARNINGS-FILE-IN
               ASSIGN TO "EARNINGS.DAT".
           SELECT SORTED-EARNINGS-FILE
               ASSIGN TO "SORTED-EARNINGS.DAT".
           SELECT PAY-REPORT-OUT
               ASSIGN TO "PROG13-3_OUT.DAT".
           SELECT SORT-FILE
               ASSIGN TO "SORT-WORK.DAT".
      *
      *
      *
       DATA DIVISION.
      *
      *
       FILE SECTION.
      *
       FD  EARNINGS-FILE-IN
               RECORD CONTAINS 79 CHARACTERS
               LABEL RECORDS ARE OMITTED
               DATA RECORD IS ER-EARNINGS-REC-IN.
      *
       01  ER-EARNINGS-REC-IN               PIC X(79).
      *
       FD  SORTED-EARNINGS-FILE
               RECORD CONTAINS 79 CHARACTERS
               LABEL RECORDS ARE OMITTED
               DATA RECORD IS SORTED-EARN-REC.
      *
       01  SORTED-EARN-REC             PIC X(79).
      *
       FD  PAY-REPORT-OUT
               RECORD CONTAINS 132 CHARACTERS
               LABEL RECORDS ARE OMITTED
               DATA RECORD IS ER-PAY-REPORT-OUT.
      *
       01  ER-PAY-REPORT-OUT               PIC X(132).
      *
       SD  SORT-FILE 
               DATA RECORD IS SR-SORT-RECORD.
      *
       01  SR-SORT-RECORD.
           05  FILLER                      PIC X(19).
           05  SR-EMPL-LNAME               PIC X(12).
           05  SR-EMPL-FNAME               PIC X(9).
           05  SR-EMPL-MI                  PIC X(1).
           05  FILLER                      PIC X(11).
           05  SR-PAY-CODE                 PIC X.
           05  SR-PAY-RATE                 PIC 9(6).
           05  FILLER                      PIC X(7).
           05  SR-YTD-EARN                 PIC 9(6)V99.
           05  FILLER                      PIC X(5).
      *
      *
       WORKING-STORAGE SECTION.
      *
      *
       01  WS-PAGE-LAYOUT.
           05  WS-PAGE-COUNT               PIC 9(3).
           05  WS-LINES-USED               PIC 99.
           05  WS-SPACING                  PIC 9 VALUE 2.
      *
       01  WS-EOF-SW                       PIC X.
      *
       01  WS-TOTALS.
           05  WS-HOURLY-TOT               PIC 9999.
           05  WS-SALARY-TOT               PIC 9999.
      *
       01  WS-DATE-ACCEPT.
           05  DATE-ACCEPT                  PIC X(6).
           05  DATE-WS REDEFINES DATE-ACCEPT.
               10  WS-YEAR                  PIC X(2).
               10  WS-MONTH                 PIC X(2).
               10  WS-DAY                   PIC X(2).


      *
        01 WS-SORTED-EARN-REC.
           05  FILLER                      PIC X(19).
           05  ER-EMPL-LNAME-IN            PIC X(12).
           05  ER-EMPL-FNAME-IN            PIC X(9).
           05  ER-EMPL-MI-IN               PIC X(1).
           05  FILLER                      PIC X(11).
           05  ER-PAY-CODE-IN              PIC X.
           05  ER-SALARY-RATE              PIC 9(4)V99.
           05  ER-HOURLY-RATE REDEFINES ER-SALARY-RATE
                                           PIC 99V9999.
           05  FILLER                      PIC X(7).
           05  ER-YTD-EARN-IN              PIC 9(6)V99.
           05  FILLER                      PIC X(5).
      *
       01  WS-HEADING.
           05  FILLER                      PIC X(8) VALUE "EARNINGS".
           05  FILLER                      PIC X VALUE SPACE.
           05  FILLER                      PIC X(2) VALUE "BY".
           05  FILLER                      PIC X VALUE SPACE.
           05  FILLER                      PIC X(3) VALUE "PAY".
           05  FILLER                      PIC X VALUE SPACE.
           05  FILLER                      PIC X(4) VALUE "CODE".
           05  FILLER                      PIC X VALUE SPACE.
           05  FILLER                      PIC X(6) VALUE "REPORT".
           05  FILLER                      PIC X VALUE SPACE.
           05  FILLER                      PIC X(6) VALUE "(13-3)".
           05  FILLER                      PIC X(17) VALUE SPACES.
           05  WS-RUN-DATE-OUT.
               10  WS-MONTH-OUT            PIC X(2).
               10  FILLER                  PIC X(1) VALUE "-".
               10  WS-DAY-OUT              PIC X(2).
               10  FILLER                  PIC X(1) VALUE "-".
               10  WS-YEAR-OUT             PIC X(2).
           05  FILLER                      PIC X(3) VALUE SPACES.
           05  FILLER                      PIC X(4) VALUE "PAGE".
           05  FILLER                      PIC X.
           05  WS-PAGE-OUT                 PIC ZZ9.
           05  FILLER                      PIC X(62) VALUE SPACES.
      *
       01  WS-COL-HEADING-01.
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  FILLER                      PIC X VALUE "P".
           05  FILLER                      PIC X(7) VALUE SPACES.
           05  FILLER                      PIC X(3) VALUE "PAY".
           05  FILLER                      PIC X(7) VALUE SPACES.
           05  FILLER                      PIC X(4) VALUE "YEAR".
           05  FILLER                      PIC X(4) VALUE "-TO-".
           05  FILLER                      PIC X(2) VALUE "DT".
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  FILLER                      PIC X(6) VALUE "------".
           05  FILLER                      PIC X(8) VALUE "EMPLOYEE".
           05  FILLER                      PIC X(5) VALUE " NAME".
           05  FILLER                      PIC X(5) VALUE "-----".
           05  FILLER                      PIC X(70) VALUE SPACES.
      *
       01  WS-COL-HEADING-02.
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  FILLER                      PIC X VALUE "C".
           05  FILLER                      PIC X(7) VALUE SPACES.
           05  FILLER                      PIC X(4) VALUE "RATE".
           05  FILLER                      PIC X(7) VALUE SPACES.
           05  FILLER                      PIC X(8) VALUE "EARNINGS".
           05  FILLER                      PIC X(6) VALUE SPACES.
           05  FILLER                      PIC X(4) VALUE "LAST".
           05  FILLER                      PIC X(10) VALUE SPACES.
           05  FILLER                      PIC X(5) VALUE "FIRST".
           05  FILLER                      PIC X(3) VALUE SPACES.
           05  FILLER                      PIC X(2) VALUE "MI".
           05  FILLER                      PIC X(70) VALUE SPACES.
      *
       01 WS-DETAIL-LINE.
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  DL-PAY-CODE-OUT             PIC X.
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  DL-SALARY-OUT               PIC ZZZ9.99.
           05  DL-HOURLY-OUT REDEFINES DL-SALARY-OUT
                                           PIC Z9.9999.
           05  DL-MESSAGE-OUT REDEFINES DL-SALARY-OUT
                                           PIC X(7).
           05  FILLER                      PIC X(3) VALUE SPACES.
           05  DL-YTD-EARN-OUT             PIC Z,ZZZ,ZZ9.99.
           05  FILLER                      PIC X(5) VALUE SPACES.
           05  DL-EMPL-LNAME-OUT           PIC X(12).
           05  FILLER                      PIC X VALUE SPACES.
           05  DL-EMPL-FNAME-OUT           PIC X(9).
           05  FILLER                      PIC X VALUE SPACE.
           05  DL-EMPL-MI-OUT              PIC X.
           05  FILLER                      PIC X(70) VALUE SPACES.
      *
       01  WS-TOTAL-LINE-01.
           05  FILLER                      PIC X(47) VALUE SPACES.
           05  FILLER                      PIC X(6) VALUE "HOURLY".
           05  FILLER                      PIC X(1) VALUE SPACE.
           05  FILLER                      PIC X(9) VALUE "EMPLOYEES".
           05  FILLER                      PIC X(2) VALUE SPACES.
           05  WS-TOT-HOURLY-OUT           PIC Z,ZZ9.
           05  FILLER                      PIC X(62) VALUE SPACES.
      *
       01  WS-TOTAL-LINE-02.
           05  FILLER                      PIC X(45) VALUE SPACES.
           05  FILLER                      PIC X(8) VALUE "SALARIED".
           05  FILLER                      PIC X VALUE SPACE.
           05  FILLER                      PIC X(9) VALUE "EMPLOYEES".
           05  FILLER                      PIC X(2) VALUE SPACES.
           05  WS-TOT-SALARY-OUT           PIC Z,ZZ9.
           05  FILLER                      PIC X(62) VALUE SPACES.
      *
      *
      *
       PROCEDURE DIVISION.
      *
      *
       A00-MAINLINE-PARA.
           PERFORM B30-SORT-PARA.
           OPEN INPUT  SORTED-EARNINGS-FILE
                OUTPUT PAY-REPORT-OUT.
           PERFORM B10-INIT-PARA.
           PERFORM B20-PROCESS-PARA
               UNTIL WS-EOF-SW = "Y".
           PERFORM C20-TOTALS-PARA.
           CLOSE SORTED-EARNINGS-FILE
                 PAY-REPORT-OUT.
           STOP RUN.
      *
      *
       B10-INIT-PARA.
           MOVE ZERO TO WS-LINES-USED
                        WS-HOURLY-TOT
                        WS-SALARY-TOT.
           MOVE 1 TO WS-PAGE-COUNT.
           ACCEPT DATE-ACCEPT FROM DATE.
           MOVE WS-MONTH TO WS-MONTH-OUT
           MOVE WS-DAY TO WS-DAY-OUT
           MOVE WS-YEAR TO WS-YEAR-OUT.
           READ SORTED-EARNINGS-FILE INTO WS-SORTED-EARN-REC
               AT END MOVE "Y" TO WS-EOF-SW.
           PERFORM C10-HEADINGS-PARA.
      *
      *
       B20-PROCESS-PARA.
           IF ER-PAY-CODE-IN = SPACES THEN
               ADD 1 TO WS-SALARY-TOT
               MOVE ER-SALARY-RATE TO DL-SALARY-OUT
           ELSE IF ER-PAY-CODE-IN = "H" THEN
               ADD 1 TO WS-HOURLY-TOT
               MOVE ER-HOURLY-RATE TO DL-HOURLY-OUT
           ELSE
               MOVE "*ERROR*" TO DL-MESSAGE-OUT
           END-IF.


           IF ER-PAY-CODE-IN = SPACES THEN
               MOVE "S" TO DL-PAY-CODE-OUT
           ELSE
               MOVE ER-PAY-CODE-IN TO DL-PAY-CODE-OUT
           END-IF.
           MOVE ER-YTD-EARN-IN TO DL-YTD-EARN-OUT.
           MOVE ER-EMPL-LNAME-IN TO DL-EMPL-LNAME-OUT.
           MOVE ER-EMPL-FNAME-IN TO DL-EMPL-FNAME-OUT.
           MOVE ER-EMPL-MI-IN TO DL-EMPL-MI-OUT.


           IF WS-LINES-USED >= 57 THEN
               MOVE ZEROS TO WS-LINES-USED
               PERFORM C10-HEADINGS-PARA
           END-IF.


           WRITE ER-PAY-REPORT-OUT FROM WS-DETAIL-LINE
               AFTER ADVANCING  1 LINE.
           ADD 1 TO WS-LINES-USED.
           READ SORTED-EARNINGS-FILE INTO WS-SORTED-EARN-REC
               AT END MOVE "Y" TO WS-EOF-SW.
      *
      *
       B30-SORT-PARA.
            SORT SORT-FILE
                ASCENDING KEY SR-PAY-CODE
                DESCENDING KEY SR-PAY-RATE
                DESCENDING KEY SR-YTD-EARN
                ASCENDING KEY SR-EMPL-LNAME
                              SR-EMPL-FNAME
                              SR-EMPL-MI
                    USING EARNINGS-FILE-IN
                    GIVING SORTED-EARNINGS-FILE.
      *
      *
       C10-HEADINGS-PARA.
           MOVE WS-PAGE-COUNT TO WS-PAGE-OUT.
           WRITE ER-PAY-REPORT-OUT FROM WS-HEADING
               AFTER ADVANCING PAGE.
           MOVE SPACES TO ER-PAY-REPORT-OUT.
           WRITE ER-PAY-REPORT-OUT
               AFTER ADVANCING 1 LINE.
           WRITE ER-PAY-REPORT-OUT FROM WS-COL-HEADING-01
               AFTER ADVANCING 1 LINE.
           WRITE ER-PAY-REPORT-OUT FROM WS-COL-HEADING-02
               AFTER ADVANCING 1 LINE.
           MOVE SPACES TO ER-PAY-REPORT-OUT.
           WRITE ER-PAY-REPORT-OUT
               AFTER ADVANCING 1 LINE.
           ADD 5 TO WS-LINES-USED.
           ADD 1 TO WS-PAGE-COUNT.
      *
      *
       C20-TOTALS-PARA.
           MOVE SPACES TO ER-PAY-REPORT-OUT.
           MOVE WS-HOURLY-TOT TO WS-TOT-HOURLY-OUT.
           MOVE WS-SALARY-TOT TO WS-TOT-SALARY-OUT.
           WRITE ER-PAY-REPORT-OUT
               AFTER ADVANCING 1 LINE.
           WRITE ER-PAY-REPORT-OUT FROM WS-TOTAL-LINE-01
               AFTER ADVANCING 1 LINE.
           WRITE ER-PAY-REPORT-OUT FROM WS-TOTAL-LINE-02
               AFTER ADVANCING 1 LINE. 