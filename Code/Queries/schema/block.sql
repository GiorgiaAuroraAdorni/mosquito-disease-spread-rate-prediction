CREATE TABLE IF NOT EXISTS "Block" (
	
	block character varying(50) NOT NULL,
	coordinate_distance double precision,
	cleaned_latitude double precision,
	cleaned_longitude double precision,
	
	PRIMARY KEY (block)
);
