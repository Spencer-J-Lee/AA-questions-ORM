require_relative 'questions_database'
require_relative 'user'
require_relative 'question'

class Reply
	def self.all
		replies = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
		replies.map { |datum| Reply.new(datum) }
	end
	
	def self.find_by_id(id)
		reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				replies
			WHERE
				id = ?
		SQL

		(reply.empty?) ? nil : Reply.new(reply.first)
	end

	def self.find_by_user_id(user_id)
		replies = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
			SELECT
				*
			FROM
				replies
			WHERE
				user_id = ?
		SQL

		(replies.empty?) ? nil : replies.map { |datum| Reply.new(datum) }
	end

	def self.find_by_question_id(question_id)
		replies = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
			SELECT
				*
			FROM
				replies
			WHERE
				question_id = ?
		SQL

		(replies.empty?) ? nil : replies.map { |datum| Reply.new(datum) }
	end

	def self.find_child_of_parent(parent_reply_id)
		child = QuestionsDBConnection.instance.execute(<<-SQL, parent_reply_id)
			SELECT
				*
			FROM
				replies
			WHERE
				parent_reply_id = ?
		SQL

		(child.empty?) ? nil : Reply.new(child.first)
	end

	attr_accessor :id, :user_id, :question_id, :parent_reply_id, :body
	
	def initialize(options)
		@id = options['id']
		@user_id = options['user_id']
		@question_id = options['question_id']
		@parent_reply_id = options['parent_reply_id']
		@body = options['body']
	end

	def author
		User.find_by_id(user_id)
	end

	def question
		Question.find_by_id(@question_id)
	end

	def parent_reply
		Reply.find_by_id(@parent_reply_id)
	end

	def child_reply
		Reply.find_child_of_parent(id)
	end
end