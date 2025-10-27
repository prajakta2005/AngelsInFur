    // File: lib/firebase_options.dart

    import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
    import 'package:flutter/foundation.dart'
        show defaultTargetPlatform, kIsWeb, TargetPlatform;

    /// Default [FirebaseOptions] for specific platforms.
    ///
    /// This class provides the Firebase configuration for different platforms.
    /// You MUST replace the placeholder values with your actual Firebase project
    /// configuration from the Firebase Console.
    class DefaultFirebaseOptions {
      static FirebaseOptions get currentPlatform {
        if (kIsWeb) {
          // Firebase options for Web platform
          return const FirebaseOptions(
            apiKey: "YOUR_WEB_API_KEY", // REPLACE WITH YOUR WEB API KEY
            authDomain: "YOUR_WEB_AUTH_DOMAIN", // REPLACE WITH YOUR WEB AUTH DOMAIN
            projectId: "YOUR_WEB_PROJECT_ID", // REPLACE WITH YOUR WEB PROJECT ID
            storageBucket: "YOUR_WEB_STORAGE_BUCKET", // REPLACE WITH YOUR WEB STORAGE BUCKET
            messagingSenderId: "YOUR_WEB_MESSAGING_SENDER_ID", // REPLACE WITH YOUR WEB MESSAGING SENDER ID
            appId: "YOUR_WEB_APP_ID", // REPLACE WITH YOUR WEB APP ID
            measurementId: "YOUR_WEB_MEASUREMENT_ID", // REPLACE WITH YOUR WEB MEASUREMENT ID (optional)
          );
        }
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            // Firebase options for Android platform.
            // While google-services.json is usually sufficient,
            // explicitly defining options here can be a fallback or for specific setups.
            return const FirebaseOptions(
              apiKey: "YOUR_ANDROID_API_KEY", // REPLACE WITH YOUR ANDROID API KEY (from google-services.json)
              appId: "YOUR_ANDROID_APP_ID", // REPLACE WITH YOUR ANDROID APP ID (from google-services.json)
              messagingSenderId: "YOUR_ANDROID_MESSAGING_SENDER_ID", // REPLACE WITH YOUR ANDROID MESSAGING SENDER ID
              projectId: "YOUR_ANDROID_PROJECT_ID", // REPLACE WITH YOUR ANDROID PROJECT ID (from google-services.json)
              storageBucket: "YOUR_ANDROID_STORAGE_BUCKET", // REPLACE WITH YOUR ANDROID STORAGE BUCKET (from google-services.json)
            );
          case TargetPlatform.iOS:
            // Firebase options for iOS platform (usually handled by GoogleService-Info.plist)
            return const FirebaseOptions(
              apiKey: "YOUR_IOS_API_KEY",
              appId: "YOUR_IOS_APP_ID",
              messagingSenderId: "YOUR_IOS_MESSAGING_SENDER_ID",
              projectId: "YOUR_IOS_PROJECT_ID",
              storageBucket: "YOUR_IOS_STORAGE_BUCKET",
              iosClientId: "YOUR_IOS_CLIENT_ID",
              iosBundleId: "YOUR_IOS_BUNDLE_ID",
            );
          case TargetPlatform.macOS:
            return const FirebaseOptions(
              apiKey: "YOUR_MACOS_API_KEY",
              appId: "YOUR_MACOS_APP_ID",
              messagingSenderId: "YOUR_MACOS_MESSAGING_SENDER_ID",
              projectId: "YOUR_MACOS_PROJECT_ID",
              storageBucket: "YOUR_MACOS_STORAGE_BUCKET",
              iosClientId: "YOUR_MACOS_CLIENT_ID",
              iosBundleId: "YOUR_MACOS_BUNDLE_ID",
            );
          case TargetPlatform.windows:
            return const FirebaseOptions(
              apiKey: "YOUR_WINDOWS_API_KEY",
              appId: "YOUR_WINDOWS_APP_ID",
              messagingSenderId: "YOUR_WINDOWS_MESSAGING_SENDER_ID",
              projectId: "YOUR_WINDOWS_PROJECT_ID",
              storageBucket: "YOUR_WINDOWS_STORAGE_BUCKET",
            );
          case TargetPlatform.linux:
            return const FirebaseOptions(
              apiKey: "YOUR_LINUX_API_KEY",
              appId: "YOUR_LINUX_APP_ID",
              messagingSenderId: "YOUR_LINUX_MESSAGING_SENDER_ID",
              projectId: "YOUR_LINUX_PROJECT_ID",
              storageBucket: "YOUR_LINUX_STORAGE_BUCKET",
            );
          default:
            throw UnsupportedError(
              'DefaultFirebaseOptions are not supported for this platform.',
            );
        }
      }
    }
    