## node to build angular project
FROM node:latest as node

WORKDIR /app

COPY ./package.json /app/
## install dependencies
RUN npm install

COPY ./ /app/
## build into ./dist  (ng build --prod to be fixed)
RUN npm run build

FROM nginx:1.13.3-alpine
## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY ./nginx-custom-app.conf /etc/nginx/conf.d/default.conf
COPY --from=node /app/dist/ /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
