CLASS src.URL:

    DEFINE PROPERTY URI      AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY protocol AS CHARACTER    NO-UNDO INITIAL 'http:' GET.   PRIVATE SET. 
    DEFINE PROPERTY hostname AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY port     AS INTEGER      NO-UNDO INITIAL 80 GET.        PRIVATE SET. 
    DEFINE PROPERTY path     AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY search   AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY query    AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY fragment AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY UserInfo AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 
    DEFINE PROPERTY FILENAME AS CHARACTER    NO-UNDO GET.                   PRIVATE SET. 

    CONSTRUCTOR URL(INPUT pchURL AS CHARACTER):
       
        THIS-OBJECT:URI = pchURL.

        DEFINE VARIABLE chTempURL       AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE inPathIndex      AS INTEGER     NO-UNDO.
        
        chTempURL = pchURL.

        /** Starting from left to right. Get the Protocol first if it exists. **/
        IF INDEX(chTempURL,'//') GT 0 THEN
        DO:
            THIS-OBJECT:protocol = SUBSTRING(chTempURL, 1, INDEX(chTempURL,'//') - 1 ).
            
            /** If the protcol is I dentifiedable then assign the port number **/
            CASE THIS-OBJECT:protocol:
                WHEN 'http:':U THEN    
                    THIS-OBJECT:PORT = 80.
                WHEN 'https:':U THEN    
                    THIS-OBJECT:PORT = 443.
                WHEN 'ftp:':U THEN    
                    THIS-OBJECT:PORT = 21.
                WHEN 'sftp:':U THEN    
                    THIS-OBJECT:PORT = 115.
                WHEN 'sftp:':U THEN    
                    THIS-OBJECT:PORT = 115.
            END CASE.

            chTempURL = SUBSTRING(chTempURL, INDEX(chTempURL,'//') + 2 ).
        END.
        
        /** Extract and Detach the userinfo if it exists.. **/
        IF R-INDEX(chTempURL,'@') GT 0 THEN
        DO:
            THIS-OBJECT:USERINFO = SUBSTRING(chTempURL, 1,  R-INDEX(chTempURL,'@') - 1 ).
            chTempURL = SUBSTRING(chTempURL, R-INDEX(chTempURL,'@') + 1 ).
        END.

        /** Work throught the URL string from right to left..**/

        /** Detach fragment String. **/
        IF LOGICAL( R-INDEX(chTempURL,'#') ) THEN
        DO:
            THIS-OBJECT:fragment = SUBSTRING(chTempURL, R-INDEX(chTempURL,'#') + 1 ).
            chTempURL = SUBSTRING(chTempURL, 1, R-INDEX(chTempURL,'#') - 1  ).
        END.
        
        /** Detach the Query String. **/
        IF LOGICAL( R-INDEX(chTempURL,'?') ) THEN
        DO:
            THIS-OBJECT:Query = SUBSTRING(chTempURL, R-INDEX(chTempURL,'?') + 1 ).
            chTempURL = SUBSTRING(chTempURL, 1,  R-INDEX(chTempURL,'?') - 1 ).
        END.
        
        /** Extract and Detach path name **/
        IF LOGICAL( R-INDEX(chTempURL,'/') ) THEN
        DO:
            inPathIndex = R-INDEX(chTempURL,'/').

            THIS-OBJECT:FILENAME = SUBSTRING(chTempURL, inPathIndex + 1).

            DO WHILE inPathIndex GT 0:
                THIS-OBJECT:path = SUBSTRING(chTempURL, inPathIndex).
                inPathIndex = R-INDEX(chTempURL,'/', (inPathIndex - 1) ).
            END.
            
            chTempURL = SUBSTRING(chTempURL, 1, INDEX(chTempURL,'/') - 1  ).
        END.

        /** Extract and Detach the Port Number if it exists. **/
        IF R-INDEX(chTempURL,':') GT 0 THEN
        DO:
            THIS-OBJECT:PORT = INTEGER(SUBSTRING(chTempURL, R-INDEX(chTempURL,':') + 1 )).
            chTempURL = SUBSTRING(chTempURL, 1,  R-INDEX(chTempURL,':') - 1 ).
        END.

        /** What ever is left over should be the hostname (FQDN)**/
        THIS-OBJECT:hostname = chTempURL.

    END CONSTRUCTOR.
END CLASS.

