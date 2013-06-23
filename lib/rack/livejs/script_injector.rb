module Rack
  class Livejs

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
