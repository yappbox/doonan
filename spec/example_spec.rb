require File.expand_path('../spec_helper', __FILE__)
require 'doonan'

# Doonan.logger.level = Logger::DEBUG

describe "example output" do
  before :all do
    templates_path = File.expand_path('../example_templates', __FILE__)
    @input_path = File.expand_path('../example_input', __FILE__)
    @out_path = File.expand_path('../../tmp/example-output', __FILE__)
    FileUtils.rm_rf(@out_path)
    doonan = Doonan::Generator.new(templates_path)
    doonan.helpers Doonan::CSSHelper
    doonan.generate(@input_path, @out_path, ['erb', 'scss'])
  end

  it "should output the hello world color" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.hello .world').should == ['color: #00C; background: #00C;']
  end

  it "should embed the icon" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.icon1').should == ["background-image: url('data:image/jpeg;"]
    # TODO: the above assertion is lame because CssParser is lame. We should
    # either change parsers or add an additional check
  end

  it "should embed the images in the foo list" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.foo_gallery').should == ["background-image: url('data:image/png;"]
    parser.find_by_selector('.foo_people').should == ["background-image: url('data:image/png;"]
    # TODO: the above assertion is lame because CssParser is lame. We should
    # either change parsers or add an additional check
  end

  it "should not include css the missing icon" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.icon2').should == []
  end

  it "should handle sibling partial templates" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.bayseian .filter').should == ['color: #00C;']
  end

  it "should handle nested partial templates with multiple passes" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.bar .world').should == ['color: #00C;']
  end

  it "should handle nested partial templates without multiple passes" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.bazzy .world').should == ['color: white;']
  end

  it "should handle deep update of scope from json" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.foo').should == ['position: absolute; top: 10px; left: 20px; width: 100px; height: 50px; color: red;']
    parser.find_by_selector('.bar').should == ['position: absolute; top: 0; left: -5px; width: 200px; height: 150px; color: #00C;']
  end

  it "should not copy over partials" do
    File.exists?(File.join(@out_path, "_bay.scss")).should be_false
  end
end
