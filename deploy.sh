#!/bin/bash

deploy_react="true"

if [ "$deploy_react" = "true" ]; then
  echo "Deploying the react app."
  frontend_directory="moneyapp/packages/full-frontend"
  frontend_cdk_directory="FrontEndCDK"
  site_contents="site-contents"

  echo "Starting deploy script..."

  echo "cd to $frontend_directory package"

  cd ..

  # Check if the directory exists
  if [ ! -d "$frontend_directory" ]; then
    echo "Error: Directory $frontend_directory not found."
    exit 1
  fi

  # Change to the target directory
  cd "$frontend_directory" || exit 1

  full_frontebd_dir_path="$PWD"

  # Check if npm is installed
  if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install npm and try again."
    exit 1
  fi
  
  export NODE_OPTIONS=--openssl-legacy-provider

  # Build the FrontEnd package
  echo "Build the $frontend_directory package"

  npm run build

  # cd to the CDK package
  echo "cd to the CDK package"
  cd ..
  cd ..
  cd ..
  cd "$frontend_cdk_directory" || exit 1
  full_frontend_cdk_dir_path="$PWD"


  # Build the CDK package
  echo "Build the CDK package"

  npm run build

  echo "setup $site_contents directory"

  rm -rf $site_contents

  mkdir $site_contents

  echo "copy assets to 'site_contents' directory"

  sudo cp -r "$full_frontebd_dir_path/build/" "$full_frontend_cdk_dir_path/$site_contents"

  # Check if cdk is installed
  if ! command -v cdk &> /dev/null; then
    echo "Error: cdk is not installed. Please install cdk and try again."
    exit 1
  fi

  # cdk synth
  echo "synth the CDK package"
  cdk synth

  # cdk deploy
  echo "deploy the CDK package"
  cdk deploy --require-approval never
else
  echo "Deploying the flutter app."
  frontend_directory="moneyapp_flutter"
  frontend_cdk_directory="FrontEndCDK"
  site_contents="site-contents"

  echo "Starting deploy script..."

  echo "cd to $frontend_directory package"

  cd ..

  # Check if the directory exists
  if [ ! -d "$frontend_directory" ]; then
    echo "Error: Directory $frontend_directory not found."
    exit 1
  fi

  # Change to the target directory
  cd "$frontend_directory" || exit 1

  full_frontebd_dir_path="$PWD"

  # Check if flutter is installed
  if ! command -v flutter &> /dev/null; then
    echo "Error: flutter is not installed. Please install flutter and try again."
    exit 1
  fi

  # Build the FrontEnd package
  echo "Build the $frontend_directory package"

  flutter build web --no-tree-shake-icons

  # cd to the CDK package
  echo "cd to the CDK package"

  cd ..
  cd "$frontend_cdk_directory" || exit 1
  full_frontend_cdk_dir_path="$PWD"


  # Build the CDK package
  echo "Build the CDK package"

  # Check if npm is installed
  if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install npm and try again."
    exit 1
  fi

  npm run build

  echo "setup $site_contents directory"

  rm -rf $site_contents

  mkdir $site_contents

  echo "copy assets to 'site_contents' directory"

  sudo cp -r "$full_frontebd_dir_path/build/web/" "$full_frontend_cdk_dir_path/$site_contents"

  # Check if cdk is installed
  if ! command -v cdk &> /dev/null; then
    echo "Error: cdk is not installed. Please install cdk and try again."
    exit 1
  fi

  # cdk synth
  echo "synth the CDK package"
  cdk synth

  # cdk deploy
  echo "deploy the CDK package"
  cdk deploy --require-approval never
fi