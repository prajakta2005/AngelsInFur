// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Corrected Kotlin DSL syntax for classpath dependencies
        // Ensure this is your current Android Gradle Plugin version
        classpath("com.android.tools.build:gradle:8.1.1") 
        // ADDED THIS LINE for Google Services plugin
        classpath("com.google.gms:google-services:4.3.15") 
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Define a new build directory outside the project root
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Apply the new build directory to subprojects
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensure the 'app' project is evaluated before other subprojects (important for plugin application)
subprojects {
    project.evaluationDependsOn(":app")
}

// Task to clean the build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
