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
	end
end

class Question
	def self.all
		questions = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
	end
end

class QuestionFollow
	def self.all
		question_follows = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
	end
end

class QuestionLike
	def self.all
		question_likes = QuestionsDBConnection.instance.execute("SELECT * FROM question_likes")
	end
end

class Reply
	def self.all
		replies = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
	end
end