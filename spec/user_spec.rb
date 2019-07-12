require 'rspec'
require_relative '../user'

describe User do
	subject(:user) { User.new(options) }
	let(:options) {
		{ 'fname' => 'First Name',
		  'lname' => 'Last Name' }
	}

	it "takes in a hash as argument" do 
		expect{ User.new(options) }.to_not raise_error
	end
end