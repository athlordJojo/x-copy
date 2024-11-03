#!/usr/bin/env bash

dirname="downloaded_files"

delete_download_dir() {
    echo "Deleting $dirname"
    rm -rf $dirname
    echo "Deleted directory $dirname"
}

download_file() {
    local url=$1
    url=$(echo "$url" | xargs)
    echo "Downloading from URL: $url"
    # Extract the filename without query parameters
    filename=$(basename "${url%%\?*}")  # Remove query params

    curl -L -o "$dirname/$filename" "$url" # download file from url into specific directory.
}

download_files() {
  yq -r '.files[]' files.yaml | while read -r url; do
    download_file "$url"
  done
}

prepare_download_dir() {
  if [ -d "$dirname" ]; then
    echo "Directory $dirname exists, deleting it now"
    delete_download_dir
  else
    echo "Directory does not exist. Will be created now"
  fi

  mkdir "$dirname"
}

upload_files_to_s3() {
  # creating a 'dirname' for the bucket in s3
  formatted_date=$(date +"%Y-%m-%d_%H-%M-%S")
  backup_name=backup_$formatted_date
  echo "Will save this backup to dirname in s3: $backup_name"

  aws s3 sync $dirname s3://xcopy-target/"$backup_name"
}

prepare_download_dir
download_files
upload_files_to_s3
delete_download_dir