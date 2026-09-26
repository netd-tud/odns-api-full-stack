CREATE INDEX CONCURRENTLY IF NOT EXISTS dns_entries_ip_request_idx
    ON odns.dns_entries (ip_request);

CREATE INDEX CONCURRENTLY IF NOT EXISTS dns_entries_ip_response_idx
    ON odns.dns_entries (ip_response);

CREATE INDEX CONCURRENTLY IF NOT EXISTS dns_entries_a_record_idx
    ON odns.dns_entries (a_record);

CREATE INDEX CONCURRENTLY IF NOT EXISTS dns_entries_protocol_timestamp_request_idx
    ON odns.dns_entries (protocol, timestamp_request);

CREATE INDEX CONCURRENTLY IF NOT EXISTS dns_entries_scan_date_idx
    ON odns.dns_entries (scan_date DESC);

CREATE INDEX CONCURRENTLY IF NOT EXISTS api_keys_active_api_key_idx
    ON odns.api_keys (api_key)
    WHERE is_active = TRUE;
