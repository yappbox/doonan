require File.expand_path('../spec_helper', __FILE__)
require 'doonan'

describe "example output" do
  before :all do
    templates_path = File.expand_path('../example_templates', __FILE__)
    @input_path = File.expand_path('../example_input', __FILE__)
    @out_path = File.expand_path('../../tmp/example-output', __FILE__)
    FileUtils.rm_rf(@out_path)
    doonan = Doonan::Generator.new(templates_path)
    doonan.generate(@input_path, @out_path, ['erb', 'scss'])
  end
  
  it "should output the hello world color" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.hello .world').should == ['color: blue;']
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
  
  it "should handle partial templates with multiple passes" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.bar .world').should == ['color: blue;']
  end

  it "should handle partial templates" do
    parser = CssParser::Parser.new
    parser.load_file!('foo.css', @out_path)
    parser.find_by_selector('.bazzy .world').should == ['color: white;']
  end
  
  describe "Input" do
    it "should include json properties in the scope" do
      input = Doonan::Input.new(@input_path)
      input.scope.hello_world_color.should == 'blue'
    end
    
    it "should include info about image presence in the scope" do
      input = Doonan::Input.new(@input_path)
      input.scope.has_image_icon_1?.should == true
      input.scope.has_image_icon_2?.should == nil
    end
    
    it "should include info about image paths in the scope" do
      input = Doonan::Input.new(@input_path)
      input.scope.image_path_icon_1.should == 'icon_1.jpg'
      input.scope.image_path_icon_2.should == nil
    end

    it "should include info about image lists in the scope" do
      input = Doonan::Input.new(@input_path)
      input.scope.has_foo_image_list?.should == true
      input.scope.foo_images.size.should == 2
      input.scope.foo_images[0].name.should == 'gallery'
      input.scope.foo_images[0].path.should == 'foo/gallery.png'
    end
  end
end
