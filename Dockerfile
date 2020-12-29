FROM node:14.9.0-alpine3.12 AS install
WORKDIR /app
COPY ./package.json ./package-lock.json ./
RUN npm ci

FROM install AS build
COPY . ./
RUN npm run build

FROM build AS test
RUN npm test

FROM scratch AS coverage
COPY --from=test /app/coverage/. /

FROM node:14.9.0-alpine3.12 as package
WORKDIR /app
COPY --from=build /app/dist/* ./
CMD ["node", "app.js"]
