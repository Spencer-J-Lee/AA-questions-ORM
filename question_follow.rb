require File.expand_path('../model_base.rb', __FILE__)
require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class QuestionFollow < ModelBase
	def self.find_by_id(id)
		super(id)
	end

	def self.followers_for_question_id(question_id)
		follows = QuestionsDB.execute(<<-SQL, question_id)
			SELECT
				users.*
			FROM
				users
			INNER JOIN
				question_follows ON question_follows.follower_id = users.id
			WHERE
				question_follows.question_id = ?
		SQL

		follows.empty? ? nil : follows.map { |datum| User.new(datum) }
	end

	def self.followed_questions_for_user_id(user_id)
		followed_questions = QuestionsDB.execute(<<-SQL, user_id)
			SELECT
				questions.*
			FROM
				question_follows
			INNER JOIN
				questions ON questions.id = question_follows.question_id
			WHERE
				question_follows.follower_id = ?
		SQL

		followed_questions.empty? ? nil : followed_questions.map { |datum| Question.new(datum) }
	end

	def self.most_followed_questions(n)
		most_followed = QuestionsDB.execute(<<-SQL, n)
			SELECT
				questions.*
			FROM 
				questions
			LEFT OUTER JOIN
				question_follows ON question_follows.question_id = questions.id
			GROUP BY
				questions.id
			ORDER BY
				COUNT(question_follows.follower_id) DESC, questions.id ASC
			LIMIT
				?
		SQL

		most_followed.empty? ? nil : most_followed.map { |datum| Question.new(datum) }
	end

	def self.most_followed(n)
		QuestionFollow.most_followed_questions(n)[n-1]
	end

	attr_accessor :id, :follower_id, :question_id

	def initialize(options)
		@id = options['id']
		@follower_id = options['follower_id']
		@question_id = options['question_id']
	end
end