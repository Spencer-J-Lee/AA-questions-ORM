require_relative 'questions_database'

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

		(question.empty?) ? nil : Question.new(question.first)
	end

	def self.find_by_author_id(author_id)
		questions = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
			SELECT
				*
			FROM
				questions
			WHERE
				author_id = ?
		SQL

		(questions.empty?) ? nil : questions.map { |datum| Question.new(datum) }
	end

	attr_accessor :id, :title, :body, :author_id

	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@author_id = options['author_id']
	end
end