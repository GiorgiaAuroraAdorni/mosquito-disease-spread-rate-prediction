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
	test_id integer NOT NULL,
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
