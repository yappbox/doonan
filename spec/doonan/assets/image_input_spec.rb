require File.expand_path('../../../spec_helper', __FILE__)
require 'doonan'

describe Doonan::Assets::ImageInput do
  let(:root) { File.expand_path('../../../fixtures/themes/red/images', __FILE__) }
  let(:path) { 'tab_bar/icons/gallery.png' }
  subject do
    described_class.new(root, path)
  end

  it { should be_kind_of Doonan::Assets::StaticAsset }

  its(:slug) { should == 'gallery' }
  its(:slug_path) { should == ['tab_bar', 'icons'] }

  context('foo/people.png') do
    let(:path) { 'foo/people.png' }

    its(:slug)      { should == 'people' }
    its(:slug_path) { should == ['foo'] }

    its(:width)  { should be_nil }
    its(:height) { should be_nil }
    its(:format)   { should be_nil }

    context('realized') do
      before { subject.realize }

      its(:width)  { should == 48 }
      its(:height) { should == 48 }
      its(:format)   { should == :png }
    end

    context('unrealized') do
      before do
        subject.realize
        subject.unrealize
      end

      its(:width)  { should be_nil }
      its(:height) { should be_nil }
      its(:format)   { should be_nil }
    end
  end

  context('icon_1.jpg') do
    let(:path) { 'icon_1.jpg' }

    its(:slug)      { should == 'icon_1' }
    its(:slug_path) { should == [] }

    context('realized') do
      before { subject.realize }

      its(:width)  { should == 48 }
      its(:height) { should == 48 }
      its(:format)   { should == :jpeg }
    end
  end
end
