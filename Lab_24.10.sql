-- 1.
CREATE TABLE DOKUMENTY (
    id NUMBER(12) PRIMARY KEY,
    dokument CLOB
);

-- 2.
DECLARE
   longtext CLOB := '';
   i INT;
BEGIN
    FOR i IN 1..10000 LOOP
        longtext := longtext || 'Oto tekst. ';
    END LOOP;
    
    INSERT INTO DOKUMENTY VALUES(1, longtext);
END;

-- 3.
SELECT * FROM DOKUMENTY;
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
SELECT DBMS_LOB.SUBSTR(DOKUMENT, 1000, 5) FROM DOKUMENTY;

-- 4.
INSERT INTO DOKUMENTY VALUES(2, EMPTY_CLOB());

-- 5.
INSERT INTO DOKUMENTY VALUES(3, NULL);

-- 6. Wywołanie funkcji z punktu 3.
-- 7.
DECLARE
    lobd clob;
    fils BFILE := BFILENAME('TPD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT DOKUMENT INTO lobd
    FROM DOKUMENTY
    where id=2
    FOR UPDATE;
    
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd,fils,DBMS_LOB.LOBMAXSIZE, doffset, soffset, 873, langctx, WARN);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

-- 8.
UPDATE DOKUMENTY SET DOKUMENT=TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'), 873, 'text/xml') WHERE id=3;

-- 9.
SELECT * FROM DOKUMENTY;

-- 10.
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

-- 11.
DROP TABLE DOKUMENTY;

-- 12.
CREATE OR REPLACE PROCEDURE CLOB_CENSOR (
    clob_in IN OUT CLOB,
    text_to_censor IN VARCHAR2
) AS
    pos INT;
    text_length INT := LENGTH(text_to_censor);
    dots VARCHAR2(100);
BEGIN
    dots := LPAD('.', text_length, '.');
    pos := DBMS_LOB.INSTR(clob_in, text_to_censor, 1);
    DBMS_OUTPUT.PUT_LINE(text_length);
    DBMS_OUTPUT.PUT_LINE(pos);
    DBMS_OUTPUT.PUT_LINE(dots);
    WHILE pos > 0 LOOP
        DBMS_LOB.WRITE(clob_in, text_length, pos, dots);
        pos := DBMS_LOB.INSTR(clob_in, text_to_censor, pos + text_length);
    END LOOP;
END;

-- 13.
CREATE TABLE BIOGRAPHIES AS SELECT * FROM ZTPD.BIOGRAPHIES;
SELECT id, person, bio FROM BIOGRAPHIES;
DECLARE
    clobd CLOB;
BEGIN
    SELECT BIO INTO clobd FROM BIOGRAPHIES WHERE id = 1 FOR UPDATE;
    CLOB_CENSOR(clobd, 'Cimrman');
    UPDATE BIOGRAPHIES SET BIO = clobd WHERE id = 1;
END;

-- 14.
DROP TABLE BIOGRAPHIES;
