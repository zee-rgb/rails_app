#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting test suite...${NC}"
echo "===================="

# Function to run a command and check its exit status
run_command() {
    echo -e "\n${YELLOW}Running: $1${NC}"
    eval $1
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Command failed: $1${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Success${NC}"
}

# Test Python service
echo -e "\n${YELLOW}Testing Python AI Service${NC}"
echo "------------------------"
run_command "cd python_ai && python -m pytest test_main.py -v"

# Test Rails application
echo -e "\n${YELLOW}Testing Rails Application${NC}"
echo "------------------------"
run_command "cd rails_app && bundle exec rspec"

# Run integration tests if services are running
if [ "$1" == "--integration" ]; then
    echo -e "\n${YELLOW}Running Integration Tests${NC}"
    echo "------------------------"
    run_command "ruby test_integration.rb"
else
    echo -e "\n${YELLOW}Skipping integration tests. To include them, run with --integration${NC}"
    echo "Make sure both the Rails and Python services are running first."
    echo "You can start them with: docker-compose up --build"
fi

echo -e "\n${GREEN}All tests completed successfully!${NC}"
