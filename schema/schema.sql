create schema hitokoto;
create schema hitokoto_private;

create extension if not exists "pgcrypto";

create role hitokoto_postgraphql login;

create role hitokoto_anonymous;
grant hitokoto_anonymous to hitokoto_graphql;

create role hitokoto_user;
grant hitokoto_user to hitokoto_graphql;


/*
 * Public User Info
 */
create table hitokoto.user (
  id   serial primary key,
  name text not null check (char_length(name) < 10)
);

/*
 * Private Table for save user's account
 * No one can see this
 */
create table hitokoto_private.user_account (
  user_id       integer not null references hitokoto.user (id),
  email         text    not null unique check (email ~* '^.+@.+\..+$'),
  password_hash text    not null
);

create type hitokoto.jwt_token as (
  role    text,
  user_id integer
);

/* register and login */

create or replace function hitokoto.register(
  name     text,
  email    text,
  password text
)
  returns hitokoto.user as $$
declare
  "user" hitokoto.user;
begin
  insert into hitokoto.user (name) values (name)
  returning *
    into "user";

  insert into hitokoto_private.user_account (user_id, email, password_hash) values
    ("user".id, email, crypt(password, gen_salt('bf')));

  return "user";
end;
$$ language plpgsql strict security definer;

create or replace function hitokoto.login(
  email    text,
  password text
)
  returns hitokoto.jwt_token as $$
declare
  user_account hitokoto_private.user_account;
begin
  select * into user_account
  from hitokoto_private.user_account
  where hitokoto_private.user_account.email = login.email;

  if user_account.password_hash = crypt(password, user_account.password_hash) then
    return ('hitokoto_user', user_account.user_id)::hitokoto.jwt_token;
  else
    return null;
  end if;
end;
$$ language plpgsql strict security definer;


create or replace function hitokoto.current_user() returns hitokoto.user as $$
  select *
  from hitokoto.user
  where id = current_setting('jwt.claims.user_id')::integer;
$$ language sql stable;


create table hitokoto.hitokoto (
  id         serial primary key,
  content    text    not null check (char_length(content) < 80),
  author     text check (char_length(author) < 20),
  source     text check (char_length(source) < 20),
  creator_id integer not null references hitokoto.user (id),
  createdAt  timestamp default now()
);

create function hitokoto.random_hitokoto()
  returns hitokoto.hitokoto as $$
select *
from hitokoto.hitokoto
order by random()
limit 1
$$ language sql stable;

create or replace function hitokoto.create_new_hitokoto (
  content text,
  author text,
  source text
)
  returns hitokoto.hitokoto as $$
declare
  h hitokoto.hitokoto;
begin
  insert into hitokoto.hitokoto (content, author, source, creator_id) values
    ($1, $2, $3, current_setting('jwt.claims.user_id')::integer)
    returning * into h;
  return h;
end;
$$ language plpgsql;

grant usage on schema hitokoto to hitokoto_anonymous, hitokoto_user;

grant select on table hitokoto.user to hitokoto_anonymous, hitokoto_user;
grant update, delete on table hitokoto.user to hitokoto_user;

grant select on table hitokoto.hitokoto to hitokoto_anonymous, hitokoto_user;
grant insert, update, delete on table hitokoto.hitokoto to hitokoto_user;
grant usage on sequence hitokoto.hitokoto_id_seq to hitokoto_user;

grant execute on function hitokoto.random_hitokoto() to hitokoto_anonymous, hitokoto_user;
grant execute on function hitokoto.current_user() to hitokoto_anonymous, hitokoto_user;

alter table hitokoto.user enable row level security;
alter table hitokoto.hitokoto enable row level security;

create policy select_user on hitokoto.user for select
using (true);
create policy select_user on hitokoto.hitokoto for select
using (true);

create policy insert_hitokoto on hitokoto.hitokoto  for insert to hitokoto_user
with check (creator_id = current_setting('jwt.claims.user_id')::integer);

create policy update_hitokoto on hitokoto.hitokoto  for update to hitokoto_user
using (creator_id = current_setting('jwt.claims.user_id')::integer);

create policy delete_hitokoto on hitokoto.hitokoto  for delete to hitokoto_user
using (creator_id = current_setting('jwt.claims.user_id')::integer);