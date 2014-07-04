Welcome to the awesome world of CI/CD

Steps for to configure Jenkins, etc:

Install Jenkins

    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install jenkins


Install `python-jenkins` and `jenkins-job-builder`

    pip install python-jenkins
    pip install -e git+https://github.com/openstack-infra/jenkins-job-builder#egg=jenkins_job_builder


A file `/etc/jenkins_jobs/jenkins_jobs.rst` should be created with the following contents (or any other username/password)

    [jenkins]
    user=admin
    password=admin
    url=http://localhost:8080/


Install 'copy artifact' plugin. If not able to install from web UI, download it from `https://updates.jenkins-ci.org/download/plugins/`.

To configure jobs from yaml files, `cd` into the repository, and run

    jenkins-jobs update /path/to/yaml/file.yaml

