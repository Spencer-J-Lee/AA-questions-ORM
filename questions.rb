require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
	include Singleton

	def initialize
		super ('questions.db')
		self.type_translation = true
		self.results_as_hash = true
	end
end

class User
	def self.all
		users = QuestionsDBConnection.instance.execute("SELECT * FROM users")
		users.map { |datum| User.new(datum) }
	end

	def self.find_by_id(id)
		user = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				users
			WHERE
				id = ?
		SQL

		return nil if user.empty?

		User.new(user.first)
	end

	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end
end

class Question
	def self.all
		questions = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
		questions.map { |datum| Question.new(datum) }
	end
	
	def self.find_by_id(id)
		question = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				questions
			WHERE
				id = ?
		SQL

		return nil if question.empty?

		Question.new(question.first)
	end

	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@author_id = options['author_id']
	end
end

class QuestionFollow
	def self.all
		question_follows = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
		question_follows.map { |datum| QuestionFollow.new(datum) }
	end
	
	def self.find_by_id(id)
		question_follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				question_follows
			WHERE
				id = ?
		SQL

		return nil if question_follow.empty?

		QuestionFollow.new(question_follow.first)
	end

	def initialize(options)
		@id = options['id']
		@follower_id = options['follower_id']
		@question_id = options['question_id']
	end
end

class QuestionLike
	def self.all
		question_likes = QuestionsDBConnection.instance.execute("SELECT * FROM question_likes")
		question_likes.map { |datum| QuestionLike.new(datum) }
	end
	
	def self.find_by_id(id)
		question_like = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				question_likes
			WHERE
				id = ?
		SQL

		return nil if question_like.empty?

		QuestionLike.new(question_like.first)
	end

	def initialize(options)
		@id = options['id']
		@likes = 0
		@author_id = options['author_id']
		@question_id = options['question_id']
	end
end

class Reply
	def self.all
		replies = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
		replies.map { |datum| Reply.new(datum) }
	end
	
	def self.find_by_id(id)
		reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				replies
			WHERE
				id = ?
		SQL

		return nil if reply.empty?

		Reply.new(reply.first)
	end

	def initialize(options)
		@id = options['id']
		@user_id = options['user_id']
		@subject_question_id = options['subject_question_id']
		@parent_reply_id = options['parent_reply_id']
		@body = options['body']
	end
end

# For Testing
require 'pry'
binding.pry