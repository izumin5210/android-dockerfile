# Version 1.0

FROM java:openjdk-8-jdk

MAINTAINER izumin5210 <masayuki@izumin.info>

ARG ANDROID_BUILD_TOOLS_REVISION
ARG ANDROID_PLATFORM_VERSION

# ================================================================
# apt
# ================================================================

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y install \
        curl \
        unzip \
        libncurses5:i386 \
        libstdc++6:i386 \
        zlib1g:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# ================================================================
# gradle
# ================================================================

ENV GRADLE_VERSION 2.14
RUN curl -L -O "http://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip" \
    && unzip -q -o "gradle-$GRADLE_VERSION-all.zip" \
    && mv "gradle-$GRADLE_VERSION" "/usr/local/gradle-$GRADLE_VERSION" \
    && rm gradle-$GRADLE_VERSION-all.zip

ENV GRADLE_HOME "/usr/local/gradle-$GRADLE_VERSION"
ENV PATH $PATH:$GRADLE_HOME/bin


# ================================================================
# android sdk
# ================================================================

ENV ANDROID_SDK_REVISION 24.4.1

RUN curl -L -O "http://dl.google.com/android/android-sdk_r$ANDROID_SDK_REVISION-linux.tgz" \
    && tar --no-same-owner -xzf "android-sdk_r$ANDROID_SDK_REVISION-linux.tgz" \
    && mv android-sdk-linux /usr/local/android-sdk \
    && rm android-sdk_r$ANDROID_SDK_REVISION-linux.tgz

ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools


# ================================================================
# android sdk components
# ================================================================

ENV ANDROID_EMULATOR_ABI armeabi-v7a
ENV ANDROID_EMULATOR_TARGET_NAME android-emulator

RUN echo y | android --silent update sdk --no-ui --all --force --filter \
        platform-tools,build-tools-$ANDROID_BUILD_TOOLS_REVISION,android-$ANDROID_PLATFORM_VERSION \
    && echo y | android --silent update sdk --no-ui --all --force --filter \
        extra-google-m2repository,extra-android-support,extra-android-m2repository \
    && echo y | android --silent update sdk --no-ui --all --force --filter \
        sys-img-$ANDROID_EMULATOR_ABI-android-$ANDROID_PLATFORM_VERSION


# ================================================================
# scripts
# ================================================================

COPY wait-for-emulator /usr/local/bin/
COPY start-emulator /usr/local/bin/
