require 'spec_helper'
require 'doonan'

describe Doonan::VariableResolver do
  describe 'resolve' do
    it "logs a warning when an unknown variable is referenced" do
      hash = {
        "foo" => "bar",
        "baz" => "$foo",
        "bay" => "$foo $i_am_missing $foo"
      }
      Doonan.logger.should_receive(:warn).with("Missing variable 'i_am_missing' referenced by '$foo $i_am_missing $foo'. Will not substitute.")

      subject.resolve(hash).should == hash

      hash['foo'].should == 'bar'
      hash['baz'].should == 'bar'
      hash['bay'].should == 'bar $i_am_missing bar'
    end

    it "resolves variables deeply nested" do
      hash = {
        "foo" => "bar",
        "bar" => "baz",
        "object" => {"baz" => "$foo"},
        "array" => ["one", "$bar", "two", "$foo"],
        "objects" => [{"baz" => "$foo"}, {"baz" => "$bar"}, {"baz" => "hoo $bar $foo!"}]
      }

      subject.resolve(hash)

      hash['foo'].should == 'bar'
      hash['bar'].should == 'baz'
      hash['object']['baz'].should == 'bar'
      hash['array'].should == ['one', 'baz', 'two', 'bar']
      hash['objects'][0]['baz'].should == 'bar'
      hash['objects'][1]['baz'].should == 'baz'
      hash['objects'][2]['baz'].should == 'hoo baz bar!'
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

      scope.foo.should == 'bar'
      scope.bar.should == 'baz'
      scope.object.baz.should == 'bar'
      scope.array.should == ['one', 'baz', 'two', 'bar']
      scope.objects[0].baz.should == 'bar'
      scope.objects[1].baz.should == 'baz'
      scope.objects[2].baz.should == 'hoo baz bar!'

      # check hash is unaltered
      hash['foo'].should == 'bar'
      hash['bar'].should == 'baz'
      hash['object']['baz'].should == '$foo'
      hash['array'].should == ['one', '$bar', 'two', '$foo']
      hash['objects'][0]['baz'].should == '$foo'
      hash['objects'][1]['baz'].should == '$bar'
      hash['objects'][2]['baz'].should == 'hoo $bar $foo!'
    end
  end
end
