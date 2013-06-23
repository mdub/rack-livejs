module Rack
  class Livejs

    attr_reader :app

    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      if env["PATH_INFO"] == livejs_path
        self.class.livejs_response
      else
        status, headers, body = @app.call(env)
        if headers["Content-Type"] == "text/html"
          html = ""; body.each { |chunk| html << chunk }
          new_html = inject_livejs(html)
          headers["Content-Length"] = new_html.size.to_s
          body = [ new_html ]
        end
        [status, headers, body]
      end
    end

    private

    def livejs_path
      "/_rack_livejs_/live.js"
    end

    def inject_livejs(html)
      html.sub(%r{(<head( [^>]*)?>)}i) { $1 + %{<script src="#{livejs_path}"/>} }
    end

    class << self

      def livejs_response
        [
          200,
          { 'Content-Type' => "application/javascript", 'Content-Length' => livejs_javascript.size.to_s },
          [ livejs_javascript ]
        ]
      end

      def livejs_javascript
        @livejs_javascript ||= begin
          ::File.read(::File.expand_path("../../../vendor/livejs/live.js", __FILE__))
        end
      end

    end

  end
end
