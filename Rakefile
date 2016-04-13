require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
require_relative './lib/android_docker_image'

def images
  opts = YAML.load_file("build-args.yml")
  AndroidDockerImage.load(opts)
end

task :spec    => 'spec:all'
task :build   => 'build:all'
task :push    => 'push:all'
task :default => :spec

namespace :spec do
  targets = []
  Dir.glob('./spec/*').each do |dir|
    next unless File.directory?(dir)
    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    original_target = target == "_default" ? target[1..-1] : target
    desc "Run serverspec tests to #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = original_target
      t.pattern = "spec/#{original_target}/*_spec.rb"
    end
  end

  namespace :docker do
    namespace :android do
      task :all => images.map(&:tag)
      task :default => :all

      images.each do |image|
        desc "Run serverspec tests to #{image.fullname}"
        RSpec::Core::RakeTask.new(image.tag) do |t|
          ENV['TARGET_HOST'] = 'docker'
          ENV['ANDROID_IMAGE_NAME'] = image.fullname
          ENV['ANDROID_BUILD_TOOLS'] = image.build_tools
          ENV['ANDROID_TARGET_API'] = image.target_api
          t.pattern = "spec/docker/*_spec.rb"
        end
      end
    end
  end
end

namespace :build do
  task :all => images.map(&:tag)

  images.each do |image|
    desc "Build #{image.fullname} image"
    task image.tag do
      sh <<~CMD
        docker build \
          --build-arg ANDROID_BUILD_TOOLS_REVISION=#{image.build_tools} \
          --build-arg ANDROID_PLATFORM_VERSION=#{image.target_api} \
          -t #{image.fullname} \
          .
      CMD
    end
  end
end

namespace :push do
  task :all => images.map(&:tag)

  images.each do |image|
    desc "Push #{image.fullname} image"
    task image.tag do
      sh "docker push #{image.fullname}"
    end
  end
end
