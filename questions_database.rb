require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
	include Singleton

	def initialize
		super ('questions.db')
		self.type_translation = true
		self.results_as_hash = true
	end

	def self.execute(*args)
		instance.execute(*args)
	end

	def self.last_insert_row_id
		instance.last_insert_row_id
	end
end