require File.expand_path('../spec_helper', __FILE__)
require 'doonan'

describe "example output" do
  before :all do
    templates_path = File.expand_path('../example_templates', __FILE__)
    input_path = File.expand_path('../example_input', __FILE__)
    @out_path = File.expand_path('../../tmp/example-output', __FILE__)
    FileUtils.rm_rf(@out_path)
    doonan = Doonan::Generator.new(templates_path)
    doonan.generate(input_path, @out_path)
  end
  
  it "should output the hello world color" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.hello .world').should == ['color: blue;']
  end
  
  it "should embed the icon" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.icon1').should == ['background-image: url();']
  end
  
  it "should not include css the missing icon" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.icon2').should == []
  end
end
