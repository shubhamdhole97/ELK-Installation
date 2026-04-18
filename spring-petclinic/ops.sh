#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Cleaning project (skipping tests)..."
mvn clean -DskipTests

echo "Packaging project (skipping tests)..."
mvn package -DskipTests

echo "Running the JAR file..."
java -jar target/*.jar
