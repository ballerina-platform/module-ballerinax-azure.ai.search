// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerinax/azure.ai.search as azureSearch;

configurable string serviceUrl = ?;
configurable string adminKey = ?;
configurable string storageConnectionString = ?;
configurable string storageContainerName = ?;

public function main() returns error? {
    final azureSearch:Client searchClient = check new (serviceUrl);
    
    io:println("=== Azure AI Search Complete Workflow Example ===");
    io:println("This example demonstrates a complete Azure AI Search workflow:");
    io:println("1. Creating a data source");
    io:println("2. Creating a search index");
    io:println("3. Creating an indexer");
    io:println("4. Running the indexer");
    io:println();

    // Step 1: Create a data source
    io:println("Step 1: Creating data source...");
    azureSearch:SearchIndexerDataSource dataSource = {
        name: "documents-datasource",
        'type: "azureblob",
        credentials: {
            connectionString: storageConnectionString
        },
        container: {
            name: storageContainerName,
            query: "/documents/"  // Optional: specify a folder within the container
        },
        description: "Data source for indexing documents from Azure Blob Storage"
    };
    
    azureSearch:SearchIndexerDataSource createdDataSource = check searchClient->dataSourcesCreateOrUpdate("documents-datasource", {"api-key": adminKey, Prefer: "return=representation"}, dataSource, {
        api\-version: "2025-09-01"
    });
    io:println("✓ Data source created: " + createdDataSource.name);
    
    // Note: You can upload files to Azure Blob Storage using the Azure Storage Service connector
    // Repository: https://central.ballerina.io/ballerinax/azure_storage_service/4.3.3
    
    // Step 2: Create a search index
    io:println("Step 2: Creating search index...");
    azureSearch:SearchIndex searchIndex = {
        name: "documents-index-example",
        fields: [
            {
                name: "content",
                'type: "Edm.String",
                searchable: true,
                filterable: false,
                retrievable: true,
                sortable: false,
                facetable: false,
                'key: false
            },
            {
                name: "metadata_storage_path",
                'type: "Edm.String",
                searchable: false,
                filterable: true,
                retrievable: true,
                sortable: true,
                facetable: false,
                'key: true
            },
            {
                name: "metadata_storage_name",
                'type: "Edm.String",
                searchable: true,
                filterable: true,
                retrievable: true,
                sortable: true,
                facetable: true,
                'key: false
            },
            {
                name: "metadata_storage_size",
                'type: "Edm.Int64",
                searchable: false,
                filterable: true,
                retrievable: true,
                sortable: true,
                facetable: true,
                'key: false
            },
            {
                name: "metadata_storage_last_modified",
                'type: "Edm.DateTimeOffset",
                searchable: false,
                filterable: true,
                retrievable: true,
                sortable: true,
                facetable: true,
                'key: false
            },
            {
                name: "metadata_storage_content_type",
                'type: "Edm.String",
                searchable: false,
                filterable: true,
                retrievable: true,
                sortable: false,
                facetable: true,
                'key: false
            },
            {
                name: "language",
                'type: "Edm.String",
                searchable: false,
                filterable: true,
                retrievable: true,
                sortable: false,
                facetable: true,
                'key: false
            },
            {
                name: "sentiment",
                'type: "Edm.String",
                searchable: false,
                filterable: true,
                retrievable: true,
                sortable: false,
                facetable: true,
                'key: false
            }
        ],
        corsOptions: {
            allowedOrigins: ["*"],
            maxAgeInSeconds: 300
        }
    };
    
    azureSearch:SearchIndex createdIndex = check searchClient->indexesCreateOrUpdate("documents-index-example", {"api-key": adminKey, Prefer: "return=representation"}, searchIndex, {
        api\-version: "2025-09-01"
    });
    io:println("✓ Search index created: " + createdIndex.name);
    
    // Step 3: Create an indexer
    io:println("Step 3: Creating indexer...");
    azureSearch:SearchIndexer indexer = {
        name: "documents-index-exampleer",
        dataSourceName: "documents-datasource",
        targetIndexName: "documents-index-example",
        description: "Indexer to automatically process documents from blob storage",
        schedule: {
            interval: "PT2H"  // Run every 2 hours
        },
        parameters: {
            batchSize: 50,
            maxFailedItems: 5,
            maxFailedItemsPerBatch: 5,
            configuration: {
                dataToExtract: "contentAndMetadata",
                parsingMode: "default",
                indexedFileNameExtensions: ".pdf,.docx,.txt,.html,.xml,.json",
                excludedFileNameExtensions: ".png,.jpg,.jpeg,.gif,.bmp"
            }
        },
        fieldMappings: [
            {
                sourceFieldName: "content",
                targetFieldName: "content"
            },
            {
                sourceFieldName: "metadata_storage_path",
                targetFieldName: "metadata_storage_path",
                mappingFunction: {
                    name: "base64Encode"
                }
            },
            {
                sourceFieldName: "metadata_storage_name",
                targetFieldName: "metadata_storage_name"
            },
            {
                sourceFieldName: "metadata_storage_size",
                targetFieldName: "metadata_storage_size"
            },
            {
                sourceFieldName: "metadata_storage_last_modified",
                targetFieldName: "metadata_storage_last_modified"
            },
            {
                sourceFieldName: "metadata_storage_content_type",
                targetFieldName: "metadata_storage_content_type"
            }
        ],
        outputFieldMappings: [
            {
                sourceFieldName: "/document/language",
                targetFieldName: "language"
            },
            {
                sourceFieldName: "/document/sentiment",
                targetFieldName: "sentiment"
            }
        ]
    };
    
    azureSearch:SearchIndexer createdIndexer = check searchClient->indexersCreateOrUpdate("documents-index-exampleer", {"api-key": adminKey, Prefer: "return=representation"}, indexer, {
        api\-version: "2025-09-01"
    });
    io:println("✓ Indexer created: " + createdIndexer.name);
    
    // Step 4: Run the indexer
    io:println("Step 4: Running indexer...");
    error? runResponse = searchClient->indexersRun("documents-index-exampleer", {"api-key": adminKey, "Content-Length": 1000}, {
        api\-version: "2025-09-01"
    });
    if runResponse is () {
        io:println("✓ Indexer started successfully");
    } else {
        io:println("⚠ Indexer run request returned status: ");
    }
    
    // Step 5: Check indexer status
    io:println("Step 5: Checking indexer status...");
    azureSearch:SearchIndexerStatus indexerStatus = check searchClient->indexersGetStatus("documents-index-exampleer", {"api-key": adminKey}, {
        api\-version: "2025-09-01"
    });
    io:println("✓ Indexer status retrieved:");
    io:println("  - Overall status: " + indexerStatus.status.toString());
    io:println("  - Last result status: " + indexerStatus.lastResult?.status.toString());
    
    if indexerStatus.executionHistory.length() > 0 {
        io:println("  - Execution history count: " + indexerStatus.executionHistory.length().toString());
        azureSearch:IndexerExecutionResult latestExecution = indexerStatus.executionHistory[0];
        io:println("  - Latest execution start time: " + (latestExecution.startTime.toString()));
        io:println("  - Items processed: " + latestExecution.itemsProcessed.toString());
        io:println("  - Items failed: " + latestExecution.itemsFailed.toString());
    }
    
    io:println();
    io:println("=== Workflow Complete ===");
    io:println("Your Azure AI Search service is now configured with:");
    io:println("• Data source: documents-datasource (connected to Azure Blob Storage)");
    io:println("• Search index: documents-index-example (with document metadata and content fields)");
    io:println("• Indexer: documents-index-exampleer (scheduled to run every 2 hours)");
    io:println();
    io:println("Next steps:");
    io:println("1. Upload documents to your Azure Blob Storage container");
    io:println("2. The indexer will automatically process and index new documents");
    io:println("3. Use the search endpoints to query your indexed documents");
    io:println("4. Monitor indexer execution through the Azure portal or API");
}
