require_relative 'questions_database'

class QuestionFollow
	def self.all
		question_follows = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
		question_follows.map { |datum| QuestionFollow.new(datum) }
	end
	
	def self.find_by_id(id)
		follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				question_follows
			WHERE
				id = ?
		SQL

		(follow.empty?) ? nil : QuestionFollow.new(follow.first)
	end

	attr_accessor :id, :follower_id, :question_id

	def initialize(options)
		@id = options['id']
		@follower_id = options['follower_id']
		@question_id = options['question_id']
	end
end