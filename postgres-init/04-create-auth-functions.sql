-- DROP FUNCTION odns.get_api_key_info(jsonb);

CREATE OR REPLACE FUNCTION odns.get_api_key_info(p_input jsonb)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
    result JSON;
BEGIN
	SELECT to_jsonb(a)
	INTO result
	FROM odns.api_keys a
	WHERE a.api_key = p_input->>'apikey'
	  AND a.is_active = TRUE;

 	RETURN result;
END;
$function$
;

-- DROP FUNCTION odns.get_unprocessed_api_keys();

CREATE OR REPLACE FUNCTION odns.get_unprocessed_api_keys()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
    result JSON;
BEGIN
	SELECT COALESCE(json_agg(t), '[]'::json)
    INTO result
    FROM (
        SELECT *
        FROM odns.api_keys
        WHERE is_processed = FALSE and is_active = TRUE
    ) t;

    RETURN result;
END;
$function$
;

-- DROP FUNCTION odns.insert_api_key(jsonb);

CREATE OR REPLACE FUNCTION odns.insert_api_key(p_input jsonb)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
    result JSON;
BEGIN
INSERT INTO odns.api_keys (
--api_key, 
full_name, 
email,
affiliation,
purpose
)
    VALUES (
        --p_input->>'api_key',
        p_input->>'full_name',
        p_input->>'email',
		p_input->>'affiliation',
		p_input->> 'purpose'
    )
    RETURNING to_jsonb(odns.api_keys.*)
    INTO result;

    RETURN result;
END;
$function$
;