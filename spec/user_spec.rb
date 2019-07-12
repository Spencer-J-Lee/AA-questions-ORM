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

	describe "::where" do
		subject(:hash_results) { User.where(hash_options) }
		let(:hash_options)     { { lname: 'User' } }

		it "takes in a hash as argument" do
			expect { hash_results }.to_not raise_error
		end

		it "returns an array of users" do
			expect(hash_results).to be_an(Array)
			expect(hash_results).to all(be_an(User))
		end

		it "returns users who match the search criteria" do
			correct_lname = hash_results.all? { |user| user.lname = "User" }
			expect(correct_lname).to be(true)
		end

		subject(:str_results) { User.where(str_options) }
		let(:str_options)     { "lname = 'User'" }

		it "takes in a string as argument" do
			expect { str_results }.to_not raise_error
		end
	
		it "returns an array of users" do
			expect(str_results).to be_an(Array)
			expect(str_results).to all(be_an(User))
		end

		it "returns users who match the search criteria" do
			correct_lname = str_results.all? { |user| user.lname = "User" }
			expect(correct_lname).to be(true)
		end
	end

	subject(:user) { User.find_by_id(1) }
	let(:new_user) { User.new('fname'=>'New','lname'=>'Guy') }

	describe "#save" do
		it "calls #create when saving a new user" do
			expect(new_user).to receive(:create)
			new_user.save
		end

		it "calls #update when saving an existing user" do
			expect(user).to receive(:update)
			user.save
		end
	end

	describe "#create" do
		it "adds a new user to the users table" do
			new_user.create

			newest_user = User.find_by_id(5)
			expect(newest_user.fname).to eq('New')
			expect(newest_user.lname).to eq('Guy')
		end

		it "raises error when called on an existing user" do
			expect { user.create }.to raise_error("#{user} already in database")
		end
	end

	describe "#update" do
		it "updates an existing user in the users table" do
			user.fname = "Updated"
			user.update

			updated_user = User.find_by_id(1)
			expect(updated_user.fname).to eq('Updated')
		end

		it "raises error when called on a new user" do
			expect { new_user.update }.to raise_error("#{new_user} not in database")
		end
	end

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

	describe "#liked_questions" do
		let(:question_like) { class_double("QuestionLike").as_stubbed_const }

		it "calls QuestionLike::liked_questions_for_user_id" do
			expect(question_like).to receive(:liked_questions_for_user_id).with(user.id)
			user.liked_questions
		end
	end

	describe "#average_karma" do
		let(:user2) { User.find_by_id(2) }
		
		it "returns the average likes of a user's questions" do
			expect(user.average_karma).to eq(1)
			expect(user2.average_karma).to eq(2.5)
		end
	end
end