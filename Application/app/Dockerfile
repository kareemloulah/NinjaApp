FROM openjdk:26-ea-17-jdk-slim AS build_image
WORKDIR /app
RUN apt update && apt install maven git -y
COPY . .
COPY application.properties src/main/resources/application.properties
RUN mvn clean install -Dskiptests

FROM tomcat:9-jre11

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build_image /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]