SELECT
  -- COUNT(food_item_id),
  food_item_id
FROM
  (
    SELECT
      REPLACE(REPLACE(STRING_TO_TABLE(XPATH('//food_item_id/text()', menu_data)::TEXT, ','), '{', ''), '}', '')::INT AS food_item_id
    FROM
      christmas_menus
    WHERE
      (XPATH('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data)) [1]::TEXT::INT > 78
  )
GROUP BY
  food_item_id
ORDER BY
  COUNT(food_item_id) DESC
LIMIT
  1