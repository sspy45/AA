DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE  question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

DROP TABLE IF EXISTS questions_like;

CREATE TABLE questions_like (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ("tony", "wang"),
  ('Luke', 'Amaral');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('sample question', 'sample sample', (SELECT id FROM users WHERE fname = 'tony' AND lname = 'wang')),
  ('sample question2', 'sample sample2', (SELECT id FROM users WHERE fname = 'Luke' AND lname = 'Amaral'));

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 1, 'sample reply, tony can type'),
  (1, 1, 2, 'nested replyyyy');

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (1,1),
  (1,2);

INSERT INTO
  questions_like(question_id, user_id)
VALUES
  (1,1),
  (1,2),
  (2,1);
