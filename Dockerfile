# Use a base image suitable for running Java applications
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the artifact from the target directory into the container
COPY **/target/*.war /app/app.war

# Expose the port your application listens on
EXPOSE 8080

# Define the command to run your application
CMD ["java", "-jar", "app.war"]
