# Rack::Livejs

Rack middleware to inject and serve "live.js", a handy javascript snippet for automatically updating content in browser when files in your local dev environment change.

  "Just include Live.js and it will monitor the current page including local CSS and Javascript by sending consecutive HEAD requests to the server. Changes to CSS will be applied dynamically and HTML or Javascript changes will reload the page." - extracted form livejs.com

View [livejs.com](http://livejs.com) for more information on live.js and how it works


## Installation

Add this line to your application's Gemfile:

    gem 'rack-livejs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-livejs

## Usage

Nothing else to do. Rack will serve live.js into your site and will monitor your assets (css, js and html) changes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
