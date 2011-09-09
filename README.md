
# CommonJS

Host CommonJS JavaScript environments in Ruby

## An experimental API for hosting CommonJS apps

    class MyRuntime < CommonJS::Runtime
      modules :require, :filesystem, :process, :crypto
    end

    runtime = CommonJS::Runtime.new
    runtime.modules :require, :filesystem, :process

## Supported runtimes

We'll shoot for Johnson, The Ruby Racer, The Ruby Rhino, (and possibly Lyndon?)