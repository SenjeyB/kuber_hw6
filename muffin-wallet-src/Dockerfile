FROM gradle:8.5-jdk21 AS builder

WORKDIR /app

COPY build.gradle settings.gradle gradle.properties ./
COPY muffin-wallet-api ./muffin-wallet-api
COPY muffin-wallet-data ./muffin-wallet-data
COPY muffin-wallet-data-api ./muffin-wallet-data-api
COPY muffin-wallet-server ./muffin-wallet-server

RUN gradle clean build -x test --no-daemon

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/muffin-wallet-server/build/libs/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]
