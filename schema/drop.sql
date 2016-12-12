begin;
drop schema if exists hitokoto, hitokoto_private cascade ;
drop role if exists hitokoto_postgraphql, hitokoto_anonymous, hitokoto_user;
commit;
