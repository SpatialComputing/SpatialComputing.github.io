--List all countries in South America, sorted by population in ascending order.
SELECT NAME, POPULATION
FROM COUNTRY
WHERE REGION ='South America'
AND YEAR = 2011
ORDER BY POPULATION;

--List all columns of North American countries with a population less that ten million. (10000000)
SELECT *
FROM COUNTRY
WHERE REGION = 'North America'
AND POPULATION < 10000000
AND YEAR = 2011;

--List the regions (without duplicates) of all countries with the letter 'x'(lowercase) in their names.
SELECT REGION
FROM COUNTRY
WHERE regexp_like (NAME, 'x')
GROUP BY;

    Find how many countries there are in Africa.
    Find the average area of all countries in Central America and the Caribbean.
    List all regions (without duplicates) with at least 5 countries whose population is larger than 100 million. 