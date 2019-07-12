require 'rspec'
require_relative '../user'

describe User do
	before(:each) { QuestionsDB.reset! }
	after(:each)  { QuestionsDB.reset! }

	describe "#initialize" do
		let(:user) 	  { User.new(options) }
		let(:options) { { 'fname'=>'John', 'lname'=>'Smith' } }

		it "assigns fname and lname accordingly" do
			expect(user.fname).to eq('John')
			expect(user.lname).to eq('Smith')
		end

		it "assigns id as nil" do
			expect(user.id).to be_nil
		end
	end

	describe "::find_by_name" do
		it "returns user by name" do
			result = User.find_by_name('First', 'User')

			expect(result.class).to be(User)
			expect(result.fname).to eq('First')
			expect(result.lname).to eq('User')
		end
	end
end