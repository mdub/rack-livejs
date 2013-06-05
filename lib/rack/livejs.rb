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
        html = read_all(body)
        modified_html = inject_tag_into(html)
        headers["Content-Length"] = modified_html.size
        body = [modified_html]
      end
      [status, headers, body]
    end

    def read_all(body)
      html = ""
      body.each { |fragment| html << fragment }
      html
    end

    def inject_tag_into(html)
      doc = Nokogiri::HTML(html)
      head = doc.css("html head").first
      return html unless head
      head.add_child(%{<script src="http://livejs.com/live.js"/>})
      doc.to_html
    end

  end
end
