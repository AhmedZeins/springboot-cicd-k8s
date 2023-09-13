# Stage 1: Build the application using Gradle
FROM gradle:7.3-jdk11 as builder
WORKDIR /app

# Copy the Gradle build files first to leverage Docker cache
COPY build.gradle settings.gradle ./
COPY gradlew .
COPY gradle/ ./gradle/
# Copy the source code into the container
COPY src/ ./src/
# build the Spring Boot application 
RUN gradle clean build --no-daemon

# Copy the application source code and resources
COPY src src

# Stage 2: Create a minimal runtime image
FROM adoptopenjdk:11-jre-hotspot


# Copy the built JAR file from the previous stage
COPY --from=builder /app/build/libs/demo-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port that  Spring Boot application listens on
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

