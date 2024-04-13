# Use an official Maven image as a build environment
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container at /app
COPY pom.xml .

# Copy the rest of the application files to the container at /app
COPY src ./Maven_lab/src

# Build the application with Maven
RUN mvn clean package

# Use an official OpenJDK runtime image as a base image
FROM openjdk:17-jdk-alpine

# Create a non-root user
RUN addgroup -S myappgroup && adduser -S myappuser -G myappgroup

# Set the working directory in the container
WORKDIR /app

# Copy the built application JAR file from the build stage to the container at /app
COPY --from=build /Maven_lab/target/MAven-*.jar 

# Change the owner of the app directory to the non-root user
RUN chown myappuser:myappgroup /app -R

# Expose the port the application runs on
EXPOSE 8080

# Switch to the non-root user
USER myappuser

# Run the application
CMD ["java", "-jar", "MAven-*.jar"]
