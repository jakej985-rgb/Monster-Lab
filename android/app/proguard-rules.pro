# Flutter ProGuard / R8 Rules for Monster Lab
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# SharedPreferences and Local Storage
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Flutter Play Store Split Application & Deferred Components (R8 missing classes suppression)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Preserve custom USB host and serial classes
-keep class android.hardware.usb.** { *; }

# Preserve synthetic members and line numbers for stack traces
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
