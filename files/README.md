Install Jenkins

    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install jenkins


Install `python-jenkins` and `jenkins-job-builder`

    pip install python-jenkins
    pip install -e git+https://github.com/openstack-infra/jenkins-job-builder#egg=jenkins_job_builder


Create a file `/etc/jenkins_jobs/jenkins_jobs.ini` with the following contents (or any other username/password)

    [job_builder]
    ignore_cache=True

    [jenkins]
    user=admin
    password=admin
    url=http://localhost:8080/


Install the 'Copy Artifact' and 'Parameterized Trigger' plugins. If not able to install from web UI, download them from `https://updates.jenkins-ci.org/download/plugins/`.

To configure jobs from yaml files, `cd` into the repository, and run

    jenkins-jobs update /path/to/yaml/file.yaml


NOTE: For running the script `spawn_resources.bin`, you need to have the
customized version of neutronclient installed, which you can get from contrail
repo, located in the repo server at `10.135.96.60`. Also, you need to install
`python-glanceclient`. Do it like so: `sudo apt-get install glance`.

NOTE: In order for the Jenkins jobs to function properly, atleast two snapshots
need to be present in snapshots directory.
