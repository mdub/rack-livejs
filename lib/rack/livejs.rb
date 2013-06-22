require "rack/livejs/version"

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

    class ScriptInjector

      def initialize(original_body, livejs_url = "http://livejs.com/live.js")
        @original_body = original_body
        @livejs_url = livejs_url
      end

      def each
        original_body.each do |line|
          line = line.sub(%r{(<head( [^>]*)?>)}i) { $1 + livejs_script_html }
          yield line
        end
      end

      private

      attr_reader :original_body, :livejs_url

      def livejs_script_html
        %{<script src="#{livejs_url}"/>}
      end

    end

  end
end
