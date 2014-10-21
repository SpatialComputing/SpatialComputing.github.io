--1. How many links are in the network?
SELECT SDO_NET.GET_NO_OF_LINKS('airport') FROM DUAL;

--2. How many nodes are in the network?
SELECT SDO_NET.GET_NO_OF_NODES('airport') FROM DUAL;

--3. What is the degree of node "Salt Lake City, UT"?
SELECT * FROM airport_list
WHERE AIRPORT_NAME = 'Salt Lake City, UT';
-- 14869
SELECT SDO_NET.GET_NODE_DEGREE('airport', 14869) FROM DUAL;

--4. What is the average out degree of all nodes in the network?
SELECT avg(SDO_NET.GET_NODE_DEGREE('airport', ID.AIRPORT_ID))FROM DUAL,
((SELECT AIRPORT_ID FROM airport_list
) ID);

--1. List airports (output AIRPORT_ID) can be arrived from "Durango, CO" (AIRPORT_ID: 11413) with at most one stop?
WITH RECURSIVE links_to_durango (START_NODE_ID, END_NODE_ID, LINK_LEVEL) AS
(
SELECT START_NODE_ID, END_NODE_ID, 0 LINK_LEVEL
FROM airport
WHERE START_NODE_ID = 11413
UNION ALL
SELECT a.START_NODE_ID, a.END_NODE_ID, a.LINK_TYPE, LINK_LEVEL+1
FROM links_to_durango l, airport a
WHERE a.START_NODE_ID = a.END_NODE_ID
)
SELECT START_NODE_ID, LINK_LEVEL
FROM links_to_durango
WHERE LINK_LEVEL <=1
ORDER BY LINK_LEVEL;

WITH RECURSIVE X(START_NODE_ID, END_NODE_ID, LINK_LEVEL)
AS (SELECT START_NODE_ID, END_NODE_ID FROM airport_link$)
UNION
(SELECT airport_link$.START_NODE_ID, X.END_NODE_ID 
	FROM airport_link$, X 
WHERE airport_link$.END_NODE_ID = X.START_NODE_ID);
Select * from X;