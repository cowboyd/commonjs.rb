require 'spec_helper'

describe 'modules extensions' do
  before do
    @env = CommonJS::Environment.new(V8::Context.new, :path => File.expand_path('../libjs', __FILE__))
  end
  it "allows the exports object to be completely replaced" do
    @env.require('assign_module_exports').call().should eql "I am your exports"
  end
end