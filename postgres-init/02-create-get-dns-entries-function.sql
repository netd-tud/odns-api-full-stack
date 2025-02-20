CREATE OR REPLACE FUNCTION odns.get_dns_entries(p_input jsonb)
RETURNS jsonb AS $$
declare
	query text;
	innerquery text;
	res jsonb;
	entries jsonb;
	entryfilter jsonb;
	total bigint;
	metadata jsonb;
	pagination jsonb;
	sort jsonb;
	latest bool;
	latest_date date;
	BEGIN
		entryfilter := null;
		pagination := null;
		sort := null;
		query := 'SELECT jsonb_agg(t) FROM (SELECT * FROM odns.dns_entries WHERE true';
		innerquery := 'FROM odns.dns_entries WHERE true';

		-- latest check
		IF p_input ? 'latest' THEN
			latest := (p_input ->'latest')::bool;
			raise notice  'latest: %', latest::text;
			IF latest THEN

				latest_date := (
					select de.scan_date from odns.dns_entries de
					order by de.scan_date desc
					limit 1
				);
				raise notice  'latest date: %', latest_date::text;
				IF latest_date != null THEN
					innerquery := innerquery || ' AND scan_date = ''' || latest_date || '''';
				END IF;
			END IF;
		END IF;

		-- filter check
		IF p_input ? 'filter' THEN
			entryfilter := p_input ->'filter';
			raise notice  'Filter: %', entryfilter;
		-- ==================== filters ===================
			IF entryfilter ? 'protocol' THEN
				raise debug 'protocol filter applied';
	        	innerquery := innerquery || ' AND protocol = ''' || lower((entryfilter ->> 'protocol')) || '''';
	    	END IF;

			IF entryfilter ? 'ip_request' THEN
				raise debug 'ip_request filter applied';
	        	innerquery := innerquery || ' AND ip_request = ''' || (entryfilter ->> 'ip_request') || '''';
	    	END IF;

			IF entryfilter ? 'ip_response' THEN
				raise debug 'ip_response filter applied';
	        	innerquery := innerquery || ' AND ip_response = ''' || (entryfilter ->> 'ip_response') || '''';
	    	END IF;

			IF entryfilter ? 'a_record' THEN
				raise debug 'a_record filter applied';
	        	innerquery := innerquery || ' AND a_record = ''' || (entryfilter ->> 'a_record') || '''';
	    	END IF;

			IF entryfilter ? 'response_type' THEN
				raise debug 'response_type filter applied';
	        	innerquery := innerquery || ' AND response_type = ''' || (entryfilter ->> 'response_type') || '''';
	    	END IF;

			IF entryfilter ? 'country_request' THEN
				raise debug 'country_request filter applied';
	        	innerquery := innerquery || ' AND country_request = ''' || (entryfilter ->> 'country_request') || '''';
	    	END IF;

			IF entryfilter ? 'country_response' THEN
				raise debug 'country_response filter applied';
	        	innerquery := innerquery || ' AND country_response = ''' || (entryfilter ->> 'country_response') || '''';
	    	END IF;

			IF entryfilter ? 'asn_request' THEN
				raise debug 'asn_request filter applied';
	        	innerquery := innerquery || ' AND asn_request =  '|| (entryfilter ->> 'asn_request') || '';
	    	END IF;

			IF entryfilter ? 'asn_response' THEN
				raise debug 'asn_response filter applied';
	        	innerquery := innerquery || ' AND asn_response =  '|| (entryfilter ->> 'asn_response') || '';
	    	END IF;

			IF entryfilter ? 'prefix_request' THEN
				raise debug 'prefix_request filter applied';
	        	innerquery := innerquery || ' AND prefix_request = ''' || (entryfilter ->> 'prefix_request') || '''';
	    	END IF;

			IF entryfilter ? 'prefix_response' THEN
				raise debug 'prefix_response filter applied';
	        	innerquery := innerquery || ' AND prefix_response = ''' || (entryfilter ->> 'prefix_response') || '''';
	    	END IF;

			IF entryfilter ? 'org_request' THEN
				raise debug 'org_request filter applied';
	        	innerquery := innerquery || ' AND org_request = ''' || (entryfilter ->> 'org_request') || '''';
	    	END IF;

			IF entryfilter ? 'org_response' THEN
				raise debug 'org_response filter applied';
	        	innerquery := innerquery || ' AND org_response = ''' || (entryfilter ->> 'org_response') || '''';
	    	END IF;

			IF entryfilter ? 'country_arecord' THEN
				raise debug 'country_arecord filter applied';
	        	innerquery := innerquery || ' AND country_arecord = ''' || (entryfilter ->> 'country_arecord') || '''';
	    	END IF;

			IF entryfilter ? 'asn_arecord' THEN
				raise debug 'asn_arecord filter applied';
	        	innerquery := innerquery || ' AND asn_arecord = ' || (entryfilter ->> 'asn_arecord') || '';
	    	END IF;

			IF entryfilter ? 'prefix_arecord' THEN
				raise debug 'prefix_arecord filter applied';
	        	innerquery := innerquery || ' AND prefix_arecord = ''' || (entryfilter ->> 'prefix_arecord') || '''';
	    	END IF;

			IF entryfilter ? 'org_arecord' THEN
				raise debug 'org_arecord filter applied';
	        	innerquery := innerquery || ' AND org_arecord = ''' || (entryfilter ->> 'org_arecord') || '''';
	    	END IF;

			IF entryfilter ? 'timestamp_response' THEN
				raise debug 'timestamp_response filter applied';
	        	innerquery := innerquery || ' AND timestamp_response = ''' || (entryfilter ->> 'timestamp_response') || '''';
	    	END IF;

			IF entryfilter ? 'timestamp_request' THEN
				raise debug 'timestamp_request filter applied';
	        	innerquery := innerquery || ' AND timestamp_request = ''' || (entryfilter ->> 'timestamp_request') || '''';
	    	END IF;

    	END IF;

		-- ===================== Total ===================
		execute ('SELECT COUNT(1) ' ||innerquery)  into total;
		raise notice  'total is : %', total;

		-- =============== Sorting ====================

		IF p_input ? 'sort' THEN
			sort := p_input -> 'sort';
        	innerquery := innerquery || ' ORDER BY ' || (sort ->> 'field') || ' ' || UPPER(sort->>'order');
			raise notice  'inner query after sorting is applied: %', innerquery;
		END IF;

		-- ================ Pagination ==================

		IF p_input ? 'pagination' THEN
			pagination := p_input -> 'pagination';
		        innerquery := innerquery ||
						' LIMIT ' || (pagination->>'per_page')::INTEGER ||
		                ' OFFSET ' || ((pagination->>'page')::INTEGER - 1) * (pagination->>'per_page')::INTEGER;

			raise notice  'inner query after pagination is applied: %', innerquery;
	    END IF;

		-- =============== Final query =======================

		query := 'SELECT jsonb_agg(t) FROM ( '|| 'SELECT * ' || innerquery || ') t';
		raise notice  'End Query: %', query;



	    -- Execute the innerquery and fetch the result
	    EXECUTE query INTO entries;

		metadata := (
			select jsonb_build_object(
				'total',total
			)
		);

	    -- Return the result as JSON
		res := (
				select jsonb_build_object(
				'dnsEntries',COALESCE(entries, '[]'::jsonb),
				'metaData',metadata
				)
		);
	    RETURN res;

	END;
$$ LANGUAGE plpgsql;

