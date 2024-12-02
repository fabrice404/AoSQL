SELECT
  *
FROM
  (
    SELECT
      c.city,
      c.country,
      AVG(c.naughty_nice_score) AS AVG,
      ROW_NUMBER() OVER (
        PARTITION BY
          c.country
        ORDER BY
          AVG(c.naughty_nice_score) DESC
      ) AS row_num
    FROM
      children c
      INNER JOIN christmaslist cl ON cl.child_id = c.child_id
    WHERE
      cl.was_delivered = TRUE
    GROUP BY
      c.city,
      c.country
    HAVING
      COUNT(1) >= 5
  ) AS t
WHERE
  t.row_num <= 3
ORDER BY
  t.avg DESC