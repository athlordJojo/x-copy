FROM alpine:3.14
RUN apk add yq
RUN apk add aws-cli
RUN apk add curl

WORKDIR /x-copy
COPY files_to_s3_sync.sh files_to_s3_sync.sh
RUN chmod +x files_to_s3_sync.sh
CMD ["./files_to_s3_sync.sh"]