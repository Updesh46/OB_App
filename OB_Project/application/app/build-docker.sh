#!/bin/bash

# Docker Build Script for OB App

set -e

IMAGE_NAME="obapp"
TAG="latest"
FULL_IMAGE="${IMAGE_NAME}:${TAG}"

echo "🐳 Building multi-stage Docker image for OB App..."
echo "📦 Image: ${FULL_IMAGE}"

# Build the image
docker build -t "${FULL_IMAGE}" .

echo "✅ Build completed successfully!"
echo ""
echo "🚀 To run the container:"
echo "   docker run -d -p 8080:8080 --name obapp ${FULL_IMAGE}"
echo ""
echo "🌐 Access the application at: http://localhost:8080"
echo ""
echo "📊 To check container status:"
echo "   docker ps | grep obapp"
echo ""
echo "📝 To view logs:"
echo "   docker logs -f obapp"