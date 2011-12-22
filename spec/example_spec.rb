require File.expand_path('../spec_helper', __FILE__)
require 'doonan'

describe "example output" do
  before :all do
    @example_path = File.expand_path('../example', __FILE__)
    @out_path = File.expand_path('../../tmp/example-output', __FILE__)
    FileUtils.rm_rf(@out_path)
    doonan = Doonan.create_from_directory(@example_path)
    doonan.generate(@out_path)
  end
  
  it "should output the hello world color" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.hello .world').should == ['color: blue;']
  end
end
