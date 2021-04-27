-- FUNCTION: rp_uuid_v7_to())
-- uuid generator time sortable v7

CREATE OR REPLACE FUNCTION public.rp_uuid_v7_to(
	)
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	i        integer;
	v_rnd    float8;
	v_byte   bit(8);
	v_bytes  bytea;
	v_uuid   varchar;

	v_time timestamp with time zone:= null;
	v_secs bigint := null;
	v_msec bigint := null;
	v_timestamp bigint := null;
	v_timestamp_hex varchar := null;
	v_variant varchar;
	v_node varchar;

	c_node_max bigint := (2^48)::bigint; -- 6 bytes
 	c_greg bigint :=  -12219292800; -- Gragorian epoch: '1582-10-15 00:00:00'
begin
	v_time := clock_timestamp();
	v_rnd := random();
	
	-- Extract seconds and microseconds
	v_secs := EXTRACT(EPOCH FROM v_time);
	v_msec := mod(EXTRACT(MICROSECONDS FROM v_time)::numeric, 10^6::numeric); -- MOD() to remove seconds

	-- Calculate the timestamp
 	v_timestamp := (((v_secs - c_greg) * 10^6) + v_msec) * 10;
	--	v_timestamp := ((v_secs * 10^6) + v_msec) * 10;

	-- Generate timestamp hexadecimal (and set version number)
	v_timestamp_hex := lpad(to_hex(v_timestamp), 16, '0');
	v_timestamp_hex := substr(v_timestamp_hex, 2, 12) || '7' || substr(v_timestamp_hex, 14, 3);
	
	-- Generate a random hexadecimal
	v_uuid := md5(v_time::text || v_rnd::text);

	-- Concat timestemp hex with random hex
	v_uuid := v_timestamp_hex || substr(v_uuid, 1, 16);

	-- 12345678-1234-5678-1234-567812345678
   return (v_uuid)::uuid;
end
$BODY$;

ALTER FUNCTION public.rp_uuid_v7_to()
    OWNER TO postgres;
