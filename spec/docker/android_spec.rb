require "spec_helper"

image_name = ENV['ANDROID_IMAGE_NAME']
build_tools = ENV['ANDROID_BUILD_TOOLS']
target_api = ENV['ANDROID_TARGET_API']

describe image_name do

  before(:all) do
    set :backend, :docker
    set :docker_url, ENV['DOCKER_HOST']
    set :os, family: 'ubuntu', arch: 'x86_64'
    docker_image = Docker::Image.get(image_name)
    set :docker_image, docker_image.id

  end

  describe command("echo $ANDROID_HOME") do
    its(:stdout) { is_expected.to be_include("/usr/local/android-sdk") }
  end

  describe command("echo $PATH") do
    its(:stdout) { is_expected.to be_include("/usr/local/android-sdk/tools") }
    its(:stdout) { is_expected.to be_include("/usr/local/android-sdk/platform-tools") }
  end

  describe command("echo $GRADLE_HOME") do
    its(:stdout) { is_expected.not_to be_empty }
  end

  describe command("echo $JAVA_HOME") do
    its(:stdout) { is_expected.not_to be_empty }
  end

  describe command("android list target") do
    its(:stdout) { is_expected.to be_include("android-#{target_api}") }
  end

  describe command("ls $ANDROID_HOME/build-tools") do
    its(:stdout) { is_expected.to be_include(build_tools) }
  end
  end
