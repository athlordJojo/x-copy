#!/usr/bin/env sh

delete_download_dir() {
    echo "Deleting $download_dir"
    rm -rf $download_dir
    echo "Deleted directory $download_dir"
}

download_file() {
    local url=$1
    url=$(echo "$url" | xargs)
    echo "Downloading from URL: $url"
    # Extract the filename without query parameters
    filename=$(basename "${url%%\?*}")  # Remove query params

    curl -L -o "$download_dir/$filename" "$url" # download file from url into specific directory.
}

download_files() {
  yq eval '.files[]' files.yaml | while read -r url; do
    download_file "$url"
  done
}

prepare_download_dir() {
  if [ -d "$download_dir" ]; then
    echo "Download directory $download_dir exists, deleting it now"
    delete_download_dir
  else
    echo "Download directory does not exist. Will be created now"
  fi

  mkdir "$download_dir"
}

upload_files_to_s3() {
  # create a directory name where this backup will be stored in s3
  formatted_date=$(date +"%Y-%m-%d_%H-%M-%S")
  backup_name=backup_$formatted_date

  echo "Will save this backup in s3-bucket $bucket into directory: $backup_name"

  aws s3 sync $download_dir s3://"$bucket"/"$backup_name"
}

download_dir="download_directory"
bucket=$(yq eval ".aws.bucket" files.yaml)
echo "Will write into aws bucket: $bucket"

prepare_download_dir
download_files
upload_files_to_s3
delete_download_dir