require_relative 'questions_database'
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

	attr_accessor :id, :liker_id, :question_id

	def initialize(options)
		@id = options['id']
		@liker_id = options['liker_id']
		@question_id = options['question_id']
	end
end