-- Zad.1
CREATE TABLE movies AS SELECT * FROM ztpd.movies;

-- Zad.2
DESCRIBE movies;

-- Zad.3
SELECT id, title
FROM movies
WHERE cover IS NULL;

-- Zad.4
SELECT id, title, LENGTH(cover) AS FILESIZE
FROM movies
WHERE cover IS NOT NULL;

-- Zad.5
SELECT id, title, LENGTH(cover) AS FILESIZE
FROM movies
WHERE cover IS NULL;

-- Zad.6
SELECT directory_name, directory_path
FROM ALL_DIRECTORIES;

-- Zad.7
UPDATE movies
SET cover = EMPTY_BLOB(),
    mime_type = 'image/jpeg'
WHERE id = 66;

-- Zad.8
SELECT id, title, LENGTH(cover) AS FILESIZE
FROM movies
WHERE id IN (65, 66);

-- Zad.9
DECLARE
     lobd blob;
     fileb BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
     SELECT cover into lobd from movies
     where id = 66
     FOR UPDATE;
     DBMS_LOB.FILEOPEN(fileb, DBMS_LOB.FILE_READONLY);
     DBMS_LOB.LOADFROMFILE(lobd,fileb,DBMS_LOB.GETLENGTH(fileb));
     DBMS_LOB.FILECLOSE(fileb);
     COMMIT;
END;

-- Zad.10
CREATE TABLE temp_cover (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR(50)
);

-- Zad.11
INSERT INTO temp_cover
VALUES (65, BFILENAME('TPD_DIR','escape.jpg'), 'image/jpeg');

-- Zad.12
SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS FILESIZE
FROM temp_cover;

-- Zad.13
DECLARE
     lobd blob;
     image BFILE;
     mime_type VARCHAR2(50);     
BEGIN
    SELECT mime_type into mime_type from temp_cover;
    SELECT image into image from temp_cover;
    
    DBMS_LOB.CREATETEMPORARY(lobd, TRUE);
    
    DBMS_LOB.FILEOPEN(image, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADFROMFILE(lobd, image, DBMS_LOB.GETLENGTH(image));
    DBMS_LOB.FILECLOSE(image);
    
    UPDATE movies
    SET cover = lobd,
        mime_type = mime_type
    WHERE ID = 65;
    
    DBMS_LOB.FREETEMPORARY(lobd);
    COMMIT;
END;

-- Zad.14
SELECT id AS movie_id, LENGTH(cover) AS FILESIZE
FROM movies
WHERE id IN (65, 66);

-- Zad.15
DROP TABLE movies;