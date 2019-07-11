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

		(result.empty?) ? nil : self.new(result.first)
	end

	def self.all
		results = QuestionsDBConnection.instance.execute("SELECT * FROM #{self.table}")
		results.map { |datum| self.new(datum) }
	end
end