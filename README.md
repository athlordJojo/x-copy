# X-copy
This small programm purpose is, to download files and store them in a s3-bucket.
I use it make sure that I have a daily backup of my keepass file also stored in a s3-bucket in addition to dropbox.
You can use the script directly or you use a provided docker-image together with the provided docker-compose-file.

# Login into aws via cli
If you run this programm directly or via docker, you need to login into aws.
Therefore you need the awscli installed.
Depending on your OS, use one of the following commands:
## Install awscli on macos
```
brew install awscli
```

## Install awscli on debian-linux
```
sudo apt install awscli
```
## Configure aws
After installing awscli you need to login to awscli.
```
aws configure
```

Here provide the accesskey and secret. 

[source](https://medium.com/@prateek.malhotra004/mastering-aws-cli-a-comprehensive-guide-to-command-line-power-ca2260167839)

## Troubleshooting

### An error occurred (InvalidToken) when calling the ListBuckets operation: The provided token is malformed or otherwise invalid.

The cause may be a previous logged in session. Delete the previous one:

```
rm -rf .aws
```

# Raspberry Pi
If you want to run this programm on your raspberry pi follow these steps:

## 1. Checkout this repository on your pi

```
git clone https://github.com/athlordJojo/x-copy.git
```

## Install and configure AwsCli

```
sudo apt install awscli
```

Now you need to authenticate with your aws-iam accesskey and secret. 
See: "Login into aws via cli"

## Run as cron-job
In order to create a backup regularly e.g. every day at three o'clock, you can use cron.

```
0 3 * * * cd /home/pi/x-copy && docker compose up >> /tmp/x-copy.log 2>&1
```

# Building docker image for multiple platforms

## Create and use custom docker builder for muli platform support
In order to build a docker image for multiple platforms use this command:
First we need to create a docker-builder which supports mulipbuilds:

```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t athlord/x-copy:1.0.0 --push .
```
Now we need to use this builder:
```
docker buildx use mybuilder
```

Next we can build the image using this builder:
```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t athlord/x-copy:1.1.0 --push .
```
[source](https://www.docker.com/blog/multi-arch-images/)