PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

-- USERS --

CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	fname VARCHAR(42) NOT NULL,
	lname VARCHAR(42) NOT NULL
);

INSERT INTO
	users (fname, lname)
VALUES
	('Dio', 'Brando'),
	('Joseph', 'Joestar'),
	('Kekyoin', 'Noriaki'),
	('Lurker','Larry');

-- QUESTIONS --

CREATE TABLE questions (
	id INTEGER PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	body TEXT NOT NULL,
	author_id INTEGER NOT NULL,

	FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
	questions (title, body, author_id)
VALUES
	('Question from DIO?', 'FIRST BODY', (SELECT id FROM users WHERE fname = 'Dio' AND lname = 'Brando')),
	('Question from JOJO?', 'SECOND BODY', (SELECT id FROM users WHERE fname = 'Joseph' AND lname = 'Joestar')),
	('Question from KEKYOIN?', 'THIRD BODY', (SELECT id FROM users WHERE fname = 'Kekyoin' AND lname = 'Noriaki')),
	('Another question from KEKYOIN?', 'FOURTH BODY', (SELECT id FROM users WHERE fname = 'Kekyoin' AND lname = 'Noriaki'));

-- QUESTION FOLLOWS --

CREATE TABLE question_follows (
	id INTEGER PRIMARY KEY,
	follower_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,

	FOREIGN KEY (follower_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
	question_follows (follower_id, question_id)
VALUES
	(1, 2), -- Dio Brando following Joseph Joestar's question
	(2, 3), -- Joseph Joestar following Kekyoin Noriaki's question
	(3, 1); -- Kekyoin Noriaki following Dio Brando's question


-- REPLIES --

CREATE TABLE replies (
	id INTEGER PRIMARY KEY,
	user_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,
	parent_reply_id INTEGER,
	body TEXT NOT NULL,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

INSERT INTO
	replies (user_id, question_id, parent_reply_id, body)
VALUES
	(2, 1, NULL, "Reply by JOJO"),
	(1, 1, 1, "Reply by DIO"),
	(3, 1, 2, "Reply by KEKYOIN"),
	(3, 1, 3, "Another reply by KEKYOIN"),
	(1, 2, NULL, "Reply on second thread by DIO"),
	(2, 2, 1, "Reply on second thread by JOJO");

-- QUESTION LIKES --

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY,
	likes INTEGER,
	author_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,

	FOREIGN KEY (author_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
	question_likes (author_id, question_id)
VALUES
	(1, 1), 
	(2, 2),
	(3, 3);