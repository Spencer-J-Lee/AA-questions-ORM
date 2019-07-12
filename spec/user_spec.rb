require 'rspec'
require_relative '../user'

describe User do
	before(:each) { QuestionsDB.reset! }
	after(:each)  { QuestionsDB.reset! }

	describe "#initialize" do
		subject(:user) { User.new(options) }
		let(:options)  { { 'fname'=>'John', 'lname'=>'Smith' } }

		it "assigns fname and lname accordingly" do
			expect(user.fname).to eq('John')
			expect(user.lname).to eq('Smith')
		end

		it "assigns id as nil" do
			expect(user.id).to be_nil
		end
	end
	
	describe "::find_by_id" do
		let(:result) { User.find_by_id(1) }

		it "returns an instance of user with the specified id" do
			expect(result.class).to be(User)
			expect(result.id).to be(1)
		end
	end

	describe "::find_by_name" do
		let(:result) { User.find_by_name('First', 'User') }

		it "returns an instance of the user class" do
			expect(result.class).to be(User)
		end

		it "returns the correct first and last name" do
			expect(result.fname).to eq('First')
			expect(result.lname).to eq('User')
		end
	end

	subject(:user) { User.find_by_id(1) }

	describe "#authored_questions" do
		let(:question) { class_double("Question").as_stubbed_const }
	
		it "calls Question::find_by_author_id" do
			expect(question).to receive(:find_by_author_id).with(user.id)
			user.authored_questions
		end
	end

	describe "#authored_replies" do
		let(:reply) { class_double("Reply").as_stubbed_const }

		it "calls Reply::find_by_user_id" do
			expect(reply).to receive(:find_by_user_id).with(user.id)
			user.authored_replies
		end
	end

	describe "#followed_questions" do
		let(:question_follow) { class_double("QuestionFollow").as_stubbed_const }

		it "calls QuestionFollow::followed_questions_for_user_id" do
			expect(question_follow).to receive(:followed_questions_for_user_id).with(user.id)
			user.followed_questions
		end
	end
end