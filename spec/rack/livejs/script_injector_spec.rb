require 'rack/livejs/script_injector'

describe Rack::Livejs::ScriptInjector do

  let(:livejs_script) { %{<script src="http://livejs.com/live.js"/>} }

  def expect_inject(input, expected_output)
    injector = described_class.new(input.lines)
    output = "".tap do |out|
      injector.each { |chunk| out << chunk }
    end
    expect(output).to eq(expected_output)
  end

  it "handles unadorned <head> tags" do
    expect_inject(
      "<head><title>Stuff</title></head>",
      "<head>#{livejs_script}<title>Stuff</title></head>"
    )
  end

  it "handles <head> tags with attributes" do
    expect_inject(
      "<head id='foo'><title>Foo</title></head>",
      "<head id='foo'>#{livejs_script}<title>Foo</title></head>"
    )
  end

  it "handles uppercase <HEAD> tags" do
    expect_inject(
      "<HEAD><TITLE>Blah</TITLE></HEAD>",
      "<HEAD>#{livejs_script}<TITLE>Blah</TITLE></HEAD>"
    )
  end

end
