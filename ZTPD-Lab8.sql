-- Operator CONTAINS - Podstawy
-- Zad.1
CREATE TABLE CYTATY AS SELECT * FROM ztpd.cytaty;
SELECT * FROM CYTATY;

-- Zad.2
SELECT AUTOR, TEKST
FROM CYTATY
WHERE LOWER(TEKST) LIKE '%pesymista%'
AND LOWER(TEKST) LIKE '%optymista%';

-- Zad.3
CREATE INDEX TEKST_IDX
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Zad.4
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'pesymista AND optymista', 1) > 0;

-- Zad.5
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'pesymista ~ optymista', 1) > 0;

-- Zad.6
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((pesymista, optymista), 3)') > 0;

-- Zad.7
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'NEAR((pesymista, optymista), 10)') > 0;

-- Zad.8
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1) > 0;

-- Zad.9
SELECT AUTOR, TEKST, SCORE(1) AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1) > 0;

-- Zad.10
SELECT AUTOR, TEKST, SCORE(1) AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%', 1) > 0
AND ROWNUM <= 1
ORDER BY DOPASOWANIE DESC;

-- Zad.11
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'FUZZY(probelm,,,N)', 1) > 0;

-- Zad.12
INSERT INTO CYTATY VALUES(
    39,
    'Bertrand Russell',
    'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.'
);
COMMIT;

-- Zad.13
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy', 1) > 0; -- Indeks nie odświeża się automatycznie.

-- Zad.14
SELECT TOKEN_TEXT
FROM DR$TEKST_IDX$I
WHERE TOKEN_TEXT = 'głupcy';

-- Zad.15
DROP INDEX TEKST_IDX;

CREATE INDEX TEKST_IDX
ON CYTATY(TEKST)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Zad.16
SELECT AUTOR, TEKST
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy', 1) > 0; -- Słowo 'głupcy' znajduje się teraz w indeksie.

-- Zad.17
DROP INDEX TEKST_IDX;
DROP TABLE CYTATY;


-- Zaawansowane indeksowanie i wyszukiwanie
-- Zad.1
CREATE TABLE QUOTES AS SELECT * FROM ztpd.quotes;
SELECT * FROM QUOTES;

-- Zad.2
CREATE INDEX TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Zad.3
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'work', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '$work', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'working', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '$working', 1) > 0;

-- Zad.4
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1) > 0; 
-- 'it' jest słowem wyłączonym domyślnie, więc brak wyniku.

-- Zad.5
SELECT * FROM CTX_STOPLISTS; -- Podejrzewam, że default_stoplist.

-- Zad.6
SELECT * FROM CTX_STOPWORDS;

-- Zad.7
DROP INDEX TEXT_IDX;

CREATE INDEX TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- Zad.8
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'it', 1) > 0; 
-- Tym razem zostały zwrócone wyniki.

-- Zad.9
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND humans', 1) > 0;

-- Zad.10
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool AND computer', 1) > 0;

-- Zad.11
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;

-- BŁĄD: Sekcja SENTENCE nie istnieje.

-- Zad.12
DROP INDEX TEXT_IDX;

-- Zad.13
BEGIN
    CTX_DDL.CREATE_SECTION_GROUP('newgroup', 'NULL_SECTION_GROUP');
    CTX_DDL.ADD_SPECIAL_SECTION('newgroup',  'SENTENCE');
    CTX_DDL.ADD_SPECIAL_SECTION('newgroup',  'PARAGRAPH');
END;

-- Zad.14
CREATE INDEX TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group newgroup');

-- Zad.15
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;

SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool AND computer) WITHIN SENTENCE', 1) > 0;

-- Zad.16
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1) > 0;

-- Zwrócono też wyniki dla non-humans, bo domyślnie lekser rozbija słowa rozdzielone '-' na osobne tokeny.

-- Zad.17
DROP INDEX TEXT_IDX;

BEGIN
    CTX_DDL.CREATE_PREFERENCE('lekser','BASIC_LEXER');
    CTX_DDL.SET_ATTRIBUTE('lekser', 'printjoins', '-');
    CTX_DDL.SET_ATTRIBUTE('lekser', 'index_text', 'YES');
END;

CREATE INDEX TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('
    stoplist CTXSYS.EMPTY_STOPLIST
    section group newgroup
    LEXER lekser');
    
-- Zad.18
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans', 1) > 0;

-- Tym razem otrzymano poprawne wyniki (bez non-humans).

-- Zad.19
SELECT AUTHOR, TEXT
FROM QUOTES
WHERE CONTAINS(TEXT, 'non\-humans', 1) > 0;

-- Zad.20
DROP TABLE QUOTES;

BEGIN
    CTX_DDL.DROP_SECTION_GROUP('newgroup');
    CTX_DDL.DROP_PREFERENCE('lekser');
END;
