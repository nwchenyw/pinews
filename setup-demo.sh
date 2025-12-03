#!/bin/bash
# Setup script for PiNews Demo Mode
# This script copies static files to wwwroot directory

echo "Setting up PiNews static files..."

# Create wwwroot if it doesn't exist
mkdir -p wwwroot

# Copy static files
echo "Copying CSS files..."
cp -r css wwwroot/

echo "Copying images..."
cp -r img wwwroot/

echo "Copying Semantic UI..."
cp -r semantic wwwroot/

echo "✓ Static files copied successfully!"
echo ""
echo "You can now run the application with:"
echo "  dotnet run"
echo ""
echo "Then open http://localhost:5000 in your browser"
