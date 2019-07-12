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
	('First' , 'User'),
	('Second', 'User'),
	('Third' , 'User'),
	('Lurker', 'User');

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
	('1st Question from First User' , 'First body' , 1), -- User 1 has 1 question
	('1st Question from Second User', 'Second body', 2), -- User 2 has 2 questions
	('2nd Question from Second User', 'Third body' , 2),
	('1st Question from Third User' , 'Fourth body', 3), -- User 3 has 3 questions
	('2nd Question from Third User' , 'Fifth body' , 3),
	('3rd Question from Third User' , 'Sixth body' , 3);

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
	(3, 1), -- Question 1 has 1 follow
	(3, 2), -- Question 2 has 2 follows
	(2, 2),
	(3, 3), -- Question 3 has 3 follows
	(2, 3),
	(1, 3);

-- User 1 has 1 follow
-- User 2 has 3 follows
-- User 3 has 3 follows

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
	(3, 1, NULL, 'Third User  | Subject Question: 1 | Parent ID: NULL'), -- Question 1 has 1 replies
	(3, 2, NULL, 'Third User  | Subject Question: 2 | Parent ID: NULL'), -- Question 2 has 2 replies
	(2, 2, 1   , 'Second User | Subject Question: 2 | Parent ID: 1'   ), 
	(3, 3, NULL, 'Third User  | Subject Question: 3 | Parent ID: NULL'), -- Question 3 has 3 replies
	(2, 3, 1   , 'Second User | Subject Question: 3 | Parent ID: 1'   ), 
	(1, 3, 2   , 'First User  | Subject Question: 3 | Parent ID: 2'   ); 

-- User 1 has 1 reply
-- User 2 has 2 replies
-- User 3 has 3 replies

-- QUESTION LIKES --

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY,
	liker_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,

	FOREIGN KEY (liker_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
	question_likes (liker_id, question_id)
VALUES
	(3, 1), -- Question 1 has 1 like
	(3, 2), -- Question 2 has 2 likes
	(2, 2), 
	(3, 3), -- Question 3 has 3 likes
	(2, 3),
	(1, 3);

-- User 1 has liked 1 question
-- User 2 has liked 2 questions
-- User 3 has liked 3 questions

-- User 1's average karma is 1/1 = 1
-- User 2's average karma is 5/2 = 2.5
-- User 3's average karma is 0/3 = 0