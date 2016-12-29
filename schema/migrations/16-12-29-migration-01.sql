begin;

create or replace function hitokoto.get_token() returns text as $$
declare
  t text;
begin
  select token into t from hitokoto_private.user_account
    where user_id =  current_setting('jwt.claims.user_id')::integer;
  return t;
end;
$$ language plpgsql stable security definer;

commit;

