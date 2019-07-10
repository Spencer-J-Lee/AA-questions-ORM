require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'question'
require_relative 'reply'

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

		(user.empty?) ? nil : User.new(user.first)
	end

	def self.find_by_name(fname, lname)
		user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
			SELECT
				*
			FROM
				users
			WHERE
				fname = ? AND lname = ?
		SQL

		(user.empty?) ? nil : User.new(user.first)
	end

	attr_accessor :id, :fname, :lname
	
	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end
	
	def authored_questions
		Question.find_by_author_id(@id)
	end

	def authored_replies
		Reply.find_by_user_id(@id)
	end

	def followed_questions
		QuestionFollow.followed_questions_for_user_id(@id)
	end
end