FROM node:14.15 AS development

#  Navigate to the container working directory
WORKDIR /app
#  Copy package.json
COPY package*.json ./

RUN npm install glob rimraf
RUN npm i -g @nestjs/cli
RUN npm install

COPY . .

RUN npm run build

FROM node:14.15 AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production

COPY . .

COPY --from=development /app/dist ./dist

CMD ["node", "dist/main"]
