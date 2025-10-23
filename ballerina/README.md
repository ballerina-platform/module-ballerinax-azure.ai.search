# Ballerina Azure AI Search connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-azure.ai.search/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-azure.ai.search/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-azure.ai.search.svg)](https://github.com/ballerina-platform/module-ballerinax-azure.ai.search/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/azure.ai.search.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%azure.ai.search)

## Overview

[Azure AI Search](https://azure.microsoft.com/products/ai-services/ai-search/) is a cloud search service that gives developers infrastructure, APIs, and tools for building a rich search experience over private, heterogeneous content in web, mobile, and enterprise applications.

The `ballarinax/azure.ai.search` package offers functionality to connect and interact with [Azure AI Search REST API](https://docs.microsoft.com/en-us/rest/api/searchservice/) enabling seamless integration with Azure's powerful search and indexing capabilities for building comprehensive search solutions.

## Setup guide

To use the Azure AI Search Connector, you must have an Azure subscription and an Azure AI Search service. If you do not have an Azure account, you can sign up for one [here](https://azure.microsoft.com/free/).

#### Create an Azure AI Search service

1. Sign in to the [Azure portal](https://portal.azure.com).

2. Click on "Create a resource" and search for "AI Search".

3. Select "AI Search" and click "Create".

4. Fill in the required details:
   - Resource group: Select or create a new resource group
   - Service name: Choose a unique name for your search service
   - Location: Select a region close to your application
   - Pricing tier: Choose the appropriate tier based on your needs

5. Click "Review + create" and then "Create" to provision the service.

#### Get the service URL and admin key

1. Once the service is created, navigate to your Azure AI Search service in the Azure portal.

2. In the "Overview" section, note the URL (e.g., `https://your-service.search.windows.net`).

3. Navigate to "Keys" in the left menu to find your admin keys.

4. Copy either the primary or secondary admin key to use in your application.

## Quickstart

To use the `Azure AI Search` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `ballerinax/azure.ai.search` module.

```ballerina
import ballerinax/azure.ai.search as azureSearch;
```

### Step 2: Create a new connector instance

Create an `azureSearch:Client` with your Azure AI Search service URL and admin key.

```ballerina
configurable string serviceUrl = ?;
configurable string adminKey = ?;

final azureSearch:Client searchClient = check new (serviceUrl, {});
```

### Step 3: Invoke the connector operation

Now, you can utilize available connector operations.

#### Create a search index

```ballerina

public function main() returns error? {

    // Define a simple search index
    azureSearch:SearchIndex searchIndex = {
        name: "hotels",
        fields: [
            {
                name: "id",
                'type: "Edm.String",
                'key: true,
                searchable: false
            },
            {
                name: "name",
                'type: "Edm.String",
                searchable: true,
                filterable: true
            }
        ]
    };

    SearchIndex response = check searchClient->indexesCreate(searchIndex, {"api-key": adminKey}, {
        api\-version: "2025-09-01"
    });
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Azure AI Search` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-azure.ai.search/tree/main/examples/), covering the following use cases:

1. [RAG ingestion](https://github.com/ballerina-platform/module-ballerinax-azure.ai.search/tree/main/examples/rag-ingestion) - A comprehensive example demonstrating the complete Azure AI Search workflow including data source creation, index creation, indexer setup, and execution.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`azure.ai.search` package](https://central.ballerina.io/ballerinax/azure.ai.search/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
