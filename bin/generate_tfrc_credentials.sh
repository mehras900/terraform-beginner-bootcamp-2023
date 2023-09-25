#!/usr/bin/env bash

# Define the target directory and file
TARGET_DIR="/home/gitpod/.terraform.d/"
TARGET_FILE="credentials.tfrc.json"

# Create the directory if it doesn't exist
mkdir -p $TARGET_DIR

# Use the environment variable TERRAFORM_CLOUD_TOKEN for the token value
TOKEN_VALUE=${TERRAFORM_CLOUD_TOKEN}

# Generate the JSON content with the token
JSON_CONTENT=$(cat <<- EOF
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TOKEN_VALUE"
    }
  }
}
EOF
)

# Write the JSON content to the target file
echo "$JSON_CONTENT" > "${TARGET_DIR}${TARGET_FILE}"

echo "File ${TARGET_DIR}${TARGET_FILE} has been created/updated."