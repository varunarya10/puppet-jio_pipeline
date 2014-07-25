class jio_pipeline::jobs::non_functional{

  File {
    notify  => Exec['jenkins_jobs_update'],
    require => Exec['install_jenkins_job_builder'],
    owner  => 'root',
    group  => 'root',
  }

  file { "/etc/jenkins_jobs/config/non-functional-test.yaml.yaml":
    source => "puppet:///modules/jio_pipeline/non-functional-test.yaml",
  }

  file { '/etc/jenkins_jobs/config/run_nft.sh':
    content => template('jio_pipeline/run_nft.sh.erb'),
  }


}
