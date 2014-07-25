class jio_pipeline::jobs::acceptance(
  $proxy,
  $repo_server,
  $devstack_ip,
  $git_server,
) {

  include jio_pipeline::credentials

  File {
    notify  => Exec['jenkins_jobs_update'],
    require => Exec['install_jenkins_job_builder'],
    owner  => 'root',
    group  => 'root',
  }

  file { "/etc/jenkins_jobs/config/acceptance-test.yaml":
    source => "puppet:///modules/jio_pipeline/acceptance-test.yaml",
  }

  file { '/etc/jenkins_jobs/config/run_acceptance.sh':
    content => template('jio_pipeline/run_acceptance.sh.erb'),
  }

}
