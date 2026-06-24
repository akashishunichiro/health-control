#!/usr/bin/env bash
# Health Control loyihasi uchun dasturlash muhiti.
# Ishlatish:  source "env.sh"
# So'ng:      flutter doctor

export JAVA_HOME="$HOME/development/jdk-17.0.19+10"
export ANDROID_HOME="$HOME/development/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$HOME/development/flutter/bin:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "[env] Flutter: $(command -v flutter || echo 'topilmadi')"
echo "[env] Java:    $JAVA_HOME"
echo "[env] Android: $ANDROID_HOME"
