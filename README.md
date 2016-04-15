# Docker images for Android app/library
## Usage

```
$ docker pull izumin5210/android:build-tools-<BUILD_TOOLS_VERSION>_target-api-<TARGET_API_VERSION>
```

| build tools | target api | tag |
| --- | --- | --- |
| 23.0.3 | 23 | `build-tools-23.0.3_target-api-23` |
| 23.0.3 | 22 | `build-tools-23.0.3_target-api-22` |
| 23.0.2 | 23 | `build-tools-23.0.2_target-api-23` |
| 23.0.2 | 22 | `build-tools-23.0.2_target-api-22` |
| 23.0.1 | 23 | `build-tools-23.0.1_target-api-23` |
| 23.0.1 | 22 | `build-tools-23.0.1_target-api-22` |

## Customize
Edit settings:

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
