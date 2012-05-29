require 'pathname'
require 'coffee-script'
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
        load = @runtime.eval("(function(module, require, exports) {#{read_source(filepath)}})", filepath.expand_path.to_s)
        @modules[module_id] = mod = Module.new(module_id, self)
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

    private

    def find(module_id)
      filename = nil
      loadpath = @paths.find do |path|
        filename = ( file_exist?(path, module_id) || file_exist?(path, module_id, 'coffee') )
        !!filename
      end
      loadpath.join(filename) if loadpath
    end

    def read_source(file_path)
      if file_path.extname == '.coffee'
        CoffeeScript.compile(file_path, bare: true)
      else
        File.read(file_path)
      end
    end

    def file_exist?(path, module_id, ext = 'js')
      filename = "#{module_id}.#{ext}"
      path.join(filename).exist? ? filename : nil
    end
  end
end
