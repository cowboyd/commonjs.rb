
require 'commonjs'
require 'pathname'

if defined?(JRUBY_VERSION)
  require 'rhino'
  module CommonJS
    Context = Rhino::Context
  end
else
  require 'v8'
  module CommonJS
    Context = V8::Context
  end
end
