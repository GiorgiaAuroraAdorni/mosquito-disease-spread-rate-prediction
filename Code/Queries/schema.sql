CREATE EXTENSION IF NOT EXISTS PostGIS;

CREATE TABLE IF NOT EXISTS "Weather" (
	
	wban character varying(5) NOT NULL,
	year smallint NOT NULL,
	week_of_year smallint NOT NULL,
	days_per_week smallint,
	t_max double precision,
	t_max_is_suspicious smallint,
	t_min double precision,
	t_min_is_suspicious smallint,
	t_avg double precision,
	t_avg_is_suspicious smallint,
	depart double precision,
	depart_is_suspicious smallint,
	dew_point double precision,
	dew_point_is_suspicious smallint,
	wet_bulb double precision,
	wet_bulb_is_suspicious smallint,
	heat double precision,
	heat_is_suspicious smallint,
	cool double precision,
	cool_is_suspicious smallint,
	sunrise time,
	sunrise_is_suspicious smallint,
	sunset time,
	sunset_is_suspicious smallint,
	code_sum_is_suspicious smallint,
	snow_depth double precision,
	snow_depth_is_suspicious smallint,
	snow_water double precision,
	snow_water_is_suspicious smallint,
	snow_fall double precision,
	snow_fall_is_suspicious smallint,
	precip_total double precision,
	precip_total_is_suspicious smallint,
	stn_pressure double precision,
	stn_pressure_is_suspicious smallint,
	sea_level double precision,
	sea_level_is_suspicious smallint,
	result_speed double precision,
	result_speed_is_suspicious smallint,
	result_dir double precision,
	result_dir_is_suspicious smallint,
	avg_speed double precision,
	avg_speed_is_suspicious smallint,
	max5_speed double precision,
	max5_speed_is_suspicious smallint,
	max5_dir double precision,
	max5_dir_is_suspicious smallint,
	max2_speed double precision,
	max2_speed_is_suspicious smallint,
	max2_dir double precision,
	max2_dir_is_suspicious smallint,
	code_sum_ra smallint,
	code_sum_br smallint,
	code_sum_hz smallint,
	code_sum_ts smallint,
	code_sum_smoke smallint,
	code_sum_dz smallint,
	code_sum_wind smallint,
	code_sum_fg smallint,
	code_sum_sn smallint,
	code_sum_up smallint,
	code_sum_hail smallint,
	
	PRIMARY KEY (wban, year, week_of_year)
);

CREATE TABLE IF NOT EXISTS "Station" (
	
	wban character varying(5) NOT NULL,
	wmo character varying(5),
	call_sign character varying(3),
	climate_division_code character varying(2),
	climate_division_state_code character varying(2),
	climate_division_station_code character varying(4),
	name character varying(50),
	state character varying(2),
	location character varying(50),
	latitude double precision,
	longitude double precision,
	ground_height double precision,
	station_height double precision,
	barometer double precision,
	time_zone smallint,
	
	PRIMARY KEY (wban)
);


CREATE TABLE IF NOT EXISTS "Block" (
	
	block character varying(50) NOT NULL,
	coordinate_distance double precision,
	cleaned_latitude double precision,
	cleaned_longitude double precision,
	
	PRIMARY KEY (block)
);

CREATE TABLE IF NOT EXISTS "WNV" (

	season_year smallint NOT NULL,
	week smallint NOT NULL,
	test_id character varying(10) NOT NULL,
	block character varying(50),
	trap character varying(5),
	trap_type character varying(10),
	test_date timestamp,
	number_of_mosquitoes smallint,
	result boolean,
	species character varying(50),
	day_of_week smallint,
	latitude double precision,
	longitude double precision,
	main_trap character varying(5),
	sub_trap character varying(5),
	
	PRIMARY KEY (season_year, week, test_id)
);

