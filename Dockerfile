FROM node:lts-alpine

# pass N8N_VERSION Argument while building or use default
ARG N8N_VERSION=1.71.3

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata

# Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages it needs to build it correctly
RUN apk --update add --virtual build-dependencies python3 build-base && \
	npm_config_user=root npm install --location=global n8n@${N8N_VERSION} && \
	apk del build-dependencies

# Specifying work directory
WORKDIR /data

# Expose container port
EXPOSE 8080

# Copy start script to container
COPY ./start.sh /

# Make the script executable
RUN chmod +x /start.sh

# Define execution entrypoint
CMD ["/start.sh"]
