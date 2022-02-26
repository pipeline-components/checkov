# ==============================================================================
# Add https://gitlab.com/pipeline-components/org/base-entrypoint
# ------------------------------------------------------------------------------
FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

# ==============================================================================
# Build process
# ------------------------------------------------------------------------------
FROM python:3.10.2-alpine3.14 as build
ENV PYTHONUSERBASE /app
ENV PATH "$PATH:/app/bin/"

WORKDIR /app/
COPY app /app/

# Adding dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache libffi && \
    apk add --no-cache --virtual .build \
    build-base libffi-dev

# hadolint ignore=DL3013
RUN pip3 install --user --no-cache-dir --prefer-binary  \
        --find-links https://wheels.home-assistant.io/alpine-3.14/amd64/ \
        --find-links https://wheels.home-assistant.io/alpine-3.14/aarch64/ \
        -r requirements.txt

# ==============================================================================
# Component specific
# ------------------------------------------------------------------------------
FROM python:3.10.2-alpine3.14

# Adding dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache git libffi

ENV PATH "$PATH:/app/bin/"
ENV PYTHONUSERBASE /app
COPY --from=build /app /app

# ==============================================================================
# Generic for all components
# ------------------------------------------------------------------------------
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD checkov

WORKDIR /code/

# ==============================================================================
# Container meta information
# ------------------------------------------------------------------------------
ARG BUILD_DATE
ARG BUILD_REF

LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.opencontainers.image.title="Checkov" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Pipeline Components" \
    org.opencontainers.image.authors="Robbert Müller <spam.me@grols.ch>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://pipeline-components.dev/" \
    org.opencontainers.image.source="https://gitlab.com/pipeline-components/checkov/" \
    org.opencontainers.image.documentation="https://gitlab.com/pipeline-components/checkov/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.description="Checkov in a container for gitlab-ci" \
    org.label-schema.name="Checkov" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.dev/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/checkov/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/checkov/" \
    org.label-schema.vendor="Pipeline Components"
