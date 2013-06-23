module Rack
  class Livejs

    attr_reader :app

    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      return livejs_response if env["PATH_INFO"] == livejs_path
      status, headers, body = @app.call(env)
      if headers["Content-Type"] == "text/html"
        new_html = inject_livejs(read_body(body))
        headers["Content-Length"] = new_html.size.to_s
        body = [new_html]
      end
      [status, headers, body]
    end

    private

    def livejs_path
      "/_rack_livejs_/live.js"
    end

    def read_body(body)
      "".tap do |buffer|
        body.each { |chunk| buffer << chunk }
      end
    end

    def inject_livejs(html)
      html.sub(%r{(<head( [^>]*)?>)}i) { $1 + %{<script src="#{livejs_path}"/>} }
    end

    def livejs_javascript
      @@livejs_javascript ||= ::File.read(::File.expand_path("../../../vendor/livejs/live.js", __FILE__))
    end

    def livejs_response
      [
        200,
        { 'Content-Type' => "application/javascript", 'Content-Length' => livejs_javascript.size.to_s },
        [ livejs_javascript ]
      ]
    end

  end
end
