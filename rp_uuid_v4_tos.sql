-- Time ordered simple uuid-v4 generator
-- Readable date-time
-- FUNCTION: public.rp_uuid_v4_tos()

-- DROP FUNCTION public.rp_uuid_v4_tos();

CREATE OR REPLACE FUNCTION public.rp_uuid_v4_tos(
	)
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
-- 12345678-1234-v678-1234-567812345678
   return (to_char(NOW(), 'YYMMDDHH24MISS4US'::text) || substring( random()::text ,3,13))::uuid;
end
$BODY$;

ALTER FUNCTION public.rp_uuid_v4_tos()
    OWNER TO postgres;
