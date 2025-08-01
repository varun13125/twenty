#!/bin/bash
# Vercel Build Script for Twenty CRM

echo "🚀 Starting Twenty CRM build for Vercel..."

# Install dependencies without immutable installs
echo "📦 Installing dependencies..."
yarn install --no-immutable

# Build the frontend
echo "🔨 Building Twenty frontend..."
cd packages/twenty-front
yarn build

echo "✅ Build completed successfully!"