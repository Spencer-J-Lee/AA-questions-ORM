require File.expand_path('../model_base.rb', __FILE__)
require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'reply'
require_relative 'user'

class Question < ModelBase
	def self.find_by_id(id)
		super(id)
	end

	def self.find_by_author_id(author_id)
		questions = QuestionsDB.execute(<<-SQL, author_id)
			SELECT
				*
			FROM
				questions
			WHERE
				author_id = ?
		SQL

		questions.empty? ? nil : questions.map { |datum| Question.new(datum) }
	end

	attr_accessor :id, :title, :body, :author_id

	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@author_id = options['author_id']
	end

	def author
		User.find_by_id(@author_id)
	end

	def replies
		Reply.find_by_question_id(@id)
	end

	def followers
		QuestionFollow.followers_for_question_id(@id)
	end

	def likers
		QuestionLike.likers_for_question_id(@id)
	end

	def num_likes
		QuestionLike.num_likes_for_question_id(@id)
	end
end