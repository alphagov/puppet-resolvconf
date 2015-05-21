require 'facter'

def dhcp_enabled?(interfaces_file, recurse=true)
  dhcp = false
  sourced_interfaces_files = []

  if FileTest.exists?(interfaces_file)
    File.open(interfaces_file) do |file|
      dhcp = file.enum_for(:each_line).any? do |line|
        if recurse && line =~ /^\s*source\s+([^\s]+)/
          sourced_interfaces_files += Dir.glob($1)
        end

        line =~ /inet\s+dhcp/
      end
    end
  end

  dhcp || sourced_interfaces_files.any? { |ifs| dhcp_enabled?(ifs, false) }
end

Facter.add(:dhcp_enabled) do
  confine :osfamily => 'Debian'
  setcode do
    dhcp_enabled?('/etc/network/interfaces')
  end
end
