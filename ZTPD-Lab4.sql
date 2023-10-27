-- Ćwiczenie A
CREATE TABLE FIGURY(
    ID NUMBER(1) PRIMARY KEY,
    KSZTALT MDSYS.SDO_GEOMETRY
);

-- Ćwiczenie B
INSERT INTO FIGURY VALUES(
    1,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1,1003,4),
        SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5)
    )
);

INSERT INTO FIGURY VALUES(
    2,
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL, 
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);	
						
INSERT INTO FIGURY VALUES(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
        SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)
    )
);

-- Ćwiczenie C
INSERT INTO FIGURY VALUES(
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        SDO_ORDINATE_ARRAY(1, 1, 2, 2, 3, 3, 4, 4)
    )
);

-- Ćwiczenie D
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01)
FROM FIGURY;

-- Ćwiczenie E
DELETE FROM FIGURY
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01) <> 'TRUE';

-- Ćwiczenie F
COMMIT;
