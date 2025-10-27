plugins {
    // Apply the Android Application plugin
    id("com.android.application")
    // Apply the Kotlin Android plugin with the correct version (2.1.0)
    id("org.jetbrains.kotlin.android") version "2.1.0"
    // Apply the Google Services plugin
    id("com.google.gms.google-services")
    // Apply the Flutter plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Set the namespace for your Android application
    namespace = "com.example.angels_in_fur" // Replace with your actual package name
    // Compile against Android SDK version 34
    compileSdk = 35

    // Configure default settings for your application
    defaultConfig {
        // Set the minimum SDK version required to run the app
        minSdk = flutter.minSdkVersion
        // Set the target SDK version for the app
        targetSdk = 34
        // Define the version code for your app (increment for each release)
        versionCode = flutter.versionCode.toInt()
        // Define the version name for your app (e.g., "1.0.0")
        versionName = flutter.versionName
        // Enable multi-dex support if your app has a large number of methods
        multiDexEnabled = true
    }

    // Configure build types (e.g., debug, release)
    buildTypes {
        release {
            // Enable code shrinking, obfuscation, and optimization for release builds
            signingConfig = signingConfigs.getByName("debug") // Use debug signing for now, configure release signing later
            isShrinkResources = true
            isMinifyEnabled = true
            // Specify the ProGuard rules file for code obfuscation
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    // Configure compile options for Java 8
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    // Configure Kotlin options
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

// Configure Flutter-specific settings
flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM (Bill of Materials)
    // This ensures all Firebase library versions are compatible
    implementation(platform("com.google.firebase:firebase-bom:32.3.1")) // Use the latest stable version
    // Add the dependency for the Firebase Analytics library (now using the main module)
    implementation("com.google.firebase:firebase-analytics") // UPDATED THIS LINE
    // Add other Firebase dependencies as needed, e.g., Firestore, Auth
    // implementation("com.google.firebase:firebase-firestore-ktx")
    // implementation("com.google.firebase:firebase-auth-ktx")
}
