# 운영 이미지는 Temurin 17 JDK alpine 이다. 그 이미지는 arm64 판이 없어 같은 musl 기반 OpenJDK 17 인 Corretto alpine 을 쓴다.
FROM amazoncorretto:17-alpine-jdk

ARG PINPOINT_VERSION=2.5.3
# entrypoint.sh 가 에이전트 JAR 경로를 같은 버전으로 찾는다
ENV PINPOINT_VERSION=${PINPOINT_VERSION}
WORKDIR /app

# 공개 릴리스 에이전트를 받고, release 프로필에 운영이 바꾼 값(pinpoint-overrides.config)을 덮어쓴다
COPY pinpoint-overrides.config /tmp/overrides.config
RUN wget -q https://github.com/pinpoint-apm/pinpoint/releases/download/v${PINPOINT_VERSION}/pinpoint-agent-${PINPOINT_VERSION}.tar.gz \
 && mkdir pinpoint-agent && tar -xzf pinpoint-agent-${PINPOINT_VERSION}.tar.gz -C pinpoint-agent --strip-components=1 \
 && rm pinpoint-agent-${PINPOINT_VERSION}.tar.gz \
 && cfg=pinpoint-agent/profiles/release/pinpoint.config \
 && grep -v '^#' /tmp/overrides.config | while IFS='=' read -r key value; do \
      if grep -q "^${key}=" $cfg; then sed -i "s|^${key}=.*|${key}=${value}|" $cfg; else echo "${key}=${value}" >> $cfg; fi; \
    done

COPY build/libs/app.jar app.jar
COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["sh", "/app/entrypoint.sh"]
