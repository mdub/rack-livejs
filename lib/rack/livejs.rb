require "rack/livejs/version"

module Rack
  class Livejs

    attr_reader :app

    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      @app.call(env)
    end

  end
end
