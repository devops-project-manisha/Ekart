FROM eclipse-temurin:17.0.17_10-jre-alpine-3.22

WORKDIR /app
COPY target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
