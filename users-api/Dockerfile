FROM openjdk:8-alpine
RUN apk add --update bash curl git
EXPOSE 8083
RUN mkdir /root/che
WORKDIR /usr/src/app
RUN git config --global user.name "Eugene"
RUN chgrp -R 0 /root && \
               chmod -R g+rwX /root && \
               mkdir /projects && \
               chgrp -R 0 /projects && \
               chmod -R g+rwX /projects
COPY pom.xml mvnw ./
COPY .mvn/ ./.mvn
RUN ./mvnw dependency:resolve

COPY . .
RUN ./mvnw install
ENV HOME /root
ENV user.home /root
#ENV M2_HOME /root/.m2
CMD cd /usr/src/app/target && \
    java -jar -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000 -Dserver.port=8083 users-api-0.0.1-SNAPSHOT.jar & \
    tail -f /dev/null