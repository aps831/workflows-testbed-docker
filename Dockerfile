# syntax=docker/dockerfile:1.3
FROM maven:3.8.6-openjdk-11@sha256:805f366910aea2a91ed263654d23df58bd239f218b2f9562ff51305be81fa215 AS build
ARG ENFORCER_FAIL

RUN groupadd -r -g 1000 maven && useradd -m -l -r -u 1000 -g maven maven
ENV MAVEN_CONFIG /home/maven/.m2
ENV MAVEN_OPTS -Duser.home=/home/maven
USER maven

WORKDIR /app
COPY --chown=maven:maven . /app

ARG MAVEN_PHASE
RUN --mount=type=cache,uid=1000,gid=1000,target=/home/maven/.m2\
    --mount=type=secret,uid=1000,gid=1000,id=GITHUB_USER_REF\
    --mount=type=secret,uid=1000,gid=1000,id=GITHUB_TOKEN_REF\
    GITHUB_USER_REF="$(cat /run/secrets/GITHUB_USER_REF)" && \
    GITHUB_TOKEN_REF="$(cat /run/secrets/GITHUB_TOKEN_REF)" && \
    export GITHUB_USER_REF && \
    export GITHUB_TOKEN_REF && \
    echo "0" > EXIT_STATUS_FILE && \
    mvn --settings settings.xml --batch-mode $MAVEN_PHASE -Denforcer.fail=$ENFORCER_FAIL || echo $? > EXIT_STATUS_FILE

RUN mkdir -p target && touch target/.nonempty

FROM scratch AS output
COPY --from=build /app/target/ /

FROM build AS status
COPY --from=build /app/EXIT_STATUS_FILE/ /EXIT_STATUS_FILE
RUN exit $(cat /EXIT_STATUS_FILE)

FROM eclipse-temurin:11@sha256:9de4aabba13e1dd532283497f98eff7bc89c2a158075f0021d536058d3f5a082
RUN mkdir /opt/app
COPY --from=build /app/target/testbed-docker-1.0.0-jar-with-dependencies.jar /opt/app
CMD ["java", "-jar", "/opt/app/testbed-docker-1.0.0-jar-with-dependencies.jar"]
