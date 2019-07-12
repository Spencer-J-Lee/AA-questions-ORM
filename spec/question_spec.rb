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

	describe "::find_by_author_id" do
		let(:results) { Question.find_by_author_id(3) }

		it "returns instances of the question class" do
			expect(results).to all(be_an(Question))
		end

		it "returns the correct title, body, and author_id" do
			expect(results.map(&:author_id)).to all(be(3))
			expect(results[0].title).to eq('1st Question from Third User')
			expect(results[1].title).to eq('2nd Question from Third User')
			expect(results[2].title).to eq('3rd Question from Third User')
			expect(results[0].body).to eq('Fourth body')
			expect(results[1].body).to eq('Fifth body')
			expect(results[2].body).to eq('Sixth body')
		end
	end

	describe "::where" do
		subject(:hash_results) { Question.where(hash_options) }
		let(:hash_options)     { { body: 'First body' } }

		it "takes in a hash as argument" do
			expect { hash_results }.to_not raise_error
		end

		it "returns an array of questions" do
			expect(hash_results).to be_an(Array)
			expect(hash_results).to all(be_an(Question))
		end

		it "returns questions who match the search criteria" do
			correct_body = hash_results.all? { |question| question.body = 'First body' }
			expect(correct_body).to be(true)
		end

		subject(:str_results) { Question.where(str_options) }
		let(:str_options)     { "body = 'First body'" }

		it "takes in a string as argument" do
			expect { str_results }.to_not raise_error
		end
	
		it "returns an array of questions" do
			expect(str_results).to be_an(Array)
			expect(str_results).to all(be_an(Question))
		end

		it "returns questions who match the search criteria" do
			correct_body = str_results.all? { |question| question.body = 'First body' }
			expect(correct_body).to be(true)
		end
	end
end