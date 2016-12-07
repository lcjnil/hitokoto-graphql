create role hitokoto_postgraphql login;

create role hitokoto_anonymous;
grant hitokoto_anonymous to hitokoto_graphql;

create role hitokoto_user;
grant hitokoto_user to hitokoto_graphql;

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

create policy select_user on hitokoto.user for select
using (true);
create policy select_user on hitokoto.hitokoto for select
using (true);

create policy insert_hitokoto on hitokoto.hitokoto for insert to hitokoto_user
with check (creator_id = current_setting('jwt.claims.user_id')::integer);

create policy update_hitokoto on hitokoto.hitokoto for update to hitokoto_user
using (creator_id = current_setting('jwt.claims.user_id')::integer);

create policy delete_hitokoto on hitokoto.hitokoto for delete to hitokoto_user
using (creator_id = current_setting('jwt.claims.user_id')::integer);
