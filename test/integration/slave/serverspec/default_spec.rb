require 'spec_helper'

jenkins_user = 'jenkins'
jenkins_group = jenkins_user
jenkins_http_port = 8080
jenkins_plugins_dir = "/var/lib/jenkins/plugins"

jenkins_prereq_pkgs = %w( build-essential curl unzip git python-dev python-pip )
jenkins_plugins = %w( 
    ansicolor authentication-tokens build-monitor-plugin build-name-setter
    build-pipeline-plugin claim copyartifact credentials credentials-binding
    dashboard-view delivery-pipeline-plugin plain-credentials workflow-step-api )

jenkins_prereq_pkgs.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe package('jenkins') do
  it { should be_installed }
end

describe group(jenkins_group) do
  it { should exist }
end

describe user(jenkins_user) do
  it { should exist }
  it { should belong_to_group jenkins_group }
end

jenkins_plugins.each do |plugin|
  describe file("#{jenkins_plugins_dir}/#{plugin}") do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by jenkins_user }
  end
end

describe file('/etc/default/jenkins') do
  it { should be_file }
  it { should be_mode 644 }
end

describe service('jenkins') do
  it { should be_running }
end

describe port(jenkins_http_port) do
  it { should be_listening }
end


#######################################
# google-chrome

describe package('google-chrome-stable') do
  it { should be_installed }
end

describe file('/usr/local/share/chromedriver') do
  it { should be_file }
  it { should be_mode 755 }
end

describe file('/usr/bin/chromedriver') do
  it { should exist }
  it { should be_symlink }
end