begin;

do $$
begin
  create role hitokoto_postgraphql login;
  exception when others then
  raise notice 'hitokoto_postgraphql exists, not re-creating';
end $$;

do $$
begin
  create role hitokoto_anonymous login;
  exception when others then
  raise notice 'hitokoto_anonymous exists, not re-creating';
end $$;

do $$
begin
  create role hitokoto_user login;
  exception when others then
  raise notice 'hitokoto_user exists, not re-creating';
end $$;

grant hitokoto_anonymous to hitokoto_postgraphql;
grant hitokoto_user to hitokoto_postgraphql;

grant usage on schema hitokoto to hitokoto_anonymous, hitokoto_user;

grant select on table hitokoto.user to hitokoto_anonymous, hitokoto_user;
grant update, delete on table hitokoto.user to hitokoto_user;

grant select on table hitokoto.hitokoto to hitokoto_anonymous, hitokoto_user;
grant insert, update, delete on table hitokoto.hitokoto to hitokoto_user;
grant usage on sequence hitokoto.hitokoto_id_seq to hitokoto_user;

grant execute on function hitokoto.random_hitokoto() to hitokoto_anonymous, hitokoto_user;
grant execute on function hitokoto.current_user() to hitokoto_anonymous, hitokoto_user;
grant execute on function hitokoto.create_new_hitokoto(text, text, text) to hitokoto_user;

alter table hitokoto.user enable row level security;
alter table hitokoto.hitokoto enable row level security;

drop policy if exists select_user on hitokoto.user;
create policy select_user on hitokoto.user for select
using (true);


drop policy if exists select_hitokoto on hitokoto.hitokoto;
create policy select_hitokoto on hitokoto.hitokoto for select
using (true);

drop policy if exists insert_hitokoto on hitokoto.hitokoto;
create policy insert_hitokoto on hitokoto.hitokoto for insert to hitokoto_user
with check (creator_id = current_setting('jwt.claims.user_id')::integer);

drop policy if exists update_hitokoto on hitokoto.hitokoto;
create policy update_hitokoto on hitokoto.hitokoto for update to hitokoto_user
using (creator_id = current_setting('jwt.claims.user_id')::integer);

drop policy if exists delete_hitokoto on hitokoto.hitokoto;
create policy delete_hitokoto on hitokoto.hitokoto for delete to hitokoto_user
using (creator_id = current_setting('jwt.claims.user_id')::integer);

commit;
