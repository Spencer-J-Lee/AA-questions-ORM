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

	describe "::all" do
		let(:results) { Question.all }

		it "returns all questions" do
			expect(results).to all(be_an(Question))
			expect(results.count).to be(6)
			expect(results.map(&:title).uniq.count).to be(6)
		end
	end

	describe "::find_by_id" do
		let(:result) { Question.find_by_id(1) }

		it "returns an instance of question with the specified id" do
			expect(result.class).to be(Question)
			expect(result.id).to be(1)
		end
	end
end