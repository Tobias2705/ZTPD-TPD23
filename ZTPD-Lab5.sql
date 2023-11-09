-- Æwiczenie 1A
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 10, 0.01)
    ),
    NULL
);

-- Æwiczenie 1B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0)
FROM FIGURY
WHERE ROWNUM <= 1;

-- Æwiczenie 1C
CREATE INDEX figures_idx
ON FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- Æwiczenie 1D
SELECT ID
FROM FIGURY
WHERE
    SDO_FILTER(
        KSZTALT,
        SDO_GEOMETRY(
            2001,
            NULL,
            SDO_POINT_TYPE(3,3, NULL),
            NULL, 
            NULL
        )
    ) = 'TRUE';
-- Odp: Nie odpowiada rzeczywistoœci, poniewa¿ tylko 2 figura zawiera ten punkt.

-- Æwiczenie 1E
SELECT ID
FROM FIGURY
WHERE
    SDO_RELATE(
        KSZTALT,
        SDO_GEOMETRY(
            2001,
            NULL,
            SDO_POINT_TYPE(3,3, NULL),
            NULL,
            NULL
        ),
        'mask=ANYINTERACT'
    ) = 'TRUE';
-- Odp: Teraz wynik jest zgodny z rzeczywistoœci¹.

-- Æwiczenie 2A
SELECT M1.CITY_NAME AS MIASTO, SDO_NN_DISTANCE(1) AS ODL
FROM MAJOR_CITIES M1, MAJOR_CITIES M2
WHERE SDO_NN(
        M1.GEOM,
        M2.GEOM,
        'sdo_num_res=10 unit=km',
        1
    ) = 'TRUE'
    AND M1.CITY_NAME <> 'Warsaw'
    AND M2.CITY_NAME = 'Warsaw'
ORDER BY ODL;

-- Æwiczenie 2B
SELECT M1.CITY_NAME AS MIASTO
FROM MAJOR_CITIES M1, MAJOR_CITIES M2
WHERE SDO_WITHIN_DISTANCE(
        M1.GEOM,
        M2.GEOM,
        'distance=100 unit=km'
    ) = 'TRUE'
    AND M1.CITY_NAME <> 'Warsaw'
    AND M2.CITY_NAME = 'Warsaw';
    
-- Æwiczenie 2C
SELECT C.CNTRY_NAME AS KRAJ, M.CITY_NAME AS MIASTO
FROM COUNTRY_BOUNDARIES C, MAJOR_CITIES M
WHERE
    SDO_RELATE(M.GEOM, C.GEOM, 'mask=INSIDE') = 'TRUE'
    AND C.CNTRY_NAME = 'Slovakia';
    
-- Æwiczenie 2D
SELECT C1.CNTRY_NAME AS PANSTWO, SDO_GEOM.SDO_DISTANCE(C1.GEOM, C2.GEOM, 1, 'unit=km') AS ODL
FROM COUNTRY_BOUNDARIES C1, COUNTRY_BOUNDARIES C2
WHERE
    SDO_RELATE(
        C1.GEOM,
        C2.GEOM,
        'mask=ANYINTERACT'
    ) != 'TRUE'
    AND C2.CNTRY_NAME = 'Poland';
    
-- Æwiczenie 3A
SELECT C1.CNTRY_NAME AS PANSTWO, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(C1.GEOM, C2.GEOM, 1), 1, 'unit=km') AS ODLEGLOSC
FROM COUNTRY_BOUNDARIES C1, COUNTRY_BOUNDARIES C2
WHERE SDO_FILTER(C1.GEOM, C2.GEOM) = 'TRUE' 
AND C2.CNTRY_NAME = 'Poland';

-- Æwiczenie 3B
SELECT CNTRY_NAME AS PANSTWO
FROM COUNTRY_BOUNDARIES
WHERE SDO_GEOM.SDO_AREA(GEOM) = (
    SELECT MAX(SDO_GEOM.SDO_AREA(GEOM))
    FROM COUNTRY_BOUNDARIES);
    
-- Æwiczenie 3C
SELECT
    SDO_GEOM.SDO_AREA(
        SDO_GEOM.SDO_MBR(
            SDO_GEOM.SDO_UNION(
                M1.GEOM,
                M2.GEOM,
                0.01
            )
        ), 1, 'unit=SQ_KM'
    ) AS SQ_KM
FROM MAJOR_CITIES M1, MAJOR_CITIES M2
WHERE M1.CITY_NAME = 'Lodz' 
AND M2.CITY_NAME = 'Warsaw';

-- Æwiczenie 3D
SELECT
    SDO_GEOM.SDO_UNION(C.GEOM, M.GEOM, 0.01).GET_DIMS() ||
    SDO_GEOM.SDO_UNION(C.GEOM, M.GEOM, 0.01).GET_LRS_DIM() ||
    SDO_GEOM.SDO_UNION(C.GEOM, M.GEOM, 0.01).GET_GTYPE() AS GTYPE
FROM COUNTRY_BOUNDARIES C, MAJOR_CITIES M
WHERE C.CNTRY_NAME = 'Poland'
AND M.CITY_NAME = 'Prague';

-- Æwiczenie 3E
SELECT M.CITY_NAME, C.CNTRY_NAME
FROM COUNTRY_BOUNDARIES C, MAJOR_CITIES M
WHERE
    C.CNTRY_NAME = M.CNTRY_NAME
    AND SDO_GEOM.SDO_DISTANCE(
        SDO_GEOM.SDO_CENTROID(C.GEOM, 1), M.GEOM, 1) = (
            SELECT
                MIN(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(C.GEOM, 1), M.GEOM, 1))
            FROM COUNTRY_BOUNDARIES C, MAJOR_CITIES M
            WHERE C.CNTRY_NAME = M.CNTRY_NAME
        );

-- Æwiczenie 3F
SELECT NAME, SUM(DLUGOSC) AS DLUGOSC
FROM (
    SELECT
        R.NAME,
        SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(C.GEOM, R.GEOM, 1), 1, 'unit=KM') AS DLUGOSC
    FROM COUNTRY_BOUNDARIES C, RIVERS R
    WHERE
        SDO_RELATE(
            C.GEOM,
            R.GEOM,
            'mask=ANYINTERACT'
        ) = 'TRUE'
        AND C.CNTRY_NAME = 'Poland')
GROUP BY NAME;