require "spec_helper"

yaml = YAML.load_file("build-args.yml")
images = AndroidDockerImage.load(yaml)

describe "DockerImage" do
  images.each do |image|

    describe image.fullname do
      before(:all) do
        docker_image = Docker::Image.get(image.fullname)
        set :backend, :docker
        set :docker_url, ENV['DOCKER_HOST']
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

      describe command("echo JAVA_HOME") do
        its(:stdout) { is_expected.not_to be_empty }
      end

      describe command("android list target") do
        its(:stdout) { is_expected.to be_include("android-#{image.target_api}") }
      end

      describe command("ls $ANDROID_HOME/build-tools") do
        its(:stdout) { is_expected.to be_include(image.build_tools) }
      end
    end
  end
end
