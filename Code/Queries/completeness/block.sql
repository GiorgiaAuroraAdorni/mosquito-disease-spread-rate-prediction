SELECT
    COUNT(*) as all_rows,
    COUNT(block) as block,
    COUNT(coordinate_distance) as coordinate_distance,
    COUNT(cleaned_latitude) as cleaned_latitude,
    COUNT(cleaned_longitude) as cleaned_longitude
  FROM "Block"
