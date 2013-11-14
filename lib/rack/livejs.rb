require 'rack'

module Rack
  class Livejs

    attr_reader :app

    def initialize(app, options = {})
      @app = Rack::URLMap.new(
        bundled_livejs_prefix => Rack::File.new(bundled_livejs_dir),
        '/' => app
      )
    end

    def call(env)
      status, headers, body = @app.call(env)
      if headers["Content-Type"] == "text/html"
        new_html = inject_livejs(read_body(body))
        headers["Content-Length"] = new_html.size.to_s
        body = [new_html]
      end
      [status, headers, body]
    end

    private

    def read_body(body)
      "".tap do |buffer|
        body.each { |chunk| buffer << chunk }
      end
    end

    def inject_livejs(html)
      html.sub(%r{(<head( [^>]*)?>)}i) { $1 + %{<script src="#{bundled_livejs_path}"></script>} }
    end

    def bundled_livejs_prefix
      "/_rack_livejs_"
    end

    def bundled_livejs_dir
      ::File.expand_path("../../../vendor/livejs", __FILE__)
    end

    def bundled_livejs_path
      bundled_livejs_prefix + "/live.js"
    end

  end
end
