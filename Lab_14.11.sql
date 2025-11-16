-- 1.A
SELECT * FROM USER_SDO_GEOM_METADATA;
DELETE FROM USER_SDO_GEOM_METADATA;
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 1, 8, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 1, 7, 0.01)
    ),
    NULL
);

-- 1.B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0) from DUAL;

-- 1.C
CREATE INDEX FIGURY_IDX
ON FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

/* 1.D
    SDO_FILTER wykorzystuje jedynie filtr podstawowy, który jest mniej precyzyjny niż filtr dokładny. 
    Jest on użyteczny przykładowo w sytuacji gdy SDO_FILTER zwróci zbiór pusty, ponieważ wtedy wiemy, 
    że filtr dokładny również zwróci zbiór pusty, ponieważ wynik operacji SDO_FILTER jest nadzbiorem operacji SDO_RELATE.
*/
select ID
from FIGURY
where SDO_FILTER(KSZTALT, SDO_GEOMETRY(2001, null, SDO_POINT_TYPE(3,3,null), null, null)) = 'TRUE';


/* 1.E
    SDO_RELATE odpowiada rzeczywistości, ponieważ punkt (3,3) zawiera się jedynie w figurze o id=2.
*/
select ID from FIGURY where SDO_RELATE(KSZTALT, SDO_GEOMETRY(2001,null, SDO_POINT_TYPE(3,3,null), null,null), 'mask=ANYINTERACT') = 'TRUE';


-- 2.A
select A.CITY_NAME, SDO_NN_DISTANCE(1) ODL
from MAJOR_CITIES A
where SDO_NN(GEOM,(SELECT geom FROM major_cities WHERE CITY_NAME='Warsaw'), 'sdo_num_res=10 unit=km',1) = 'TRUE'
AND city_name != 'Warsaw';

-- 2.B
select A.CITY_NAME
from MAJOR_CITIES A
where SDO_WITHIN_DISTANCE(GEOM,(SELECT geom FROM major_cities WHERE CITY_NAME='Warsaw'), 'distance=100 unit=km') = 'TRUE'
AND city_name != 'Warsaw';

-- 2.C
select cntry_name Kraj, city_name Miasto from MAJOR_CITIES
where SDO_RELATE(GEOM, (SELECT GEOM FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME='Slovakia'), 'mask=INSIDE') = 'TRUE';

-- 2.D
select 
cntry_name Panstwo, 
SDO_GEOM.SDO_DISTANCE(GEOM, (SELECT GEOM FROM COUNTRY_BOUNDARIES WHERE cntry_name = 'Poland'), 1, 'unit=km')
from COUNTRY_BOUNDARIES
WHERE cntry_name != 'Poland' AND
SDO_RELATE(GEOM, (SELECT GEOM FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME='Poland'), 'mask=touch') != 'TRUE';

-- 3.A
SELECT B.CNTRY_NAME,
SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km') ODL
FROM COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
WHERE A.CNTRY_NAME = 'Poland'
AND B.CNTRY_NAME != 'Poland'
AND SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km') IS NOT NULL;

-- 3.B
SELECT CNTRY_NAME
FROM COUNTRY_BOUNDARIES
ORDER BY ROUND(SDO_GEOM.SDO_AREA(GEOM, 1, 'unit=SQ_KM')) desc
FETCH FIRST 1 ROWS ONLY;

-- 3.C
SELECT SDO_GEOM.SDO_AREA(
        SDO_AGGR_MBR(GEOM),
        1,
        'unit=SQ_KM'
    ) AS MBR_AREA_SQ_KM
FROM MAJOR_CITIES
WHERE CITY_NAME IN ('Warsaw', 'Lodz');

-- 3.D
SELECT
    '20' || TO_CHAR(SDO_GEOM.SDO_UNION(
        (SELECT C.GEOM FROM COUNTRY_BOUNDARIES C WHERE C.cntry_name = 'Poland'),
        (SELECT M.GEOM FROM MAJOR_CITIES M WHERE M.CITY_NAME = 'Prague')
    ).GET_GTYPE(), 'FM00') AS GTYPE
FROM
    DUAL;
    
-- 3.E
SELECT MC.CITY_NAME, MC.CNTRY_NAME
FROM MAJOR_CITIES MC 
LEFT JOIN (SELECT CNTRY_NAME KRAJ, SDO_GEOM.SDO_CENTROID(GEOM, 1) CENTRUM FROM COUNTRY_BOUNDARIES) COUNTRY_CENTRUMS ON COUNTRY_CENTRUMS.KRAJ = MC.cntry_name 
ORDER BY SDO_GEOM.SDO_DISTANCE(MC.GEOM, COUNTRY_CENTRUMS.CENTRUM, 1, 'unit=km')
FETCH FIRST 1 ROWS ONLY;

-- 3.F

SELECT 
    R.NAME, 
    SUM(SDO_GEOM.SDO_LENGTH(
        SDO_GEOM.SDO_INTERSECTION(
            R.GEOM,
            (SELECT C.GEOM FROM COUNTRY_BOUNDARIES C WHERE C.CNTRY_NAME = 'Poland'),
            1
    ), 1, 'unit=KM')) AS DLUGOSC
FROM RIVERS R
WHERE SDO_RELATE(R.GEOM, (SELECT GEOM FROM COUNTRY_BOUNDARIES WHERE cntry_name='Poland'), 'mask=anyinteract') = 'TRUE'
GROUP BY R.NAME;

