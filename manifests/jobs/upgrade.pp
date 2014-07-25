class jio_pipeline::jobs::upgrade {

  File {
    notify  => Exec['jenkins_jobs_update'],
    require => Exec['install_jenkins_job_builder'],
    owner  => 'root',
    group  => 'root',
  }

  file { "/etc/jenkins_jobs/config/upgrade-test.yaml":
    source => "puppet:///modules/jio_pipeline/upgrade-test.yaml",
  }

  file { '/etc/jenkins_jobs/config/run_upgrade.sh':
    content => template('jio_pipeline/run_upgrade.sh.erb'),
  }

}
