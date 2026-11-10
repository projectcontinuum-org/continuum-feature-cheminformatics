plugins {
    id("org.projectcontinuum.worker")
}

group = "org.projectcontinuum.app.worker.example"
description = "Continuum Feature Example Worker — Spring Boot worker application for example feature nodes"
version = property("featureVersion").toString()

val continuumPlatformVersion = property("continuumPlatformVersion").toString()

continuum {
    continuumVersion.set(continuumPlatformVersion)
    // Base image with the Claude Code CLI, shell tools and python3 (built from docker/agent-worker-base).
    // Override with -PworkerBaseImage=... for local builds.
    jibFromImage.set("eclipse-temurin:21-jre")
    // Container image pushed by `./gradlew :worker:jib` (see .github/workflows/on-release.yml)
    jibToImage.set("projectcontinuum/continuum-feature-base:${project.version}")
}

dependencies {
    implementation(project(":features:continuum-feature-rdkit"))
}
