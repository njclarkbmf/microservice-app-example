FROM golang:1.9-alpine
RUN apk add --update bash curl
EXPOSE 8081
RUN mkdir /root/che && chgrp -R 0 /root && \
           chmod -R g+rwX /root
WORKDIR /go/src/app
RUN apk --no-cache add curl git && \
    curl https://glide.sh/get | sh

COPY glide.* ./
RUN glide install

COPY . .
RUN go build -o auth-api
WORKDIR /projects
ENV HOME /root
RUN echo "/go/src/app/auth-api exec "\$@"" > entrypoint.sh && \
    chmod +x entrypoint.sh
RUN chgrp -R 0 /go && \
               chmod -R g+rwX /go
CMD tail -f /dev/null
