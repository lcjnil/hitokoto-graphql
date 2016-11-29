CREATE SCHEMA hitokoto;

CREATE TABLE hitokoto.hitokoto (
  id  SERIAL PRIMARY KEY,
  content TEXT NOT NULL CHECK (char_length(content) < 80),
  author TEXT CHECK (char_length(author) < 20),
  source TEXT CHECK (char_length(source) < 20),
  createdAt TIMESTAMP DEFAULT now()
);

CREATE FUNCTION hitokoto.randomHitokoto() RETURNS hitokoto.hitokoto as $$
  SELECT * FROM hitokoto.hitokoto ORDER BY random() LIMIT 1
$$ LANGUAGE sql;
