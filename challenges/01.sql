SELECT
  C.NAME,
  WL.PRIMARY_WISH,
  WL.BACKUP_WISH,
  WL.FAVORITE_COLOR,
  WL.COLOR_COUNT,
  CASE TC.DIFFICULTY_TO_MAKE
    WHEN 1 THEN 'Simple Gift'
    WHEN 2 THEN 'Moderate Gift'
    ELSE 'Complex Gift'
  END AS GIFT_COMPLEXITY,
  CASE TC.CATEGORY
    WHEN 'outdoor' THEN 'Outside Workshop'
    WHEN 'educational' THEN 'Learning Workshop'
    ELSE 'General Workshop'
  END AS WORKSHOP_ASSIGNMENT
FROM
  (
    SELECT
      CAST(WISHES::JSON ->> 'first_choice' AS VARCHAR(100)) AS PRIMARY_WISH,
      WISHES::JSON ->> 'second_choice' AS BACKUP_WISH,
      WISHES::JSON -> 'colors' ->> 0 AS FAVORITE_COLOR,
      JSON_ARRAY_LENGTH(WISHES::JSON -> 'colors') AS COLOR_COUNT,
      CHILD_ID
    FROM
      WISH_LISTS
  ) WL
  INNER JOIN CHILDREN C ON C.CHILD_ID = WL.CHILD_ID
  INNER JOIN TOY_CATALOGUE TC ON TC.TOY_NAME = WL.PRIMARY_WISH
ORDER BY
  C.NAME
LIMIT
  5