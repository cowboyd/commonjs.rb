module CommonJS
  class Module

    attr_reader :id
    attr_accessor :exports

    def initialize(id, env, append = false)
      @id = id
      @env = env
      @exports = env.new_object
      @segments_init = @segments = id.split('/')
      @segments_init << [] if append
    end

    def require_function
      @require_function ||= lambda do |*args|
        this, module_id = *args
        module_id ||= this #backwards compatibility with TRR < 0.10
        @env.require(expand(module_id))
      end
    end

    private

    def expand(module_id)
      return module_id unless module_id =~ /(\.|\..)/
      module_id.split('/').inject(@segments_init[0..-2]) do |path, element|
        path.tap do
          if element == '.'
            #do nothing
          elsif element == '..'
            path.pop
          else
            path.push element
          end
        end
      end.join('/')
    end

    class Native

      attr_reader :exports

      def initialize(impl)
        @exports = impl
      end
    end
  end
end
