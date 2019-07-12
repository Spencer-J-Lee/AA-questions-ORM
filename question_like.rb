require File.expand_path('../model_base.rb', __FILE__)
require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class QuestionLike < ModelBase
	def self.find_by_id(id)
		super(id)
	end

	def self.likers_for_question_id(question_id)
		likers = QuestionsDB.execute(<<-SQL, question_id)
			SELECT
				users.*
			FROM
				users
			INNER JOIN
				question_likes ON question_likes.liker_id = users.id
			WHERE
				question_id = ?
		SQL

		likers.empty? ? nil : likers.map { |datum| User.new(datum) }
	end

	def self.num_likes_for_question_id(question_id)
		count = QuestionsDB.execute(<<-SQL, question_id)
			SELECT
				COUNT(question_likes.liker_id) AS num_likes
			FROM
				question_likes
			WHERE
				question_likes.question_id = ?
		SQL

		count.first['num_likes']
	end

	def self.liked_questions_for_user_id(user_id)
		liked_questions = QuestionsDB.execute(<<-SQL, user_id)
			SELECT
				questions.*
			FROM
				questions
			INNER JOIN
				question_likes ON question_likes.question_id = questions.id
			INNER JOIN
				users ON users.id = question_likes.liker_id
			WHERE
				users.id = ?
		SQL

		liked_questions.empty? ? nil : liked_questions.map { |datum| Question.new(datum) }
	end

	def self.most_liked_questions(n)
		most_liked = QuestionsDB.execute(<<-SQL, n)
			SELECT
				questions.*,
				COUNT(question_likes.liker_id)
			FROM 
				questions
			LEFT OUTER JOIN
				question_likes ON question_likes.question_id = questions.id
			GROUP BY
				questions.id
			ORDER BY
				COUNT(question_likes.liker_id) DESC, questions.id ASC
			LIMIT
				?
		SQL

		most_liked.empty? ? nil : most_liked.map { |datum| Question.new(datum) }
	end

	def self.most_liked(n)
		QuestionLike.most_liked_questions(n)[n-1]
	end

	attr_accessor :id, :liker_id, :question_id

	def initialize(options)
		@id = options['id']
		@liker_id = options['liker_id']
		@question_id = options['question_id']
	end
end