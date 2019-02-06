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
