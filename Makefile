.PHONY: clean build migrate start-api deploy help
.DEFAULT_GOAL := help

PROJECT_NAME := sam-cli-test
BUILD_DIR := ./build
TEMPLATE_FILE := template.yaml
PACKAGE_FILE := $(BUILD_DIR)/package.yaml
ENDPOINT := http://192.168.99.100:8000

clean: ## Clean build directory
	rm -rf $(BUILD_DIR)/*

build: ## Build Lambda functions
	mkdir -p build
	GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/user ./user

migrate: ## Create table and put data to DynamoDB Local
	aws dynamodb create-table --cli-input-json file://test/user_table.json --endpoint-url $(ENDPOINT)
	aws dynamodb batch-write-item --request-items file://test/user_table_data.json --endpoint-url $(ENDPOINT)

start-api: ## Run local Api Gateway and Lambda funcitons
	sam local start-api --env-vars test/env.json

deploy: ## Upload and deploy Lambda functions
	sam validate
	sam package --template-file $(TEMPLATE_FILE) --s3-bucket $(BUCKET_NAME) --output-template-file $(PACKAGE_FILE)
	aws cloudformation deploy --template-file $(PACKAGE_FILE) --stack-name $(PROJECT_NAME) --capabilities CAPABILITY_IAM

help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n\033[0;39m", $$1, $$2}'

