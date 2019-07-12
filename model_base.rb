require 'active_support/inflector'

class ModelBase
	def self.table
		self.to_s.tableize
	end

	def self.find_by_id(id)
		result = QuestionsDB.execute(<<-SQL, id)
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
		results = QuestionsDB.execute("SELECT * FROM #{self.table}")
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

		QuestionsDB.execute(<<-SQL, *values)
			INSERT INTO
				#{self.class.table} (#{col_names})
			VALUES
				(#{question_marks})
		SQL

		@id = QuestionsDB.last_insert_row_id
	end

	def update
		raise "#{self} not in database" unless @id

		vars  	= self.instance_variables.drop(1)

		values 	= vars.map { |var| self.instance_variable_get(var) }
		setters = vars.map { |var| var[1..-1] + " = ?"}.join(', ')

		QuestionsDB.execute(<<-SQL, *values, @id)
			UPDATE
				#{self.class.table}
			SET
				#{setters}
			WHERE
				id = ?
		SQL
	end

	def self.where(options)
		if options.is_a?(String)
			booleans = options
		else
			booleans = self.convert_hash_into_booleans(options)
		end

		results = QuestionsDB.execute(<<-SQL, )
			SELECT
				*
			FROM
				#{self.table}
			WHERE
				#{booleans}
		SQL

		results.empty? ? nil : results.map { |datum| self.new(datum) }
	end

	private 
	
	def self.convert_hash_into_booleans(hash)
		keys = hash.keys.map(&:to_s)
		vals = hash.values.map { |val| val.is_a?(String) ? "'#{val}'" : val }
		
		(0...hash.count).map { |i| "#{keys[i]} = #{vals[i]}" }.join(' AND ')
	end
end