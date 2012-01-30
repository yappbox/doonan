require 'spec_helper'
require 'fileutils'
require 'tmpdir'
require 'doonan'

describe Doonan::PipelineBuilder do
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

  it ('should be able to build a pipeline') do
    inputs = subject.build_input_assets
    require 'doonan/css_helper'
    subject.scope_helpers Doonan::CSSHelper
    themes = subject.build_theme_scope_assets
    outputs = subject.build_themed_assets(inputs, themes)
    outputs.each do |output|
      output.realize
      output.should exist
    end
  end
end
