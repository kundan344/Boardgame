# Use OpenJDK 17 on Alpine as the base image
FROM openjdk:17-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built jar file from the target directory of your local machine to the container
COPY target/*.jar /app/app.jar

# Expose port 8080 for communication (assuming the app runs on port 8080)
EXPOSE 8080

# Use ENTRYPOINT to avoid overriding the command accidentally and run the jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]





