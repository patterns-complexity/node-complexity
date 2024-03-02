## Set the base image to node:20.11.1 (LTS)
FROM node:20.11.1 as base

ARG UID
ARG GID

# Change UID and GID for user node
RUN usermod -u ${UID} node && groupmod -g ${GID} node

## Create app directory
RUN mkdir -p /app

## Set the working directory
WORKDIR /app

## Copy ./src to /app
COPY ./src/ /app

FROM base as dev

## Expose port 3000
EXPOSE 3000

## Copy dev entrypoint.sh to /app
COPY ./entrypoint.dev.sh /app/entrypoint.sh

## Set the environment to development
ENV NODE_ENV=development

## Make the entrypoint.sh file executable
RUN chmod +x /app/entrypoint.sh 

## Change the owner of the /app directory to the user
RUN chown -R ${UID}:${GID} /app

## Change the user
USER ${UID}:${GID}

## Install necessary packages
RUN yarn global add nodemon

## Example of handling simple frontend and backend directories
## modify and append to the above instruction if needed
# && \
#   cd ./frontend && yarn install && \
#   cd ../backend && yarn install

## Run the entrypoint.sh file
ENTRYPOINT ["/app/entrypoint.sh"]

FROM base as prod

## Expose port 3001
EXPOSE 3001

## Copy entrypoint.prod.sh to /app
COPY ./entrypoint.prod.sh /app/entrypoint.sh

## Set the environment to production
ENV NODE_ENV=production

## Make the entrypoint.sh file executable
RUN chmod +x /app/entrypoint.sh

## Change the owner of the /app directory to the user
RUN chown -R ${UID}:${GID} /app

## Change the user
USER ${UID}:${GID}

RUN rm -rf /app/backend/node_modules && \
  rm -rf /app/frontend/node_modules

## Install necessary packages
RUN yarn global add pm2

## Example of handling simple frontend and backend directories
## modify and append to the above instruction if needed
# && \
#   cd ./frontend && yarn install && \
#   yarn next:build && \
#   cd ../backend && yarn install

# Run the entrypoint.sh file
ENTRYPOINT ["/app/entrypoint.sh"]
