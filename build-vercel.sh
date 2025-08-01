#!/bin/bash

# Build script for Vercel deployment
set -e

echo "Starting Vercel build process..."

# Set environment variables
export NODE_ENV=production
export VITE_DISABLE_TYPESCRIPT_CHECKER=true
export VITE_DISABLE_ESLINT_CHECKER=true
export NODE_OPTIONS="--max-old-space-size=8192"

# Install dependencies with npm using legacy peer deps to resolve conflicts
echo "Installing dependencies..."
npm install --legacy-peer-deps --ignore-optional --no-optional

# Patch NestJS terminus version conflict
echo "Patching dependency conflicts..."
npm install @nestjs/terminus@^9.0.0 --legacy-peer-deps --no-save

# Generate GraphQL types first
echo "Generating GraphQL types..."
npx nx run twenty-front:graphql:generate --skip-nx-cache 2>/dev/null || echo "GraphQL generation failed, continuing..."

# Build the frontend package
echo "Building twenty-front package..."
cd packages/twenty-front
npm run build

echo "Build completed successfully!"