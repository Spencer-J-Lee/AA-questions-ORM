require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class QuestionFollow
	def self.all
		question_follows = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
		question_follows.map { |datum| QuestionFollow.new(datum) }
	end
	
	def self.find_by_id(id)
		follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				question_follows
			WHERE
				id = ?
		SQL

		(follow.empty?) ? nil : QuestionFollow.new(follow.first)
	end

	def self.followers_for_question_id(question_id)
		follows = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
			SELECT
				users.id,
				users.fname,
				users.lname
			FROM
				users
			INNER JOIN
				question_follows ON question_follows.follower_id = users.id
			WHERE
				question_follows.question_id = ?
		SQL

		(follows.empty?) ? nil : follows.map { |datum| User.new(datum) }
	end

	def self.followed_questions_for_user_id(user_id)
		followed_questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
			SELECT
				questions.*
			FROM
				question_follows
			INNER JOIN
				questions ON questions.id = question_follows.question_id
			WHERE
				question_follows.follower_id = ?
		SQL

		(followed_questions.empty?) ? nil : followed_questions.map { |datum| Question.new(datum) }
	end

	attr_accessor :id, :follower_id, :question_id

	def initialize(options)
		@id = options['id']
		@follower_id = options['follower_id']
		@question_id = options['question_id']
	end
end