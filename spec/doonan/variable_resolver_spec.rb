require File.expand_path('../../spec_helper', __FILE__)
require 'doonan'
require 'doonan/variable_resolver'

describe Doonan::VariableResolver do
  describe 'resolve' do
    it "logs a warning when an unknown variable is referenced" do
      hash = {
        "foo" => "bar",
        "baz" => "$foo",
        "bay" => "$foo $i_am_missing $foo"
      }
      Doonan.logger.should_receive(:warn).with("Failed to resolve variable reference 'i_am_missing'. Will not substitute.")

      subject.resolve(hash).should eq(hash)

      hash['foo'].should eq('bar')
      hash['baz'].should eq('bar')
      hash['bay'].should eq('bar $i_am_missing bar')
    end

    it "resolves variables deeply nested" do

      images = Doonan::Scope::Images.new
      nested = Doonan::Scope::ImageInfo.new('path/to/image', 'background1', :png, 100, 200)
      images.add_image_info(nested)
      hash = {
        "foo" => "bar",
        "bar" => "baz",
        "images" => images,
        "object" => {"baz" => "$foo"},
        "array" => ["one", "$bar", "two", "$foo"],
        "objects" => [{"baz" => "$foo"}, {"baz" => "$bar"}, {"baz" => "hoo $bar $foo!"}],
        "path" => "$images.background1.path",
        "nested" => '$images.background1'
      }

      subject.resolve(hash)

      hash['foo'].should eq('bar')
      hash['bar'].should eq('baz')
      hash['object']['baz'].should eq('bar')
      hash['array'].should eq(['one', 'baz', 'two', 'bar'])
      hash['objects'][0]['baz'].should eq('bar')
      hash['objects'][1]['baz'].should eq('baz')
      hash['objects'][2]['baz'].should eq('hoo baz bar!')
      hash['nested'].should eq(nested)
      hash['path'].should eq(nested.path)
    end

    it "works with Doonan::Scope instance" do
      # parsed config
      hash = {
        "foo" => "bar",
        "bar" => "baz",
        "object" => {"baz" => "$foo"},
        "array" => ["one", "$bar", "two", "$foo"],
        "objects" => [{"baz" => "$foo"}, {"baz" => "$bar"}, {"baz" => "hoo $bar $foo!"}]
      }
      # Deep clones the hash
      scope = Doonan::Scope.new(hash)

      subject.resolve(scope)

      scope.foo.should eq('bar')
      scope.bar.should eq('baz')
      scope.object.baz.should eq('bar')
      scope.array.should eq(['one', 'baz', 'two', 'bar'])
      scope.objects[0].baz.should eq('bar')
      scope.objects[1].baz.should eq('baz')
      scope.objects[2].baz.should eq('hoo baz bar!')

      # check hash is unaltered
      hash['foo'].should eq('bar')
      hash['bar'].should eq('baz')
      hash['object']['baz'].should eq('$foo')
      hash['array'].should eq(['one', '$bar', 'two', '$foo'])
      hash['objects'][0]['baz'].should eq('$foo')
      hash['objects'][1]['baz'].should eq('$bar')
      hash['objects'][2]['baz'].should eq('hoo $bar $foo!')
    end
  end
end
