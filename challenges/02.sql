SELECT
  STRING_AGG(
    CHR(VALUE),
    ''
    ORDER BY
      id
  )
FROM
  (
    (
      SELECT
        *
      FROM
        letters_a
    )
    UNION ALL
    (
      SELECT
        *
      FROM
        letters_b
    )
  )
WHERE
  (
    VALUE NOT BETWEEN 91 AND 96
    AND VALUE BETWEEN 65 AND 122
  )
  OR VALUE IN (32, 33, 44, 46)