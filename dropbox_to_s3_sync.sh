#dirname="downloaded_files"
#mkdir "$dirname"

yq -r '.files[]' files.yaml | while read -r url; do
  url=$(echo "$url" | xargs)
  echo "Downloading from URL: $url"
  curl -L -O "$url"  # Verbose output shows full request details
done

#aws s3 sync . s3://xcopy-target