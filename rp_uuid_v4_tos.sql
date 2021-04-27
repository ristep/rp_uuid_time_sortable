-- Time ordered simple uuid generator
DROP FUNCTION public.rp_uuid_v4_tos();
 
CREATE OR REPLACE FUNCTION public.rp_uuid_v4_tos(
	)
     RETURNS uuid
     LANGUAGE 'python3'
--     COST 100
--     VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
-- 12345678-1234-v678-1234-567812345678
   return (to_char(NOW(), 'YYMMDDHH24MISS4US'::text) || substring( random()::text ,3,13))::uuid;
end
$BODY$;

ALTER FUNCTION public.rp_uuid_v4_time_order()
    OWNER TO postgres;
