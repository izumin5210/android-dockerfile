# Docker images for Android app/library
[![Circle CI](https://circleci.com/gh/izumin5210/android-dockerfile/tree/master.svg?style=svg)](https://circleci.com/gh/izumin5210/android-dockerfile/tree/master)

## Usage
Edit your settings:

```yaml
repo: izumin5210/android
tag: "build-tools-%{build_tools}_target-api-%{target_api}"
build-tools:
  - "23.0.2"
  - "23.0.1"
target-api:
  - "23"
  - "22"
```

You can run following commands:

```
# build specific image
$ rake build:build-tools-23.0.2_target-api-23

# build all images
$ rake build

# run spec for images
$ rake spec

# push specific image
$ rake push:build-tools-23.0.2_target-api-23

# push all images
$ rake push
```

## LICENSE
licensed under [MIT License](https://izumin.mit-license.org/2016).
