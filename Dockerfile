
# Stage 1 - Building image
FROM node:10 as node

WORKDIR /usr/app/fiora

COPY build ./build
COPY client ./client
COPY config ./config
COPY public ./public
COPY server ./server
COPY static ./static
COPY types ./types
COPY utils ./utils
COPY .babelrc package.json tsconfig.json yarn.lock ./

RUN yarn install

RUN yarn build && yarn run move-dist

#CMD export NODE_ENV=production && yarn start


# Stage 2 - Running image
#FROM bitnami/nginx:1.14.2
#
#COPY --from=node /usr/app/fiora /var/www/my-app
#COPY ./nginx.conf /opt/bitnami/nginx/conf/nginx.conf
#


FROM nginx:latest

COPY ssldocker/default.conf /etc/nginx/conf.d/
COPY ssldocker/nginx.crt /etc/ssl/
COPY ssldocker/nginx.key /etc/ssl/
COPY --from=node /usr/app/fiora /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
