# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "modules 1.0" do

  def self.make_before(path)
    proc do
      runtime = CommonJS::Context.new
      @env = CommonJS::Environment.new(runtime, :path => path)
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
    def print(*args)
      # puts args.join('')
    end
  end
end
