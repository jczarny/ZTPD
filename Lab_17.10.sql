-- 1. 
CREATE TABLE MOVIES AS SELECT * FROM ZTPD.MOVIES;

-- 2. 
SELECT * FROM MOVIES;

-- 3. 
SELECT id, title FROM MOVIES WHERE cover IS NULL;

-- 4. 
SELECT id, title, LENGTH(cover) AS filesize FROM MOVIES WHERE cover IS NOT NULL;

-- 5. 
SELECT id, title, LENGTH(cover) AS filesize FROM MOVIES WHERE cover IS NULL;

-- 6.
SELECT directory_name, directory_path FROM ALL_DIRECTORIES

-- 7.
sql
UPDATE MOVIES SET cover = EMPTY_BLOB(), mime_type = 'image/jpeg' WHERE id=66;
Commit;

-- 8. 
SELECT id, title, LENGTH(cover) AS filesize FROM MOVIES WHERE id=65 or id=66;

-- 9.
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
    SELECT cover INTO lobd
    FROM MOVIES
    where id=66
    FOR UPDATE;
    
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

-- 10.
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- 11.
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('TPD_DIR','eagles.jpg');
BEGIN
    INSERT INTO TEMP_COVERS VALUES (65, fils, 'image/jpeg');
    COMMIT;
END;

-- 12. 
SELECT MOVIE_ID, DBMS_LOB.GETLENGTH(image) as FILESIZE FROM TEMP_COVERS;

-- 13.
DECLARE
    lobd blob;
    fils BFILE;
    m_type VARCHAR2(50);
BEGIN
    SELECT image, mime_type INTO fils, m_type
    FROM TEMP_COVERS
    WHERE movie_id=65
    FOR UPDATE;
    
    dbms_lob.createtemporary(lobd, TRUE);
    
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    
    UPDATE MOVIES SET mime_type = m_type WHERE id=65;
    
    dbms_lob.freetemporary(lobd);
    COMMIT;
END;

-- 14. 
SELECT id as movie_id, DBMS_LOB.GETLENGTH(cover) as FILESIZE FROM MOVIES Where id = 65 or id = 66;

-- 15. DROP TABLE movies;
