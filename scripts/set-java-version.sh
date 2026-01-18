#!/bin/bash
source "$(dirname "$0")/utils.sh"

ANDROID_VER=$1

print_header "Setting Java Version"

case "$ANDROID_VER" in
    android-16.0|android-15.0|android-14.0|android-13.0)
        print_info "Using Java 17 for Android 13+"
        sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
        sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac
        ;;
    android-12.1|android-12.0)
        print_info "Using Java 11 for Android 12"
        sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java
        sudo update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac
        ;;
    android-11.0|android-10.0)
        print_info "Using Java 8 for Android 10-11"
        sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
        sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
        ;;
    *)
        print_warning "Unknown Android version, defaulting to Java 17"
        sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
        sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac
        ;;
esac

echo ""
print_success "Java version configured:"
java -version 2>&1 | head -1
