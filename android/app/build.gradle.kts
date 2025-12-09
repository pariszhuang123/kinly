import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Generates firebase_options.xml from flavor-specific google-services.json files
    id("com.google.gms.google-services")
}

// Optional: load signing keys if present
val keystoreProps = Properties().apply {
    // Look for key.properties in the *app module* directory
    val f = file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
fun kp(name: String) = keystoreProps.getProperty(name)
val hasKeystore = file("key.properties").exists()

android {
    namespace = "com.makinglifeeasie.kinly"
    compileSdk = flutter.compileSdkVersion
    // Override to match plugins requiring NDK r27
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // Enable if using newer java.time APIs on older devices
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.makinglifeeasie.kinly"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Prefer CI-provided build number if set; otherwise fall back to pubspec
        versionCode = System.getenv("BUILD_NUMBER")?.toIntOrNull() ?: flutter.versionCode
        versionName = flutter.versionName

        // Default placeholders (can be overridden by productFlavors)
        manifestPlaceholders["deeplinkHost"] = "dev.example.com"
        manifestPlaceholders["appName"] = "Kinly (Dev)"
        manifestPlaceholders["supabaseScheme"] = "io.supabase.flutter"
        manifestPlaceholders["supabaseHost"] = "callback"
    }

    // Configure signing when key.properties is present (declare before buildTypes)
    signingConfigs {
        if (hasKeystore) {
            // Modify the existing debug config instead of creating a duplicate
            getByName("debug") {
                keyAlias = kp("debugKeyAlias")
                keyPassword = kp("debugKeyPassword")
                storeFile = file("dev_keystore.jks")
                storePassword = kp("debugStorePassword")
                storeType = "JKS"
            }
            create("release") {
                keyAlias = kp("prodKeyAlias")
                keyPassword = kp("prodKeyPassword")
                storeFile = file("prod_keystore.jks")
                storePassword = kp("prodStorePassword")
                storeType = "JKS"
            }
        }
    }

    buildTypes {
        release {
            // Use release keystore when available; otherwise fall back to debug signing
            signingConfig = if (hasKeystore) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
        }
    }

    // Flavor setup for dev/prod
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            // Explicit app id is clearer and matches previous app
            applicationId = "com.makinglifeeasie.kinly.dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["deeplinkHost"] = "dev.example.com"
            manifestPlaceholders["appName"] = "Kinly (Dev)"
        }
        create("prod") {
            dimension = "env"
            applicationId = "com.makinglifeeasie.kinly"
            manifestPlaceholders["deeplinkHost"] = "example.com"
            manifestPlaceholders["appName"] = "Kinly"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Support newer Java APIs (e.g., java.time) on older Android
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
