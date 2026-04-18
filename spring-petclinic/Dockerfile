# -------- Build stage --------
FROM maven:3.9.9-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy pom first for better caching
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .
COPY src src

# Build jar
RUN mvn clean package -DskipTests

# -------- Run stage --------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy built jar
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar","--server.port=8080"]
