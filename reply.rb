require_relative 'questions_database'

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
		reply = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
			SELECT
				*
			FROM
				replies
			WHERE
				user_id = ?
		SQL

		(reply.empty?) ? nil : Reply.new(reply.first)
	end

	def self.find_by_question_id(question_id)
		reply = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
			SELECT
				*
			FROM
				replies
			WHERE
				question_id = ?
		SQL

		(reply.empty?) ? nil : Reply.new(reply.first)
	end

	attr_accessor :id, :user_id, :subject_question_id, :parent_reply_id, :body
	
	def initialize(options)
		@id = options['id']
		@user_id = options['user_id']
		@subject_question_id = options['subject_question_id']
		@parent_reply_id = options['parent_reply_id']
		@body = options['body']
	end
end