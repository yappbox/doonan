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
    FileUtils.remove_entry_secure(@project_root)
  end

  its(:build_input_assets) { should == [] }
end
