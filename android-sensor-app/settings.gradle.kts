// settings.gradle.kts : point d'entrée Gradle, indique quels modules font partie du build.

pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    // FAIL_ON_PROJECT_REPOS = chaque dep doit venir d'un repo déclaré ici, pas dans les modules.
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "indoor-mapper"
include(":app")
