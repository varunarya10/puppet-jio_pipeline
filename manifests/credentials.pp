#
# lays down the credential files that are used by each
# job that requires connections to these external systems
#
class jio_pipeline::credentials(
  $svn_password,
  $svn_user,
  $cloud_username,
  $cloud_password,
){

  File {
    notify  => Exec['jenkins_jobs_update'],
    require => Exec['install_jenkins_job_builder'],
  }

  file { "/etc/jenkins_jobs/config/generate_credentials.sh":
    content => template('jio_pipeline/generate_credentials.sh.erb'),
    owner  => 'root',
    group  => 'root',
  }

}
