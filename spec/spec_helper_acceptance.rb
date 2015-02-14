require 'beaker-rspec'

foss_opts = { :default_action => 'gem_install' }

install_puppet(foss_opts)

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => proj_root, :module_name => 'carbon')

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-git'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-vcsrepo'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'jbussdieker-whisper'), { :acceptable_exit_codes => [0,1] }
      apply_manifest(%{
        include git
        class { 'whisper':
          ensure => 'master',
        }
      })
    end
  end
end