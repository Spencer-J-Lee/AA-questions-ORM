require File.expand_path('../model_base.rb', __FILE__)
require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class Reply < ModelBase
	def self.all
		replies = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
		replies.map { |datum| Reply.new(datum) }
	end
	
	def self.find_by_id(id)
		super(id, 'replies', Reply)
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

	def save
		if @id
			self.update
		else
			self.create
		end
	end

	def create
		raise "#{self} already in database" if @id

		QuestionsDBConnection.instance.execute(<<-SQL, @user_id, @question_id, @parent_reply_id, @body)
			INSERT INTO
				replies (user_id, question_id, parent_reply_id, body)
			VALUES
				(?, ?, ?, ?)
		SQL

		@id = QuestionsDBConnection.instance.last_insert_row_id
	end

	def update
		raise "#{self} already in database" unless @id

		QuestionsDBConnection.instance.execute(<<-SQL, @user_id, @question_id, @parent_reply_id, @body, @id)
			UPDATE
				replies
			SET
				user_id = ?, question_id = ?, parent_reply_id = ?, body = ?
			WHERE
				id = ?
		SQL
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