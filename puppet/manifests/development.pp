# development.pp
stage { 'req-install': before => Stage['rvm-install'] }

class requirements {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update"
  }

  package {
    ["postgresql", "postgresql-client", "postgresql-common", "libpq-dev"]:
      ensure => installed, require => Exec['apt-update']
  }
}

class setuppg {
  exec {
    "SetLocale":
      command => "/bin/echo 'export LC_ALL=\"en_US.utf8\"'>> /home/vagrant/.bashrc",
      unless => "/bin/grep LC_ALL /home/vagrant/.bashrc"
  }
  exec {
    "AddPGUser":
      command => "/bin/su postgres -c 'createuser -s vagrant'",
      unless => "/bin/su vagrant -c \"/usr/bin/psql template1 -c 'SELECT true;'\"",
      require => Package["postgresql-client"]
  }
  exec {
    "ChangeEncoding": 
      command => "/bin/su vagrant -c '/vagrant/change-encoding.sh'"
  }
}

class installrvm {
  include rvm
  rvm::system_user { vagrant: ; }

  if $rvm_installed == "true" {
    rvm_system_ruby {
      'ruby-1.9.3-p125':
        ensure => 'present';
    }
  }
}

class doinstall {
  class { requirements:, stage => "req-install" }
  include setuppg
  include installrvm
}

include doinstall