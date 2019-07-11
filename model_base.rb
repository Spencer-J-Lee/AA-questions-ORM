require 'active_support/inflector'

class ModelBase
	def self.table
		self.to_s.tableize
	end

	def self.find_by_id(id)
		result = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				#{self.table}
			WHERE
				id = ?
		SQL

		result.empty? ? nil : self.new(result.first)
	end

	def self.all
		results = QuestionsDBConnection.instance.execute("SELECT * FROM #{self.table}")
		results.map { |datum| self.new(datum) }
	end

	def save
		@id ? update : create
	end

	def create
		raise "#{self} already in database" if @id

		vars  				 = self.instance_variables.drop(1)

		values 				 = vars.map { |var| self.instance_variable_get(var) }
		col_names      = vars.map { |var| var[1..-1] }.join(', ')
		question_marks = (['?'] * vars.count).join(', ')

		QuestionsDBConnection.instance.execute(<<-SQL, *values)
			INSERT INTO
				#{self.class.table} (#{col_names})
			VALUES
				(#{question_marks})
		SQL

		@id = QuestionsDBConnection.instance.last_insert_row_id
	end

	def update
		raise "#{self} already in database" unless @id

		vars  	= self.instance_variables.drop(1)

		values 	= vars.map { |var| self.instance_variable_get(var) }
		setters = vars.map { |var| var[1..-1] + " = ?"}.join(', ')

		QuestionsDBConnection.instance.execute(<<-SQL, *values, @id)
			UPDATE
				#{self.class.table}
			SET
				#{setters}
			WHERE
				id = ?
		SQL
	end

	def self.where(options)
		booleans = options.map do |col, value|
			value = "'#{value}'" if value.is_a?(String)

			"#{col.to_s} = #{value}"
		end.join(' AND ')

		results = QuestionsDBConnection.instance.execute(<<-SQL, )
			SELECT
				*
			FROM
				#{self.table}
			WHERE
				#{booleans}
		SQL

		results.empty? ? nil : results.map { |datum| self.new(datum) }
	end
end