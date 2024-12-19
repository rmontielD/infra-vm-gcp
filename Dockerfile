FROM hashicorp/terraform:latest

WORKDIR /app

RUN mkdir -p /app/state

ENTRYPOINT ["terraform"]