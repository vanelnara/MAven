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

# Use an official Tomcat image as a base image
FROM tomcat:9.0.55-jdk8-corretto

# Create a non-root user and group with explicit IDs
RUN groupadd -r -g 1001 myappgroup && useradd -r -u 1001 -g myappgroup myappuser

# Set the working directory in the container
WORKDIR /usr/local/tomcat/webapps

# Copy the war file from the build stage to the webapps directory of Tomcat
COPY target/vprofile-v2.war /usr/local/tomcat/webapps/

# Expose the port the Tomcat server runs on
EXPOSE 8080

# Change the owner of the app directory to the non-root user
RUN chown myappuser:myappgroup /usr/local/tomcat/webapps -R

# Switch to the non-root user
USER myappuser

# Start Tomcat
CMD ["catalina.sh", "run"]
