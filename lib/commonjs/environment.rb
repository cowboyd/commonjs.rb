require 'pathname'
module CommonJS
  class Environment

    attr_reader :runtime

    def initialize(runtime, options = {})
      @runtime = runtime
      @paths = [options[:path]].flatten.map {|path| Pathname(path)}
      @modules = {}
    end

    def require(module_id)
      unless mod = @modules[module_id]
        filepath = find(module_id) or fail LoadError, "no such module '#{module_id}'"
        load_js = "( function(module, require, exports) {\n#{File.read(filepath)}\n} )"
        load = @runtime.eval(load_js, filepath.expand_path.to_s)
        append = filepath.to_s.split('/')[-1] == 'index.js'
        @modules[module_id] = mod = Module.new(module_id, self, append)
        load.call(mod, mod.require_function, mod.exports)
      end
      return mod.exports
    end

    def native(module_id, impl)
      @modules[module_id] = Module::Native.new(impl)
    end

    def new_object
      @runtime['Object'].new
    end

    def add_path(path)
      @paths << Pathname(path)
    end

    private

    def find(module_id)
      try(module_id) || try("#{module_id}.js") || try("#{module_id}/index.js")
    end

    def try(target)
      if loadpath = @paths.find { |path| path.join(target).file? }
        loadpath.join(target)
      end
    end

  end
end
