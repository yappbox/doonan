require 'spec_helper'
require 'doonan'

describe Doonan::InputScope do
  it "should log a warning when an unknown variable is referenced" do
    input_scope = Doonan::InputScope.new
    Doonan.logger.should_receive(:warn).with("Missing variable referenced '$i_am_missing'. Will not substitute.")
    input_scope.merge_json!(<<-JSON)
      {
        "foo": "bar",
        "baz": "$foo",
        "bay": "$i_am_missing"
      }
    JSON
    input_scope['foo'].should == 'bar'
    input_scope['baz'].should == 'bar'
    input_scope['bay'].should == '$i_am_missing'
  end
end
