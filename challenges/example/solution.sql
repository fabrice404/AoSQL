SELECT * 
FROM
(
	SELECT city, country, AVG(children.naughty_nice_score) as avg, ROW_NUMBER() OVER (PARTITION BY country ORDER BY AVG(children.naughty_nice_score) DESC) AS row_num
	FROM children 
	GROUP BY city, country 
	HAVING COUNT(1) >= 5
	ORDER BY country, AVG(children.naughty_nice_score) DESC
) AS T1
WHERE T1.row_num <= 3
