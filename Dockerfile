# Use the Tomcat base image
FROM tomcat:9.0.99-jdk8-corretto

# Copy the .war file into the webapps directory of Tomcat
COPY target/vprofile-v2.war /usr/local/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

