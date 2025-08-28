import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.muhammetkaman.destek_saci"

    // Flutter plugin değerlerini kullanmak istersen:
    // compileSdk = flutter.compileSdkVersion
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        // Java 17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.muhammetkaman.destek_saci"

        // KTS söz dizimi:
        minSdk = flutter.minSdkVersion
        targetSdk = 35

        versionCode = 7
        versionName = "1.0.7"

        // minSdk 21 ve üzeri için multidex gerekmiyor, ama dursa da sorun değil
        multiDexEnabled = true

        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }

    signingConfigs {
        create("release") {
            // key.properties yoksa bu alanı try/catch veya exists kontrolü ile sarman iyi olur
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") {
            // İmzalı debug’a ihtiyacın yoksa bu satırı kaldırabilirsin
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    implementation("com.google.android.play:review:2.0.1")
    implementation("com.google.android.play:review-ktx:2.0.1")
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("androidx.core:core-ktx:1.12.0")
    // Kotlin stdlib'i el ile eklemeyelim; plugin yönetiyor. Şu satırı kaldırdım:
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.0")
}

flutter {
    source = "../.."
}
