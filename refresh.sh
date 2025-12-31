#!/bin/bash

# Define colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${CYAN}--- Starting Flutter Maintenance ---${NC}"

if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml not found. Please run this script in the root of your Flutter project.${NC}"
    exit 1
fi

echo -e "${YELLOW}1. Running: flutter clean...${NC}"
flutter clean
if [ $? -ne 0 ]; then
    echo -e "${RED}Flutter clean failed. Stopping script.${NC}"
    exit 1
fi

echo -e "${YELLOW}2. Running: flutter pub get...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}--- Done! Project is ready. ---${NC}"
else
    echo -e "${RED}--- 'flutter pub get' failed. Check logs above. ---${NC}"
    exit 1
fi