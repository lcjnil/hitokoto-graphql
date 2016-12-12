do $$
declare
  u hitokoto.user;
begin
  if not exists(select * from hitokoto."user") then
    select * into u from hitokoto.register('test', 'test@test.com', 'test');
    insert into hitokoto.hitokoto (content, author, source, creator_id) values
      ('十月的天没有下雪，风吹梧桐的果子在唱，他唱夏天被虫子啃出的窟窿，和凋落的兄弟', '李晋', '十月迷城', u.id);
  end if;
end
$$ language plpgsql;
