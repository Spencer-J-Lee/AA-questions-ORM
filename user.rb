require_relative 'questions_database'

class User
	def self.all
		users = QuestionsDBConnection.instance.execute("SELECT * FROM users")
		users.map { |datum| User.new(datum) }
	end

	def self.find_by_id(id)
		user = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				users
			WHERE
				id = ?
		SQL

		(user.empty?) ? nil : User.new(user.first)
	end

	def self.find_by_name(fname, lname)
		user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
			SELECT
				*
			FROM
				users
			WHERE
				fname = ? AND lname = ?
		SQL

		(user.empty?) ? nil : User.new(user.first)
	end

	attr_accessor :id, :fname, :lname

	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end
end