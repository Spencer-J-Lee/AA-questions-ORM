class ModelBase
	def self.find_by_id(id, table, class_type)
		result = QuestionsDBConnection.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				#{table}
			WHERE
				id = ?
		SQL

		(result.empty?) ? nil : class_type.new(result.first)
	end
end