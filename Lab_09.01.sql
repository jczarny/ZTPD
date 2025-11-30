-- Operator CONTAINS - Podstawy
-- 1.
CREATE TABLE CYTATY AS
SELECT * FROM ZTPD.CYTATY;

-- 2.
SELECT * FROM CYTATY
WHERE LOWER(TEKST) LIKE '%optymista%' AND LOWER(TEKST) LIKE '%pesymista%';

-- 3.
CREATE INDEX CYTATY_IDX on CYTATY(TEKST) indextype is CTXSYS.CONTEXT;

-- 4.
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'optymista AND pesymista') > 0;

-- 5.
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'pesymista NOT optymista') > 0;

-- 6.
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'near((optymista, pesymista), 3)') > 0;

-- 7.
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'near((optymista, pesymista), 10)') > 0;

-- 8.
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'życi%') > 0;

-- 9.
SELECT C.*, SCORE(1) RANK FROM CYTATY C WHERE CONTAINS(C.TEKST, 'życi%', 1) > 0;

-- 10.
SELECT C.*, SCORE(1) RANK 
FROM CYTATY C 
WHERE CONTAINS(C.TEKST, 'życi%', 1) > 0 
ORDER BY RANK desc 
FETCH FIRST 1 ROW ONLY;

-- 11.
SELECT C.*, SCORE(1) RANK FROM CYTATY C WHERE CONTAINS(C.TEKST, 'FUZZY(probelm)', 1) > 0;

-- 12.
INSERT INTO CYTATY
VALUES (39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni
siebie, a ludzie rozsądni tacy pełni wątpliwości.');
commit;

-- 13.
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'głupcy', 1) > 0;
-- Nie odszukuje cytatu Bertranda Russella z powodu nieodświeżenia indeksu na kolumnie TEKSTY

-- 14.
SELECT *
FROM DR$CYTATY_IDX$I
where lower(TOKEN_TEXT) = 'głupcy';

-- 15. 16.
DROP INDEX CYTATY_IDX;
CREATE INDEX CYTATY_IDX on CYTATY(TEKST) indextype is CTXSYS.CONTEXT;
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'głupcy', 1) > 0;

-- 17.
DROP INDEX CYTATY_IDX;
DROP TABLE CYTATY;

-- Zaawansowane indeksowanie i wyszukiwanie
-- 1.
CREATE TABLE QUOTES AS
SELECT * FROM ZTPD.QUOTES;

-- 2.
CREATE INDEX QUOTES_IDX on QUOTES(TEXT) indextype is CTXSYS.CONTEXT;

-- 3.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, 'work', 1) > 0;
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, '$work', 1) > 0;
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, 'working', 1) > 0;
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, '$working', 1) > 0;

-- 4.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, 'it', 1) > 0;

-- 5.
SELECT * FROM CTX_STOPLISTS;

-- 6.
SELECT * FROM CTX_STOPWORDS;

-- 7.
DROP INDEX QUOTES_IDX;
CREATE INDEX QUOTES_IDX ON QUOTES(TEXT) indextype is CTXSYS.CONTEXT PARAMETERS('STOPLIST CTXSYS.EMPTY_STOPLIST');

-- 8.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, 'it', 1) > 0;

-- 9.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, 'fool and humans', 1) > 0;

-- 10.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, 'fool and computer', 1) > 0;

-- 11.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT,'(fool AND humans) WITHIN SENTENCE',1) > 0;

-- 12.
DROP INDEX QUOTES_IDX;

-- 13.
begin
 ctx_ddl.create_section_group('QUOTES_SECTION_GROUP', 'NULL_SECTION_GROUP');
 ctx_ddl.add_special_section('QUOTES_SECTION_GROUP', 'SENTENCE');
 ctx_ddl.add_special_section('QUOTES_SECTION_GROUP', 'PARAGRAPH');
end;

-- 14.
CREATE INDEX QUOTES_IDX ON QUOTES(TEXT) indextype is CTXSYS.CONTEXT PARAMETERS('SECTION GROUP QUOTES_SECTION_GROUP');

-- 15.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT,'(fool AND humans) WITHIN SENTENCE',1) > 0;
SELECT * FROM QUOTES WHERE CONTAINS(TEXT,'(fool AND computer) WITHIN SENTENCE',1) > 0;

-- 16.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT,'humans',1) > 0;

-- 17.
DROP INDEX QUOTES_IDX;

begin
 ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
 ctx_ddl.set_attribute('lex_z_m', 'printjoins', '-');
 ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
end;

CREATE INDEX QUOTES_IDX ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS('LEXER lex_z_m');

-- 18.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT,'humans',1) > 0;

-- 19.
SELECT * FROM QUOTES WHERE CONTAINS(TEXT,'non\-humans',1) > 0;

-- 20.
BEGIN
    CTX_DDL.DROP_PREFERENCE('lex_z_m');
END;
DROP TABLE QUOTES;