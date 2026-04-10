import org.gradle.api.tasks.Copy

plugins {
    id("com.android.application")
    id("kotlin-android")

    // Firebase Plugin
    id("com.google.gms.google-services")

    // Flutter plugin must be the last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.tajweed_corrector"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.tajweed_corrector"
        minSdk = flutter.minSdkVersion  // Firebase Auth requires minSdk >= 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            // Use debug key for now (change later for Play Store)
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    buildFeatures {
        buildConfig = true
    }

    packagingOptions {
        exclude("META-INF/proguard/androidx-*.pro")
    }
}

val flutterExpectedApkDir = rootProject.projectDir.parentFile.resolve("build/app/outputs/flutter-apk")

tasks.register<Copy>("copyDebugApkForFlutterTool") {
    dependsOn("packageDebug")
    from(layout.buildDirectory.file("outputs/apk/debug/app-debug.apk"))
    into(flutterExpectedApkDir)
    rename { "app-debug.apk" }
}

tasks.register<Copy>("copyReleaseApkForFlutterTool") {
    dependsOn("packageRelease")
    from(layout.buildDirectory.file("outputs/apk/release/app-release.apk"))
    into(flutterExpectedApkDir)
    rename { "app-release.apk" }
}

afterEvaluate {
    tasks.matching { it.name == "assembleDebug" }.configureEach {
        finalizedBy("copyDebugApkForFlutterTool")
    }
    tasks.matching { it.name == "assembleRelease" }.configureEach {
        finalizedBy("copyReleaseApkForFlutterTool")
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.0.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-storage")
}

flutter {
    source = "../.."
}

// Apply Firebase Google services
apply(plugin = "com.google.gms.google-services")
