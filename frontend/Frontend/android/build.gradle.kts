// Project-level Gradle file for Flutter + Firebase

plugins {
    // Plugin versions are managed in settings.gradle.kts
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register<Delete>("clean") {
    delete(layout.buildDirectory)
}
