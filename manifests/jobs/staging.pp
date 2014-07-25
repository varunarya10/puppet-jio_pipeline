class jio_pipeline::jobs::staging{

  File {
    notify  => Exec['jenkins_jobs_update'],
    require => Exec['install_jenkins_job_builder'],
    owner  => 'root',
    group  => 'root',
  }

  file { "/etc/jenkins_jobs/config/staging-test.yaml":
    source => "puppet:///modules/jio_pipeline/staging-test.yaml",
  }

  file { '/etc/jenkins_jobs/config/run_staging.sh':
    content => template('jio_pipeline/run_staging.sh.erb'),
  }

}
