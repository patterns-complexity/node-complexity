# Set the base image to node:20.11.1 (LTS)
FROM node:20.11.1 as base

# Create app directory
RUN mkdir -p /app

# Set the working directory
WORKDIR /app

# Copy ./src to /app
COPY ./src/ /app

# Expose port 3000
EXPOSE 3000

FROM base as dev

# Copy dev entrypoint.sh to /app
COPY ./entrypoint.dev.sh /app/entrypoint.sh

# Set the entrypoint.sh file to be executable
RUN chmod +x /app/entrypoint.sh

# Set the environment to development
ENV NODE_ENV=development

# Install necessary packages
RUN yarn add -g nodemon pm2 @nestjs/cli
RUN yarn add @nestjs/platform-fastify fastify

# Run the entrypoint.sh file
ENTRYPOINT ["/app/entrypoint.sh"]

FROM base as prod

# Copy entrypoint.prod.sh to /app
COPY ./entrypoint.prod.sh /app/entrypoint.sh

# Set the entrypoint.sh file to be executable
RUN chmod +x /app/entrypoint.sh

# Set the environment to production
ENV NODE_ENV=production

# Install necessary packages
# ---

# Run the entrypoint.sh file
ENTRYPOINT ["/app/entrypoint.sh"]

