#!/usr/bin/env bash
set -e

echo "Creating Android platform files..."
flutter create --platforms=android .

echo "Getting packages..."
flutter pub get

echo "Running analyzer..."
flutter analyze

echo "Clean project setup complete."
