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
