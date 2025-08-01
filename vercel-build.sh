#!/bin/bash
# Vercel Build Script for Twenty CRM

set -e

echo "🚀 Starting Twenty CRM build for Vercel..."

# Install dependencies without immutable installs and skip optional dependencies
echo "📦 Installing dependencies..."
yarn install --no-immutable --ignore-optional

# Build dependencies in correct order
echo "🔨 Building twenty-ui..."
npx nx build twenty-ui

echo "🔨 Building twenty-shared..."
npx nx build twenty-shared

echo "🔨 Building twenty-front..."
npx nx build twenty-front

echo "✅ Build completed successfully!"