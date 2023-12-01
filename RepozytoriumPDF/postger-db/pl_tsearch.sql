-- Stworzenie słownika tsearch dla języka polskiego (odpalić na bazie postgress)

CREATE TEXT SEARCH CONFIGURATION public.polish ( COPY = pg_catalog.english );

CREATE TEXT SEARCH DICTIONARY polish_ispell (
    TEMPLATE = ispell,
    DictFile = polish,
    AffFile = polish,
    StopWords = polish
);

ALTER TEXT SEARCH CONFIGURATION polish
ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part
WITH polish_ispell;