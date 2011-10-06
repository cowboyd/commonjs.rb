require 'pathname'
module CommonJS
  class Environment

    def initialize(options = {})
      @runtime = choose
      @path = Pathname(options[:path])
      @exports = {}
    end

    def require(module_id)
      unless exports = @exports[module_id]
        filepath = find(module_id) or fail LoadError, "no such module '#{module_id}'"
        load = @runtime.eval("(function(require, exports) {#{File.read(filepath)}})", filepath.expand_path)
        @exports[module_id] = exports = @runtime.new_object()
        load.call(method(:require), exports)
      end
      return exports
    end

    def native(module_id, impl)
      @exports[module_id] = impl
    end

    private

    def choose
      RubyRacerRuntime.new
    end

    def find(module_id)
      filepath = @path.join("#{module_id}.js")
      filepath if filepath.exist?
    end

    class RubyRacerRuntime
      def initialize
        require 'v8'
        @context = V8::Context.new
      end

      def new_object
        @context['Object'].new
      end

      def eval(source, path)
        @context.eval(source, path)
      end
    end
  end
end
