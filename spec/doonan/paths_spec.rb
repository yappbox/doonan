require File.expand_path('../../spec_helper', __FILE__)
require 'doonan'

describe Doonan::Paths do
  subject { described_class.new(root, pattern) }

  context('templates **/*') do
    let(:root) { File.expand_path('../../fixtures/templates', __FILE__) }
    let(:pattern) { '**/*' }

    it { should have(4).paths }
    it { should include('_bay.scss.erb', 'foo.scss.erb', 'shared/_bar.scss.erb', 'shared/_baz.scss') }
  end

  context('themes */*.{yml,json}') do
    let(:root) { File.expand_path('../../fixtures/themes', __FILE__) }
    let(:pattern) { '*/*.{yml,json}' }

    it { should have(2).paths }
    it { should include('red/theme.yml', 'blue/theme.json') }
  end

  context('themes/red/images **/*.{png,jpg}') do
    let(:root) { File.expand_path('../../fixtures/themes/red/images', __FILE__) }
    let(:pattern) { '**/*.{png,jpg}' }

    it { should have(3).paths }
    it { should include('icon_1.jpg', 'foo/gallery.png', 'foo/people.png') }
  end
end
