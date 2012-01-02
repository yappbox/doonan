require 'spec_helper'
require 'doonan'

describe Doonan::InputProcessing::VariableResolver do
  it "should log a warning when an unknown variable is referenced" do
    variable_resolver = Doonan::InputProcessing::VariableResolver.new
    Doonan.logger.should_receive(:warn).with("Missing variable referenced '$i_am_missing'. Will not substitute.")
    result = variable_resolver.resolve({
      "foo" => "bar",
      "baz" => "$foo",
      "bay" => "$i_am_missing"
    })
    result['foo'].should == 'bar'
    result['baz'].should == 'bar'
    result['bay'].should == '$i_am_missing'
  end
end
