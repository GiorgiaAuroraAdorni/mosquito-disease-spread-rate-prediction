WITH "BlockStationDistance" AS (
	SELECT "Block".block as block_name,
		"Station".wban as station_wban,
		"Block".cleaned_latitude as block_latitude, 
		"Block".cleaned_longitude as block_longitude, 
		"Station".latitude as station_latitude,
		"Station".longitude as station_longitude,
		ST_Distance(
			ST_GeogFromText('POINT(' || "Block".cleaned_longitude || ' ' || "Block".cleaned_latitude || ')'),
			ST_GeogFromText('POINT(' || "Station".longitude || ' ' || "Station".latitude || ')')) as distance
	FROM "Block", "Station"
	WHERE "Station".wban NOT IN ('4807', '4879') -- Exclude these weather stations since they only became active in 2015
)

SELECT *
FROM "WNV"
JOIN (
	SELECT *
	FROM "Weather" AS "W"
	JOIN (
		SELECT *
		FROM "Station" AS "S"
		JOIN (
			SELECT *
			FROM "Block" AS "B"
			JOIN "BlockStationDistance" AS "BSD" ON "B".block = "BSD".block_name
			WHERE "BSD".distance = (
				SELECT "BlockStationDistance".distance
				FROM "BlockStationDistance"
				WHERE "BlockStationDistance".block_name = "B".block
				ORDER BY "BlockStationDistance".distance ASC
				LIMIT 1
			)
		) AS "NN" ON "S".wban = "NN".station_wban
	) AS "SB" ON "W".wban = "SB".wban
) AS "BSW" ON "WNV".block = "BSW".block
WHERE "WNV".season_year = "BSW".year AND "WNV".week = "BSW".week_of_year;
