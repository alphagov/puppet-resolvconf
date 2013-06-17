# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# We don't need rspec-puppet from spec_helper. Just facter.
require 'facter'

describe 'dhcp_enabled' do
  let(:file_path) { '/etc/network/interfaces' }
  before :each do
    Facter.clear
    Facter.fact(:osfamily).expects(:value).returns('Debian')
    Facter.collection.loader.load(:dhcp_enabled)
  end

  context 'no interfaces files' do
    before :each do
      FileTest.expects('exists?').with(file_path)
        .returns(false)
    end

    it { Facter.fact(:dhcp_enabled).value.should == 'false' }
  end

  context 'inet dhcp' do
    before :each do
      FileTest.expects('exists?').with(file_path)
        .returns(true)
      File.expects(:read).with(file_path)
        .returns("auto eth0\niface eth0 inet dhcp\n")
    end

    it { Facter.fact(:dhcp_enabled).value.should == 'true' }
  end

  context 'inet static' do
    before :each do
      FileTest.expects('exists?').with(file_path)
        .returns(true)
      File.expects(:read).with(file_path)
        .returns("auto eth0\niface eth0 inet static\n")
    end

    it { Facter.fact(:dhcp_enabled).value.should == 'false' }
  end
end
