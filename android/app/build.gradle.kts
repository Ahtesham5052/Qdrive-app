plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.chimpstudio.qdrive"

    // Replace with explicit SDK versions
    compileSdkVersion(36) // Set this explicitly

    // Set NDK version explicitly
     ndkVersion = "27.0.12077973" // Use your installed or required version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17" // Updated to Kotlin DSL way
    }

    defaultConfig {
        // Your unique application ID
        applicationId = "com.chimpstudio.qdrive"

        // Replace with your app's required SDK versions
        minSdk = flutter.minSdkVersion // Minimum SDK version (set to 21 or as needed)
        targetSdk = 36 // Target SDK version (set to 33 or as needed)

        // Flutter version settings (or set manually)
        versionCode = 1 // Set version code for your app
        versionName = "1.0.0" // Set version name
    }

    buildTypes {
        release {
            // Add signing config for release if required
            signingConfig = signingConfigs.getByName("debug") // Temporarily use debug signing
        }
    }
}

flutter {
    // This points to your Flutter project root
    source = "../.."
}