CREATE VIEW "FusedDataset" AS (

WITH 

"BlockStationDistance" AS (
	SELECT 
		"Block".block as bsd_block_name,
		"Station".wban as bsd_station_wban,
		"Block".cleaned_latitude as bsd_block_latitude, 
		"Block".cleaned_longitude as bsd_block_longitude, 
		"Station".latitude as bsd_station_latitude,
		"Station".longitude as bsd_station_longitude,
		ST_Distance(
			ST_GeogFromText('POINT(' || "Block".cleaned_longitude || ' ' || "Block".cleaned_latitude || ')'),
			ST_GeogFromText('POINT(' || "Station".longitude || ' ' || "Station".latitude || ')')) as bsd_distance
	FROM "Block", "Station"
	WHERE "Station".wban NOT IN ('4807', '4879') -- Exclude these weather stations since they only became active in 2015
),

"BlockWithPrefix" AS (
	SELECT
		block AS bl_block,
		coordinate_distance AS bl_coordinate_distance,
		cleaned_latitude AS bl_cleaned_latitude,
		cleaned_longitude AS bl_cleaned_longitude
	FROM "Block"
),
			
"StationWithPrefix" AS (
	SELECT
		wban AS st_wban,
		wmo AS st_wmo,
		call_sign AS st_call_sign,
		climate_division_code AS st_climate_division_code,
		climate_division_state_code AS st_climate_division_state_code,
		climate_division_station_code AS st_climate_division_station_code,
		name AS st_name,
		state AS st_state,
		location AS st_location,
		latitude AS st_latitude,
		longitude AS st_longitude,
		ground_height AS st_ground_height,
		station_height AS st_station_height,
		barometer AS st_barometer,
		time_zone AS st_time_zone
	FROM "Station"
),

"WeatherWithPrefix" AS (
	SELECT
		wban as wr_wban,
		year AS wr_year,
		week_of_year AS wr_week_of_year,
		days_per_week AS wr_days_per_week,
		t_max AS wr_t_max,
		t_max_is_suspicious AS wr_t_max_is_suspicious,
		t_min AS wr_t_min,
		t_min_is_suspicious AS wr_t_min_is_suspicious,
		t_avg AS wr_t_avg,
		t_avg_is_suspicious AS wr_t_avg_is_suspicious,
		depart AS wr_depart,
		depart_is_suspicious AS wr_depart_is_suspicious,
		dew_point AS wr_dew_point,
		dew_point_is_suspicious AS wr_dew_point_is_suspicious,
		wet_bulb AS wr_wet_bulb,
		wet_bulb_is_suspicious AS wr_wet_bulb_is_suspicious,
		heat AS wr_heat,
		heat_is_suspicious AS wr_heat_is_suspicious,
		cool AS wr_cool,
		cool_is_suspicious AS wr_cool_is_suspicious,
		sunrise AS wr_sunrise,
		sunrise_is_suspicious AS wr_sunrise_is_suspicious,
		sunset AS wr_sunset,
		sunset_is_suspicious AS wr_sunset_is_suspicious,
		code_sum_is_suspicious AS wr_code_sum_is_suspicious,
		snow_depth AS wr_snow_depth,
		snow_depth_is_suspicious AS wr_snow_depth_is_suspicious,
		snow_water AS wr_snow_water,
		snow_water_is_suspicious AS wr_snow_water_is_suspicious,
		snow_fall AS wr_snow_fall,
		snow_fall_is_suspicious AS wr_snow_fall_is_suspicious,
		precip_total AS wr_precip_total,
		precip_total_is_suspicious AS wr_precip_total_is_suspicious,
		stn_pressure AS wr_stn_pressure,
		stn_pressure_is_suspicious AS wr_stn_pressure_is_suspicious,
		sea_level AS wr_sea_level,
		sea_level_is_suspicious AS wr_sea_level_is_suspicious,
		result_speed AS wr_result_speed,
		result_speed_is_suspicious AS wr_result_speed_is_suspicious,
		result_dir AS wr_result_dir,
		result_dir_is_suspicious AS wr_result_dir_is_suspicious,
		avg_speed AS wr_avg_speed,
		avg_speed_is_suspicious AS wr_avg_speed_is_suspicious,
		max5_speed AS wr_max5_speed,
		max5_speed_is_suspicious AS wr_max5_speed_is_suspicious,
		max5_dir AS wr_max5_dir,
		max5_dir_is_suspicious AS wr_max5_dir_is_suspicious,
		max2_speed AS wr_max2_speed,
		max2_speed_is_suspicious AS wr_max2_speed_is_suspicious,
		max2_dir AS wr_max2_dir,
		max2_dir_is_suspicious AS wr_max2_dir_is_suspicious,
		code_sum_ra AS wr_code_sum_ra,
		code_sum_br AS wr_code_sum_br,
		code_sum_hz AS wr_code_sum_hz,
		code_sum_ts AS wr_code_sum_ts,
		code_sum_smoke AS wr_code_sum_smoke,
		code_sum_dz AS wr_code_sum_dz,
		code_sum_wind AS wr_code_sum_wind,
		code_sum_fg AS wr_code_sum_fg,
		code_sum_sn AS wr_code_sum_sn,
		code_sum_up AS wr_code_sum_up,
		code_sum_hail AS wr_code_sum_hail
	FROM "Weather"
),
			
"WNVWithPrefix" AS (
	SELECT
		season_year AS wnv_season_year,
		week AS wnv_week,
		test_id AS wnv_test_id,
		block AS wnv_block,
		trap AS wnv_trap,
		trap_type AS wnv_trap_type,
		test_date AS wnv_test_date,
		number_of_mosquitoes AS wnv_number_of_mosquitoes,
		result AS wnv_result,
		species AS wnv_species,
		day_of_week AS wnv_day_of_week,
		latitude AS wnv_latitude,
		longitude AS wnv_longitude,
		main_trap AS wnv_main_trap,
		sub_trap AS wnv_sub_trap
	FROM "WNV"
)
			
SELECT
	wnv_season_year as season_year,
	wnv_week as week,
	wnv_test_id as test_id,
	wnv_block as block,
	wnv_trap as trap,
	wnv_trap_type as trap_type,
	wnv_test_date as test_date,
	wnv_number_of_mosquitoes as number_of_mosquitoes,
	wnv_result as result,
	wnv_species as species,
	wnv_day_of_week as day_of_week,
	wnv_latitude as latitude,
	wnv_longitude as longitude,
	wnv_main_trap as main_trap,
	wnv_sub_trap as sub_trap,
	wr_days_per_week as days_per_week,
	wr_t_max as t_max,
	wr_t_max_is_suspicious as t_max_is_suspicious,
	wr_t_min as t_min,
	wr_t_min_is_suspicious as t_min_is_suspicious,
	wr_t_avg as t_avg,
	wr_t_avg_is_suspicious as t_avg_is_suspicious,
	wr_depart as depart,
	wr_depart_is_suspicious as depart_is_suspicious,
	wr_dew_point as dew_point,
	wr_dew_point_is_suspicious as dew_point_is_suspicious,
	wr_wet_bulb as wet_bulb,
	wr_wet_bulb_is_suspicious as wet_bulb_is_suspicious,
	wr_heat as heat,
	wr_heat_is_suspicious as heat_is_suspicious,
	wr_cool as cool,
	wr_cool_is_suspicious as cool_is_suspicious,
	wr_sunrise as sunrise,
	wr_sunrise_is_suspicious as sunrise_is_suspicious,
	wr_sunset as sunset,
	wr_sunset_is_suspicious as sunset_is_suspicious,
	wr_code_sum_is_suspicious as code_sum_is_suspicious,
	wr_snow_depth as snow_depth,
	wr_snow_depth_is_suspicious as snow_depth_is_suspicious,
	wr_snow_water as snow_water,
	wr_snow_water_is_suspicious as snow_water_is_suspicious,
	wr_snow_fall as snow_fall,
	wr_snow_fall_is_suspicious as snow_fall_is_suspicious,
	wr_precip_total as precip_total,
	wr_precip_total_is_suspicious as precip_total_is_suspicious,
	wr_stn_pressure as stn_pressure,
	wr_stn_pressure_is_suspicious as stn_pressure_is_suspicious,
	wr_sea_level as sea_level,
	wr_sea_level_is_suspicious as sea_level_is_suspicious,
	wr_result_speed as result_speed,
	wr_result_speed_is_suspicious as result_speed_is_suspicious,
	wr_result_dir as result_dir,
	wr_result_dir_is_suspicious as result_dir_is_suspicious,
	wr_avg_speed as avg_speed,
	wr_avg_speed_is_suspicious as avg_speed_is_suspicious,
	wr_max5_speed as max5_speed,
	wr_max5_speed_is_suspicious as max5_speed_is_suspicious,
	wr_max5_dir as max5_dir,
	wr_max5_dir_is_suspicious as max5_dir_is_suspicious,
	wr_max2_speed as max2_speed,
	wr_max2_speed_is_suspicious as max2_speed_is_suspicious,
	wr_max2_dir as max2_dir,
	wr_max2_dir_is_suspicious as max2_dir_is_suspicious,
	wr_code_sum_ra as code_sum_ra,
	wr_code_sum_br as code_sum_br,
	wr_code_sum_hz as code_sum_hz,
	wr_code_sum_ts as code_sum_ts,
	wr_code_sum_smoke as code_sum_smoke,
	wr_code_sum_dz as code_sum_dz,
	wr_code_sum_wind as code_sum_wind,
	wr_code_sum_fg as code_sum_fg,
	wr_code_sum_sn as code_sum_sn,
	wr_code_sum_up as code_sum_up,
	wr_code_sum_hail as code_sum_hail,
	st_wban as station_wban,
	st_wmo as station_wmo,
	st_call_sign as station_all_sign,
	st_climate_division_code as station_climate_division_code,
	st_climate_division_state_code as station_climate_division_state_code,
	st_climate_division_station_code as station_climate_division_station_code,
	st_name as station_name,
	st_state as station_state,
	st_location as station_location,
	st_latitude as station_latitude,
	st_longitude as station_longitude,
	st_ground_height as station_ground_height,
	st_station_height as station_height,
	st_barometer as station_barometer,
	st_time_zone as station_time_zone,
	bl_coordinate_distance as block_coordinate_distance,
	bl_cleaned_latitude as block_cleaned_latitude,
	bl_cleaned_longitude as block_cleaned_longitude,
	bsd_distance as block_station_distance
FROM "WNVWithPrefix"
JOIN (
	SELECT *
	FROM "WeatherWithPrefix" AS "W"
	JOIN (
		SELECT *
		FROM "StationWithPrefix" AS "S"
		JOIN (
			SELECT *
			FROM "BlockWithPrefix" AS "B"
			JOIN "BlockStationDistance" AS "BSD" ON "B".bl_block = "BSD".bsd_block_name
			WHERE "BSD".bsd_distance = (
				SELECT "BlockStationDistance".bsd_distance
				FROM "BlockStationDistance"
				WHERE "BlockStationDistance".bsd_block_name = "B".bl_block
				ORDER BY "BlockStationDistance".bsd_distance ASC
				LIMIT 1
			)
		) AS "NN" ON "S".st_wban = "NN".bsd_station_wban
	) AS "SB" ON "W".wr_wban = "SB".st_wban
) AS "BSW" ON "WNVWithPrefix".wnv_block = "BSW".bl_block
WHERE "WNVWithPrefix".wnv_season_year = "BSW".wr_year AND "WNVWithPrefix".wnv_week = "BSW".wr_week_of_year
			
);

