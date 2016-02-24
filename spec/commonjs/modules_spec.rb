# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "modules 1.0" do

  def self.make_before(path)
    proc do
      @env = env_with_path_value(path)
      @env.native('system', QuietSystem.new)
    end
  end

  tests = Pathname(__FILE__).dirname.join('../ext/commonjs/tests/modules/1.0')
  tests.entries.each do |path|
    next if ['.','..'].include?(path.to_s)

    describe path do
      before(&make_before(tests.join(path)))

      it "✓" do
        @env.require('program')
      end
    end
  end

  class QuietSystem
    def stdio
      self
    end
    def print
      lambda {|*args|}
    end
  end
end

describe "modules" do
  describe "with js comments" do
    before do
      @env = env_with_path_value File.expand_path('../libjs3', __FILE__)
    end
    
    it "finds modules in that path" do
      @env.require('foo').foo.should == 'foo'
    end
  end
end
