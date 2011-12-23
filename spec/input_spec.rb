require File.expand_path('../spec_helper', __FILE__)
require 'doonan/input'

describe "Input" do
  before :all do
    @input_path = File.expand_path('../example_input', __FILE__)
  end

  it "should include json properties in the scope" do
    input = Doonan::Input.new(@input_path)
    input.scope.hello_world_color.should == 'blue'
  end

  it "should include info about image presence in the scope" do
    input = Doonan::Input.new(@input_path)
    input.scope.images.icon_1?.should == true
    input.scope.images.icon_2?.should == false
  end

  it "should include the image info in the scope" do
    input = Doonan::Input.new(@input_path)
    input.scope.images.icon_1.path.should == 'icon_1.jpg'
  end

  it "should include info about image paths in the scope" do
    input = Doonan::Input.new(@input_path)
    input.scope.images.icon_1.path.should == 'icon_1.jpg'
    input.scope.images.icon_2.should == nil
  end

  it "should include info about image lists in the scope" do
    input = Doonan::Input.new(@input_path)
    input.scope.image_lists.foo?.should == true
    input.scope.image_lists.foo.size.should == 2
    input.scope.image_lists.foo[0].slug.should == 'gallery'
    input.scope.image_lists.foo[0].path.should == 'foo/gallery.png'
  end
end
