require 'spec_helper'

describe 'modules extensions' do
  before do
    @env = env_with_path_value File.expand_path('../libjs', __FILE__)
  end
  it "allows the exports object to be completely replaced" do
    expect(@env.require('assign_module_exports').call()).to eql "I am your exports"
  end
end