# Version 1.0

FROM debian:jessie

MAINTAINER izumin5210 <masayuki@izumin.info>

ENV GRADLE_VERSION 2.6
ENV ANDROID_SDK_REVISION 24.3.4
ENV ANDROID_BUILD_TOOOS_REVISION 23.0.1
ENV ANDROID_PLATFORM_VERSION 23

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install unzip
RUN apt-get -y install libncurses5:i386
RUN apt-get -y install libstdc++6:i386
RUN apt-get -y install zlib1g:i386
RUN apt-get -y install openjdk-7-jdk

RUN curl -L -O "http://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip"
RUN unzip -o "gradle-$GRADLE_VERSION-all.zip"
RUN mv "gradle-$GRADLE_VERSION" "/usr/local/gradle-$GRADLE_VERSION"
ENV GRADLE_HOME "/usr/local/gradle-$GRADLE_VERSION"
ENV PATH $PATH:$GRADLE_HOME/bin

RUN curl -L -O "http://dl.google.com/android/android-sdk_r$ANDROID_SDK_REVISION-linux.tgz"
RUN tar -xvzf "android-sdk_r$ANDROID_SDK_REVISION-linux.tgz"
RUN mv android-sdk-linux /usr/local/android-sdk

ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

RUN rm android-sdk_r$ANDROID_SDK_REVISION-linux.tgz

RUN echo "y" | android update sdk --no-ui --force --filter platform-tools
RUN echo "y" | android update sdk --no-ui --force --filter android-$ANDROID_PLATFORM_VERSION
RUN echo "y" | android update sdk --no-ui --force --filter build-tools-$ANDROID_BUILD_TOOOS_REVISION

RUN apt-get clean
