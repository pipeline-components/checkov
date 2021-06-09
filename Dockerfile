# ==============================================================================
# Add https://gitlab.com/pipeline-components/org/base-entrypoint
# ------------------------------------------------------------------------------
FROM pipelinecomponents/base-entrypoint:0.4.0 as entrypoint

# ==============================================================================
# Component specific
# ------------------------------------------------------------------------------
FROM python:3.9.5-alpine3.13
ENV PYTHONUSERBASE /app
WORKDIR /app/
COPY app /app/
RUN pip install --no-cache-dir -r requirements.txt

# ==============================================================================
# Generic for all components
# ------------------------------------------------------------------------------
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD _template_

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
