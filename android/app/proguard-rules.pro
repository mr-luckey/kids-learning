# Keep Flutter and plugin entry points
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep entry points for reflection-based libraries (adjust if needed)
-keep class androidx.lifecycle.DefaultLifecycleObserver { *; }
-keep class androidx.lifecycle.LifecycleObserver { *; }
-keep class androidx.lifecycle.ProcessLifecycleOwner { *; }
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.errorprone.annotations.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Prevent R8 from failing if Play Core classes are referenced but not present
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Keep enums' values() and valueOf()
-keepclassmembers enum * { **[] $VALUES; public *; }

# App package models (adjust as needed)
-keep class com.appware.kidlearning.** { *; }
