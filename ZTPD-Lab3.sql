-- Zad.1
CREATE TABLE DOKUMENTY (
    id NUMBER(12) PRIMARY KEY,
    dokument CLOB
);

-- Zad.2
DECLARE 
    oto_text CLOB;
BEGIN
    FOR i in 1..1000
    LOOP
        oto_text := CONCAT(oto_text, 'Oto tekst ');
    END LOOP;
    
    INSERT INTO DOKUMENTY 
    VALUES(1, oto_text);
END;

-- Zad.3
SELECT * FROM DOKUMENTY;

SELECT ID, UPPER(dokument) 
FROM DOKUMENTY;

SELECT LENGTH(dokument) 
FROM DOKUMENTY;

SELECT DBMS_LOB.GETLENGTH(dokument) 
FROM DOKUMENTY;

SELECT SUBSTR(dokument, 5, 1000) 
FROM DOKUMENTY;

SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) 
FROM DOKUMENTY;

-- Zad.4
INSERT INTO DOKUMENTY 
VALUES(2, EMPTY_CLOB());

-- Zad.5
INSERT INTO DOKUMENTY
VALUES (3, NULL);
COMMIT;

-- Zad.6
SELECT * FROM DOKUMENTY;

SELECT ID, UPPER(dokument) 
FROM DOKUMENTY;

SELECT LENGTH(dokument) 
FROM DOKUMENTY;

SELECT DBMS_LOB.GETLENGTH(dokument) 
FROM DOKUMENTY;

SELECT SUBSTR(dokument, 5, 1000) 
FROM DOKUMENTY;

SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) 
FROM DOKUMENTY;

-- Zad.7
SET SERVEROUTPUT ON;
DECLARE
     lobd CLOB;
     fils BFILE := BFILENAME('TPD_DIR','dokument.txt');
     doffset INTEGER := 1;
     soffset INTEGER := 1;
     langctx INTEGER := 0;
     warn INTEGER := null;
BEGIN
     SELECT dokument INTO lobd FROM dokumenty
     WHERE id=2 FOR UPDATE;
     
     DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
     DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 0, langctx, warn);
     DBMS_LOB.FILECLOSE(fils);
     
     COMMIT;
     
     DBMS_OUTPUT.PUT_LINE('Status operacji: ' || warn);
END;

-- Zad.8
UPDATE dokumenty
SET dokument = TO_CLOB(BFILENAME('TPD_DIR','dokument.txt'))
WHERE id = 3;

-- Zad.9
SELECT * FROM DOKUMENTY;

-- Zad.10
SELECT DBMS_LOB.GETLENGTH(dokument) 
FROM DOKUMENTY;

-- Zad.11
DROP TABLE DOKUMENTY;

-- Zad.12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    lobd IN OUT CLOB,
    target_txt VARCHAR2
)
IS
    dots VARCHAR2(50);
    pos INTEGER;
BEGIN
    FOR i IN 1..LENGTH(target_txt) LOOP
        dots := dots || '.';
    END LOOP;

    LOOP
        pos := DBMS_LOB.INSTR(lobd, target_txt, 1, 1);
        EXIT WHEN pos = 0;
        DBMS_LOB.WRITE(lobd, LENGTH(target_txt), pos, dots);
    END LOOP;
END CLOB_CENSOR;

-- Zad.13
CREATE TABLE BIOGRAPHIES AS SELECT * FROM ztpd.biographies;

DECLARE
    lobd CLOB;
BEGIN
    SELECT bio INTO lobd FROM BIOGRAPHIES
    WHERE id = 1 FOR UPDATE;
    
    CLOB_CENSOR(lobd, 'Cimrman');
    
    COMMIT;
    SELECT bio FROM BIOGRAPHIES;
END;

-- Zad.14
DROP TABLE BIOGRAPHIES;