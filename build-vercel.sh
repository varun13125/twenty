#!/bin/bash

# Build script for Vercel deployment
set -e

echo "Starting Vercel build process..."

# Set environment variables
export NODE_ENV=production
export VITE_DISABLE_TYPESCRIPT_CHECKER=true
export VITE_DISABLE_ESLINT_CHECKER=true
export NODE_OPTIONS="--max-old-space-size=8192"

# Install dependencies with yarn
echo "Installing dependencies..."
yarn install

# Build the frontend package
echo "Building twenty-front package..."
cd packages/twenty-front
yarn build

echo "Build completed successfully!" 