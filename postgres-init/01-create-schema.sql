CREATE SCHEMA IF NOT EXISTS odns;
CREATE TABLE IF NOT EXISTS odns.dns_entries (
    eid uuid DEFAULT gen_random_uuid() NOT NULL,
    protocol character varying(3) DEFAULT 'UDP'::character varying NOT NULL,
    dns_id bigint DEFAULT '-1'::integer,
    ip_request inet,
    ip_response inet,
    a_record text,
    timestamp_request timestamp without time zone,
    timestamp_response timestamp without time zone,
    response_type character varying(50),
    country_request character varying(3),
    asn_request real DEFAULT '-1'::integer,
    prefix_request cidr,
    org_request text,
    country_response character varying(3),
    asn_response real DEFAULT '-1'::integer,
    prefix_response cidr,
    org_response text,
    country_arecord character varying(3),
    asn_arecord real DEFAULT '-1'::integer,
    prefix_arecord cidr,
    org_arecord text,
    imported timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    scan_date date DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS odns.api_keys (
	id serial4 NOT NULL,
	api_key text DEFAULT gen_random_uuid() NOT NULL,
	full_name varchar(255) NULL,
	affiliation varchar(255) NULL,
	email varchar(255) NOT NULL,
	purpose text NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	is_active bool DEFAULT true NULL,
	is_processed bool DEFAULT false NULL,
	CONSTRAINT api_keys_pkey PRIMARY KEY (id)
);