class jio_pipeline::repo_server(
  $repo_server,
  $repo_user        = 'repouser',
  $mirror_base_path = '/var/spool/apt-mirror',
) {

  File {
    owner => $repo_user,
    group => $repo_user,
    mode  => 644,
  }

  package { 'apt-mirror':
    ensure => present,
  }

  file { '/etc/apt/mirror.list':
    content => template('jio_pipeline/mirror.list.erb'),
  }

  exec { '/usr/bin/apt-mirror':
    creates => "${mirror_base_path}/mirror",
  }

  user { $repo_user:
    ensure => present,
  }

  $home_dir = "/home/${repo_user}"

  file { $home_dir:
    ensure => directory,
  }

  $script_dir = "${home_dir}/scripts"

  file { $script_dir:
    ensure => directory,
  }

  file { "${script_dir}/snapshot.sh":
    source => "puppet:///modules/jio_pipeline/repo_server/snapshot.sh",
    mode    => '750',
  }

  file { "${script_dir}/periodic-check.sh":
    content => template('jio_pipeline/periodic-check.sh.erb'),
    mode    => '750',
  }

  cron { 'periodic-update':
    command => "${script_dir}/periodic-check.sh",
    user    => 'root',
    hour    => 2,
    minute  => 0,
  }

}
