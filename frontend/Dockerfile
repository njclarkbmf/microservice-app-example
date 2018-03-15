FROM node:8-alpine
RUN apk add --update bash curl
RUN chgrp -R 0 /root && \
               chmod -R g+rwX /root && \
               mkdir /projects && \
               chgrp -R 0 /projects && \
               chmod -R g+rwX /projects
EXPOSE 8080
COPY . /projects1
RUN cd /projects1/ && npm install
ENV HOME /root

CMD cd /projects1 && \
    npm start & tail -f /dev/null
