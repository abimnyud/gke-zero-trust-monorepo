FROM node:hydrogen-slim AS base

WORKDIR /src
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --omit=dev

FROM node:hydrogen-slim

WORKDIR /src
COPY --from=base /src/dist /src/dist
COPY --from=base /src/node_modules /src/node_modules
EXPOSE 3001

CMD ["node", "dist/main.js"]
