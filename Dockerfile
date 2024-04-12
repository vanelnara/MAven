# Use an official Maven image as a build environment
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container at /app
COPY pom.xml .

# Copy the rest of the application files to the container at /app
COPY src ./src

# Build the application with Maven
RUN mvn clean package

# Use an official OpenJDK runtime image as a base image
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built application JAR file from the build stage to the container at /app
COPY --from=build /app/target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 5000

# Run the application
CMD ["java", "-jar", "app.jar"]
