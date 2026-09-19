ARG NODE_VERSION=24

FROM --platform=$BUILDPLATFORM node:${NODE_VERSION}-alpine AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
RUN npm run build:production

FROM nginx:alpine
RUN apk add --no-cache jq
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/dist /usr/share/nginx/html
COPY --chmod=755 docker/40-server-url.sh /docker-entrypoint.d/
EXPOSE 80
