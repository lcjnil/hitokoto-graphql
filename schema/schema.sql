create schema hitokoto;
create schema hitokoto_private;

create extension if not exists "pgcrypto";

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

/*
 * Type for JSON WEB TOKEN
 */
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
  u hitokoto.user;
begin
  insert into hitokoto.user (name) values (name)
  returning *
    into u;

  insert into hitokoto_private.user_account (user_id, email, password_hash) values
    (u.id, email, crypt(password, gen_salt('bf')));

  return u;
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
  where hitokoto_private.user_account.email = $1;

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

create or replace function hitokoto.random_hitokoto() returns hitokoto.hitokoto as $$
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
