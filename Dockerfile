FROM python:3.8.0-alpine3.10

ENV TERRAFORM_VERSION=0.12.12
ENV TERRAFORM_SHA256SUM=67bc7a49c0946ad48b14cc6e95482fdd3e7e9f7dc6811f4ce6ff531fc565bd3a
ENV TERRAFORM_DOWNLOAD_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ENV TERRAFORM_DOWNLOAD_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ENV TFLINT_VERSION=0.12.1
ENV TFLINT_SHA256SUM=5ae01a03a1c0ed0359bd795de735ce5fc8984611cd58866f67a545d7a17209c6
ENV TFLINT_DOWNLOAD_URL=https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip

ENV AWS_CLI_VERSION=1.14.32
ENV S3_CMD_VERSION=2.0.1

RUN apk add --no-cache \
        bash \
        curl \
        git \
        jq \
        zip

RUN curl -o /tmp/terraform.zip -L "${TERRAFORM_DOWNLOAD_URL}" \
        && echo "${TERRAFORM_SHA256SUM}  /tmp/terraform.zip" > /tmp/terraform.sha256sum \
        && sha256sum -cs /tmp/terraform.sha256sum \
        && unzip /tmp/terraform.zip \
        && mv terraform /bin \
        && rm /tmp/terraform.*

RUN curl -o /tmp/tflint.zip -L "${TFLINT_DOWNLOAD_URL}" \
        && echo "${TFLINT_SHA256SUM}  /tmp/tflint.zip" > /tmp/tflint.sha256sum \
        && sha256sum -cs /tmp/tflint.sha256sum \
        && unzip /tmp/tflint.zip \
        && mv tflint /bin \
        && rm /tmp/tflint.*

RUN apk add --no-cache \
        build-base>=0.5-r1 \
        graphviz>=2.40.1-r1 \
        groff>=1.22.3-r2 \
        less>=530-r0 \
        mailcap>=2.1.48-r0 \
        && pip install --upgrade pip \
        && pip install --upgrade awscli=="${AWS_CLI_VERSION}" s3cmd=="${S3_CMD_VERSION}" python-magic==0.4.15 demjson==2.2.4
        
