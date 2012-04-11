
require 'commonjs'
require 'pathname'

def env_with_path_value(path)
  CommonJS::Environment.new new_runtime, :path => path
end

def new_runtime
  require 'v8'
  V8::Context.new
rescue LoadError
  require 'rhino'
  Rhino::Context.new
end
