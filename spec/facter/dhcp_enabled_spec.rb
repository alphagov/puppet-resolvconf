require 'spec_helper'
require 'facter'
require 'stringio'

describe 'dhcp_enabled' do
  let(:file_path) { '/etc/network/interfaces' }
  let(:include_file_glob) { '/etc/network/interfaces.d/*.cfg'}
  let(:include_file_path) { '/etc/network/interfaces.d/eth0.cfg'}
  let(:static_conf_file)  { StringIO.new("auto eth0\niface eth0 inet static\n") }
  let(:dhcp_conf_file)    { StringIO.new("auto eth0\niface eth0 inet dhcp\n") }

  before :each do
    Facter.clear
    Facter.fact(:osfamily).expects(:value).returns('Debian')
    Facter.collection.load(:dhcp_enabled)
  end

  context 'no interfaces files' do
    before :each do
      FileTest.expects('exists?').with(file_path)
        .returns(false)
    end

    it { Facter.fact(:dhcp_enabled).value.should == false }
  end

  context 'inet dhcp' do
    before :each do
      FileTest.expects('exists?').with(file_path)
        .returns(true)
    end

    context 'in primary file' do
      before :each do
        File.expects(:open).with(file_path)
          .yields(dhcp_conf_file)
      end

      it { Facter.fact(:dhcp_enabled).value.should == true }
    end

    context 'in included file' do
      before :each do
        File.expects(:open).with(file_path)
          .yields(StringIO.new("# a comment\nsource #{include_file_glob}"))
        Dir.expects(:glob).with(include_file_glob)
          .returns([include_file_path])
        FileTest.expects('exists?').with(include_file_path)
          .returns(true)
        File.expects(:open).with(include_file_path)
          .yields(dhcp_conf_file)
      end

      it { Facter.fact(:dhcp_enabled).value.should == true }
    end
  end

  context 'inet static' do
    before :each do
      FileTest.expects('exists?').with(file_path)
        .returns(true)
    end

    context 'in primary file' do
      before :each do
        File.expects(:open).with(file_path)
          .yields(static_conf_file)
      end

      it { Facter.fact(:dhcp_enabled).value.should == false }
    end

    context 'in included file' do
      before :each do
        File.expects(:open).with(file_path)
          .yields(StringIO.new("# a commant\nsource #{include_file_glob}"))
        Dir.expects(:glob).with(include_file_glob)
          .returns([include_file_path])
        FileTest.expects('exists?').with(include_file_path)
          .returns(true)
        File.expects(:open).with(include_file_path)
          .yields(static_conf_file)
      end

      it { Facter.fact(:dhcp_enabled).value.should == false }
    end
  end
end
