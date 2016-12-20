begin;

alter table hitokoto_private.user_account
  add column if not exists token text unique;

create or replace function hitokoto.generate_token() returns text as $$
declare
  t text;
begin
  select substr(md5(random()::text), 0, 9) into t;

  update hitokoto_private.user_account
    set token = t
    where user_id = current_setting('jwt.claims.user_id')::integer;

  return t;
end;
$$ language plpgsql volatile security definer;

commit;
