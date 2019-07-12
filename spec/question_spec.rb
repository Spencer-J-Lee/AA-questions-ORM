require 'rspec'
require_relative '../question'

describe Question do
	before(:each) { QuestionsDB.reset! }
	after(:each)  { QuestionsDB.reset! }

	describe "#initialize" do
		subject(:question) { Question.new(options) }
		let(:options)      { { 'title'=>'test_title', 'body'=>'test_body', 'author_id'=>1 } }

		it "assigns title, body, and author_id accordingly" do
			expect(question.title).to eq('test_title')
			expect(question.body).to eq('test_body')
			expect(question.author_id).to be(1)
		end

		it "assigns id as nil" do
			expect(question.id).to be_nil
		end
	end
end