INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, SRID, DIMINFO) 
VALUES ('COUNTRIES_VIEW', 'GEOMETRY', 8307, 
         SDO_DIM_ARRAY 
         (SDO_DIM_ELEMENT('LONGITUDE', -180, 180, 0.5),
          SDO_DIM_ELEMENT('LATITUDE', -90, 90, 0.5))); 
     
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, SRID, DIMINFO) 
VALUES ('RIVERS_VIEW', 'GEOMETRY', 8307, 
         SDO_DIM_ARRAY                      
         (SDO_DIM_ELEMENT('LONGITUDE', -180, 180, 0.5), 
          SDO_DIM_ELEMENT('LATITUDE', -90, 90, 0.5)));     
     
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, SRID, DIMINFO) 
VALUES ('CITIES_VIEW', 'GEOMETRY', 8307, 
         SDO_DIM_ARRAY 
         (SDO_DIM_ELEMENT('LONGITUDE', -180, 180, 0.5), 
          SDO_DIM_ELEMENT('LATITUDE', -90, 90, 0.5))); 

----------------------------------------------------------------------------------------------------------------

-- 1. Centroid of Brazil
SELECT n.NAME_LONG, SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID (n.GEOMETRY, 0.5)) as centroid
FROM F15CS5715G33.COUNTRIES_VIEW n
WHERE n.name_long = 'Brazil';

-- 2. MBR
SELECT n.NAME_LONG, SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_MBR (n.GEOMETRY)) as mbr
FROM F15CS5715G33.COUNTRIES_VIEW n
WHERE n.name_long = 'Japan';

--3. 10 cities withing 10 units of Amazon
SELECT c.name
FROM F15CS5715G33.RIVERS_VIEW r, F15CS5715G33.CITIES_VIEW c 
WHERE r.name= 'Amazon'
AND SDO_GEOM.WITHIN_DISTANCE (c.geometry, 10, r.geometry, 0.5) = 'TRUE';

--4. Distance from Ob to Moscow
SELECT SDO_GEOM.SDO_DISTANCE(rivers.geom, rivers.DIMINFO, cities.geom, cities.DIMINFO) as Distance
FROM
(SELECT r.name name, r.geometry geom, rm.DIMINFO DIMINFO
FROM F15CS5715G33.RIVERS_VIEW r, user_sdo_geom_metadata rm
WHERE rm.TABLE_NAME = 'RIVERS_VIEW'
AND rm.COLUMN_NAME = 'GEOMETRY') rivers,
(SELECT c.name name, c.geometry geom, cm.DIMINFO DIMINFO
FROM F15CS5715G33.CITIES_VIEW c, user_sdo_geom_metadata cm
WHERE cm.TABLE_NAME = 'CITIES_VIEW'
AND cm.COLUMN_NAME = 'GEOMETRY') cities
WHERE cities.name='Moscow'
AND rivers.name = 'Ob';

--5. Rivers in descending order of length
SELECT r.NAME, SDO_GEOM.SDO_LENGTH (r.GEOMETRY, 0.5) as length
FROM F15CS5715G33.RIVERS_VIEW r
ORDER BY length DESC;

--6. Country with largest area
SELECT *
FROM (SELECT c.name_long, SDO_GEOM.SDO_AREA(c.GEOMETRY, 0.5) as area
FROM F15CS5715G33.COUNTRIES_VIEW c
ORDER BY area DESC)
WHERE rownum = 1;