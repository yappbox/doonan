require File.expand_path('../../../spec_helper', __FILE__)
require 'doonan'
require 'tmpdir'

describe Doonan::Output::ThemeImageAsset do
  before { @out_root = Dir.mktmpdir('test') }
  after { FileUtils.remove_entry_secure(@out_root) }

  let(:root) { File.expand_path('../../../fixtures/themes/red/images', __FILE__) }
  let(:path) { 'foo/people.png' }
  let(:image_asset) { Doonan::Input::ImageAsset.new(root, path) }

  let(:out_root) { @out_root }

  subject do
    described_class.new(out_root, 'red', image_asset)
  end

  its(:path) { should == 'themes/red/foo/people.png' }
  its(:dependencies) { should == [image_asset] }

  context('realized') do
    before { subject.realize }
    it { should exist }
    its(:image_info) { should == {:path => 'themes/red/foo/people.png', :slug=>"people", :type=>:png, :width=>48, :height=>48} }
  end
end
