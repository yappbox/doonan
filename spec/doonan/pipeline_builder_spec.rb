require File.expand_path('../../spec_helper', __FILE__)
require 'fileutils'
require 'tmpdir'
require 'doonan'
require 'doonan/css_helper'

describe Doonan::Pipeline do
  before do
    fixtures = File.expand_path('../../fixtures', __FILE__)
    @project_root = Dir.mktmpdir('project_root')
    @orig_pwd = Dir.pwd
    Dir.chdir(@project_root)
    FileUtils.cp_r(File.join(fixtures,'.'), @project_root)
  end

  after do
    Dir.chdir(@orig_pwd)
    #puts @project_root
    FileUtils.remove_entry_secure(@project_root)
  end

  let(:test_project_root) { @project_root }

  let(:config) {
    Doonan::Config::DSL.new {
      project_root test_project_root
      scope_helper Doonan::CSSHelper
    }.config
  }

  subject {
    described_class.new(config)
  }

  it 'should be able to build a pipeline' do
    subject.realize
    #template_inputs = subject.build_template_assets
    #require 'doonan/css_helper'
    #subject.scope_helpers Doonan::CSSHelper
    #scope_outputs = subject.build_theme_scope_assets
    #template_outputs = subject.build_themed_assets(template_inputs, scope_outputs)
    #template_outputs.each do |output|
      #output.realize
      #output.should exist
    #end
  end
end
