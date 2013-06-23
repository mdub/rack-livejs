require "rack/livejs/script_injector"

module Rack
  class Livejs

    attr_reader :app

    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      self.dup._call(env)
    end

    protected

    def _call(env)
      status, headers, body = @app.call(env)
      if headers["Content-Type"] == "text/html"
        body = ScriptInjector.new(body)
      end
      [status, headers, body]
    end

  end
end
