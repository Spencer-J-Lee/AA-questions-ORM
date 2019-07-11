require File.expand_path('../model_base.rb', __FILE__)
require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'question'
require_relative 'reply'

class User < ModelBase
	def self.all
		super
	end

	def self.find_by_id(id)
		super(id)
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

	def save
		if @id
			self.update
		else	
			self.create
		end
	end

	def create
		raise "#{self} already in database" if @id

		QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname)
			INSERT INTO
				users (fname, lname)
			VALUES
				(?, ?)
		SQL

		@id = QuestionsDBConnection.instance.last_insert_row_id
	end

	def update
		raise "#{self} already in database" unless @id

		QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
			UPDATE
				users
			SET
				fname = ?, lname = ?
			WHERE
				id = ?
		SQL
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

	def liked_questions
		QuestionLike.liked_questions_for_user_id(@id)
	end
	
	def average_karma # Avg number of likes for a User's questions.
		karma = QuestionsDBConnection.instance.execute(<<-SQL, @id)
			SELECT 
				AVG(num_likes) AS average_karma
			FROM (
				SELECT 
					COUNT(question_likes.id) AS num_likes 
				FROM 
					questions 
				LEFT OUTER JOIN 
					question_likes ON question_likes.question_id = questions.id 
				GROUP BY 
					questions.id 
				HAVING 
					questions.author_id = ?
			)
		SQL

		karma.first['average_karma'].round(2)
	end
end