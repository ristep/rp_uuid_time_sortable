-- UUID_V1 generator sortable v1
-- dependabale on uuid_generate_v1() from 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION public.rp_uuid_v1_to(
	)
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	uuid_v1 character(36);
	b4 character(4);
	c3 character(3);
	d2e2 character(17);
	a1 char;
	a4 character(4);
	a3 character(3);
begin
-- 		 12345678-1234-5678-1234-567812345678
-- From: aaaaaaaa-bbbb-1ccc-dddd-eeeeeeeeeeee (time-based, version 1)
-- To:   cccbbbba-aaaa-6aaa-dddd-eeeeeeeeeeee (time-ordered, version 6)
	uuid_v1 := uuid_generate_v1()::character(36);
	b4 := substr( uuid_v1, 10, 4);
	a1 := substr( uuid_v1, 1, 1 );
	a4 := substr( uuid_v1, 2, 4 );
	a3 := substr( uuid_v1, 6, 3 );
	c3 := substr( uuid_v1, 16, 3 );
	d2e2 := substr( uuid_v1, 20, 17);
	
    return (c3 || b4 || a1 || '-' || a4 || '-6' || a3 || '-' || d2e2)::uuid;
end
$BODY$;

ALTER FUNCTION public.rp_uuid_v1_to()
    OWNER TO postgres;
