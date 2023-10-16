# syntax=docker/dockerfile:1.5
FROM maven:3.8.2-openjdk-11@sha256:4b9d059560ebaed5bcdd320be71968c457b655887bf04380c150c22531dd9e7a AS build
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
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

FROM eclipse-temurin:21@sha256:9d007c093e624bc410f113ee09f5209d3263e0bada7524e4de99eac9fbef06a5
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
ARG ARTIFACT_VERSION
RUN mkdir /opt/app
COPY --from=build /app/target/testbed-docker-$ARTIFACT_VERSION-jar-with-dependencies.jar /opt/app
CMD ["java", "-jar", "/opt/app/testbed-docker-$ARTIFACT_VERSION-jar-with-dependencies.jar"]
