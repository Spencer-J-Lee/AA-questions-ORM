require_relative 'questions_database'

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

	attr_accessor :id, :likes, :author_id, :question_id

	def initialize(options)
		@id = options['id']
		@likes = 0
		@author_id = options['author_id']
		@question_id = options['question_id']
	end
end