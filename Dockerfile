FROM ubuntu:20.04

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV CI "true"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y locales && \
  locale-gen en_US.UTF-8 && \
  apt-get install -y wget unzip locales ruby ruby-dev openjdk-8-jdk qemu-kvm build-essential

RUN gem install bundler --no-document

ARG androidSdkRoot=/opt/android-sdk
ENV ANDROID_SDK_ROOT=${androidSdkRoot}
ENV ANDROID_HOME=${androidSdkRoot}
ENV ADB_INSTALL_TIMEOUT=120
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/emulator:$ANDROID_HOME/platform-tools:${PATH}

RUN mkdir ${androidSdkRoot} && \
  wget https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip -O commandlinetools-linux.zip && \
  unzip commandlinetools-linux.zip -d ${androidSdkRoot}/cmdline-tools && \
  rm commandlinetools-linux.zip

RUN (yes | sdkmanager --licenses) && \
  sdkmanager "emulator" "platform-tools"

RUN apt-get clean