CREATE VIEW "ReadableFusedDataset" AS (

SELECT
	test_id,
	CASE
		WHEN result = true THEN 'Positivo'
		ELSE 'Negativo'
	END AS result,
	season_year,
	week,
	CASE
		WHEN day_of_week = 0 THEN 'Lunedì'
		WHEN day_of_week = 1 THEN 'Martedì'
		WHEN day_of_week = 2 THEN 'Mercoledì'
		WHEN day_of_week = 3 THEN 'Giovedì'
		WHEN day_of_week = 4 THEN 'Venerdì'
		WHEN day_of_week = 5 THEN 'Sabato'
		WHEN day_of_week = 6 THEN 'Domenica'
		ELSE 'Errore'
	END AS day_of_week,
	to_char(test_date, 'dd/MM/yyyy alle HH24:MM:SS') AS test_date,
	block,
	trap,
	main_trap,
	sub_trap,
	latitude,
	longitude,
	trap_type,
	species,
	number_of_mosquitoes,
	days_per_week,
	t_max,
	t_max_is_suspicious,
	t_min,
	t_min_is_suspicious,
	t_avg,
	t_avg_is_suspicious,
	depart,
	depart_is_suspicious,
	dew_point,
	dew_point_is_suspicious,
	wet_bulb,
	wet_bulb_is_suspicious,
	heat,
	heat_is_suspicious,
	cool,
	cool_is_suspicious,
	sunrise,
	sunrise_is_suspicious,
	sunset,
	sunset_is_suspicious,
	code_sum_is_suspicious,
	snow_depth,
	snow_depth_is_suspicious,
	snow_water,
	snow_water_is_suspicious,
	snow_fall,
	snow_fall_is_suspicious,
	precip_total,
	precip_total_is_suspicious,
	stn_pressure,
	stn_pressure_is_suspicious,
	sea_level,
	sea_level_is_suspicious,
	result_speed,
	result_speed_is_suspicious,
	result_dir,
	result_dir_is_suspicious,
	avg_speed,
	avg_speed_is_suspicious,
	max5_speed,
	max5_speed_is_suspicious,
	max5_dir,
	max5_dir_is_suspicious,
	max2_speed,
	max2_speed_is_suspicious,
	max2_dir,
	max2_dir_is_suspicious,
	code_sum_ra,
	code_sum_br,
	code_sum_hz,
	code_sum_ts,
	code_sum_smoke,
	code_sum_dz,
	code_sum_wind,
	code_sum_fg,
	code_sum_sn,
	code_sum_up,
	code_sum_hail,
	station_wban,
	station_wmo,
	station_all_sign,
	station_climate_division_code,
	station_climate_division_state_code,
	station_climate_division_station_code,
	station_name,
	station_state,
	station_location,
	station_latitude,
	station_longitude,
	station_ground_height,
	station_height,
	station_barometer,
	station_time_zone,
	block_coordinate_distance,
	block_cleaned_latitude,
	block_cleaned_longitude,
	block_station_distance
FROM "FusedDataset"

);

CREATE VIEW "FeaturesDataset" AS (

SELECT
	result
	-- Add features list
FROM "FusedDataset"

);
