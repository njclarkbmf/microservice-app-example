FROM node:8-alpine
RUN apk add --update bash curl
EXPOSE 8082
RUN mkdir /root/che && chgrp -R 0 /root && \
           chmod -R g+rwX /root
WORKDIR /usr/src/app

COPY package.json ./
RUN npm install
RUN chgrp -R 0 /root && \
               chmod -R g+rwX /root
COPY . .
ENV HOME /root
CMD cd /usr/src/app && sleep 60 && npm start && tail -f /dev/null
