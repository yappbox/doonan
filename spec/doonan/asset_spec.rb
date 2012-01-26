require File.expand_path('../../spec_helper', __FILE__)
require 'doonan/asset'
require 'fileutils'
require 'tmpdir'

describe Doonan::Asset do
  before do
    @root = Dir.mktmpdir('test')
  end

  after do
    FileUtils.remove_entry_secure(@root)
  end

  let(:root) { @root }
  let(:path) { 'path/to/asset.css.erb' }
  let(:fullpath) { Pathname.new(File.join(root, path)) }

  def create_asset_stub(root, path)
    asset = described_class.new(root, path)
    # fulfill concrete subclass contract
    asset.stub(:realize_self)
    asset.stub(:unrealize_self)
    asset
  end

  let(:dependency_a) { create_asset_stub(root, 'dependency_a.css') }
  let(:dependency_b) { create_asset_stub(root, 'dependency_b.css') }
  let(:dependent) { create_asset_stub(root, 'dependent.css') }

  def create_file(body)
    FileUtils.mkdir_p File.dirname(fullpath)
    File.open(fullpath, "w") { |file| file.write body }
  end

  def read_file
    File.read(fullpath)
  end

  context "new asset" do
    let(:dependencies) {[]}
    let(:dependents) {[]}

    subject {
      asset = described_class.new(root, path)
      dependencies.each do |dependency|
        # add_dependency is for subclasses normally
        asset.instance_eval { add_dependency(dependency) }
      end
      dependents.each do |dependent|
        # add_dependency is for subclasses normally
        dependent.instance_eval { add_dependency(asset) }
      end
      asset
    }

    its(:root) { should eq(root) }

    its(:path) { should eq('path/to/asset.css.erb') }

    its(:dependencies) { should eq([]) }

    its(:dependents) { should eq([]) }

    its(:fullpath) { should eq(File.join(root, 'path/to/asset.css.erb')) }

    its(:dir) { should eq(File.join(root, 'path/to')) }

    its(:ext) { should eq('.erb') }

    its(:path_without_ext) { should eq('path/to/asset.css') }

    its(:realized?) { should be_false }

    describe('add_dependency') do
      it('returns dependency for chaining') {
        dependency = dependency_a
        subject.instance_eval { add_dependency(dependency) }.should == dependency
      }
    end

    describe('read') do
      it "raises an exception when the file does not exist" do
        lambda { subject.read }.should raise_error(Errno::ENOENT)
      end

      it "returns the file's body when the file does exist" do
        create_file('hello')

        subject.read.should eq('hello')
      end
    end

    describe('write') do
      it "creates the file when the file does not exist" do
        subject.should_not exist

        subject.instance_eval { write 'data' }

        subject.should exist
        read_file.should eq('data')
      end

      it "overwrites the file when the file does exist" do
        create_file('hello')

        subject.instance_eval { write 'data' }

        read_file.should eq('data')
      end
    end

    describe('delete') do
      it "raises an exception when the file does not exist" do
        lambda { subject.instance_eval { delete } }.should raise_error(Errno::ENOENT)
      end

      it "should delete the file when the file does exist" do
        create_file('hello')
        subject.should exist

        subject.instance_eval { delete }

        subject.should_not exist

        # path/to/asset.css.erb
        fullpath.should_not exist
        # path/to/
        fullpath.dirname.should_not exist
        # path/
        fullpath.dirname.dirname.should_not exist
        # root
        fullpath.dirname.dirname.dirname.should exist
      end
    end

    describe('realize and unrealize') do
      it "raises an exception when realize_self is not implemented" do
        lambda { subject.realize }.should raise_error(NotImplementedError)
      end

      it "becomes realized when realize_self is implemented" do
        subject.should_receive(:realize_self).once

        subject.realized?.should be_false

        subject.realize

        subject.realized?.should be_true
      end

      context('with dependencies and a dependent') do
        let(:dependencies) {[dependency_a, dependency_b]}
        let(:dependents) {[dependent]}

        it "realizes dependencies but not dependent" do
          subject.stub(:realize_self)
          dependency_a.realized?.should be_false
          dependency_b.realized?.should be_false
          subject.realized?.should be_false
          dependent.realized?.should be_false

          subject.realize

          dependency_a.realized?.should be_true
          dependency_b.realized?.should be_true
          subject.realized?.should be_true
          dependent.realized?.should be_false
        end
      end
    end

    describe('unrealize') do
      def realize(subject)
        subject.stub(:realize_self)
        subject.realize
        subject
      end

      it "raises an exception when unrealize_self is not implemented" do
        lambda { realize(subject).unrealize }.should raise_error(NotImplementedError)
      end

      it "becomes unrealized when unrealize_self is implemented" do
        realize(subject)
        subject.should_receive(:unrealize_self).once

        subject.realized?.should be_true

        subject.unrealize

        subject.realized?.should be_false
      end

      context('with dependencies and a dependent') do
        let(:dependencies) {[dependency_a, dependency_b]}
        let(:dependents) {[dependent]}

        it "unrealizes dependent but not dependencies" do
          subject.stub(:realize_self)
          dependent.realize
          subject.stub(:unrealize_self)

          dependency_a.realized?.should be_true
          dependency_b.realized?.should be_true
          subject.realized?.should be_true
          dependent.realized?.should be_true

          subject.unrealize

          dependent.realized?.should be_false
          subject.realized?.should be_false
          dependency_a.realized?.should be_true
          dependency_b.realized?.should be_true
        end
      end
    end
  end

  context 'concrete asset with dependencies' do
    let(:dependency_a) {
      concrete_class = Class.new(described_class)
      concrete_class.class_eval do
        def realize_self
          write 'foo'
        end

        def unrealize_self
          delete
        end
      end
      concrete_class.new(root, 'dependency_a.txt')
    }
    let(:dependency_b) {
      concrete_class = Class.new(described_class)
      concrete_class.class_eval do
        def realize_self
          write 'bar'
        end

        def unrealize_self
          delete
        end
      end
      concrete_class.new(root, 'path/dependency_b.txt')
    }
    let(:dependent) {
      concrete_class = Class.new(described_class)
      concrete_class.class_eval do
        def initialize(root, path, subject)
          super(root, path)
          add_dependency(subject)
        end

        def realize_self
          write "#{dependencies[0].read}!!"
        end

        def unrealize_self
          delete
        end
      end
      concrete_class.new(root, 'path/dependent.txt', subject)
    }
    subject {
      concrete_class = Class.new(described_class)
      concrete_class.class_eval do
        def initialize(root, path, dependency_a, dependency_b)
          super(root, path)
          add_dependency(dependency_a)
          add_dependency(dependency_b)
        end

        def realize_self
          write do |io|
            io.write 'Hello '
            dependencies.each do |dependency|
              io.write dependency.read
            end
          end
        end

        def unrealize_self
          delete
        end
      end
      concrete_class.new(root, 'path/to/asset.txt', dependency_a, dependency_b)
    }
    # integration test
    it 'should be able to be realized, unrealized, and removed' do
      dependency_a.should_not exist
      dependency_a.realized?.should be_false
      dependency_b.should_not exist
      dependency_b.realized?.should be_false
      subject.should_not exist
      subject.realized?.should be_false
      dependent.should_not exist
      dependent.realized?.should be_false

      # realize is descendant
      dependent.realize

      dependency_a.should exist
      dependency_a.realized?.should be_true
      dependency_b.should exist
      dependency_b.realized?.should be_true
      subject.should exist
      subject.realized?.should be_true
      dependent.should exist
      dependent.realized?.should be_true
      dependent.read.should eq('Hello foobar!!')

      # unrealize is ascendant
      dependency_a.unrealize

      dependency_a.should_not exist
      dependency_a.realized?.should be_false
      dependency_b.should exist
      dependency_b.realized?.should be_true
      # path/to/asset.txt
      subject.should_not exist
      # path/to/
      fullpath.dirname.should_not exist
      # path/ not empty
      fullpath.dirname.dirname.should exist
      subject.realized?.should be_false
      dependent.should_not exist
      dependent.realized?.should be_false

      dependent.realize



      # append to dependent_a file 'baz'
      # dependent.descendant_unrealize
      # dependent.realize
      # dependent.read.should eq('Hello foobarbaz!!')


      # dependency_a.remove
      # unrealizes and detaches asset from hierarchy
    end
  end
end
