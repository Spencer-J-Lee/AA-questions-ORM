require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

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

		(question_like.empty?) ? nil : QuestionLike.new(question_like.first)
	end

	def self.likers_for_question_id(question_id)
		likers = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
			SELECT
				users.*
			FROM
				users
			INNER JOIN
				question_likes ON question_likes.liker_id = users.id
			WHERE
				question_id = ?
		SQL

		(likers.empty?) ? nil : likers.map { |datum| User.new(datum) }
	end

	def self.num_likes_for_question_id(question_id)
		count = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
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
		liked_questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
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

		(liked_questions.empty?) ? nil : liked_questions.map { |datum| Question.new(datum) }
	end

	def self.most_liked_questions(n)
		most_liked = QuestionsDBConnection.instance.execute(<<-SQL, n)
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

		(most_liked.empty?) ? nil : most_liked.map { |datum| Question.new(datum) }
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