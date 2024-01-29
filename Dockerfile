# 빌드 스테이지
FROM amazoncorretto:17.0.7-alpine AS builder
USER root
WORKDIR /front
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
# gradlew 실행 권한 부여
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

# 실행 스테이지
FROM openjdk:17
WORKDIR /front
COPY --from=builder /front/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
VOLUME /tmp
EXPOSE 8080