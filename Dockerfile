FROM node:18-bookworm
ENV NPM_CONFIG_LOGLEVEL info

# Defaults to production, docker-compose overrides this to development on build and run.
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

# RUN apk add --no-cache build-base git libasound2-dev
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential git libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies first, as they change less often than code.
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install && npm cache clean --force

COPY ["index.js", "./"]

# Execute NodeJS (not NPM script) to handle SIGTERM and SIGINT signals.
ENTRYPOINT ["node", "index.js"]
CMD [ "--help" ]
