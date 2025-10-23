# RAG ingestion AI Search Workflow

This example demonstrates a RAG Azure AI Search workflow including:

1. **Data Source Creation** - Setting up Azure Blob Storage as a data source
2. **Index Creation** - Creating a comprehensive search index with multiple field types
3. **Indexer Creation** - Setting up an automated indexer with scheduling and field mappings
4. **Indexer Execution** - Running the indexer and monitoring its status

## Prerequisites

Before running this example, you need:

1. **Azure AI Search Service** - A provisioned Azure AI Search service
2. **Azure Storage Account** - A storage account with a blob container
3. **Documents** - Sample documents uploaded to your blob container

## Configuration

Create a `Config.toml` file with your Azure services configuration:

```toml
serviceUrl = "https://your-search-service.search.windows.net"
adminKey = "your-admin-key"
storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=yourstorageaccount;AccountKey=yourkey;EndpointSuffix=core.windows.net"
storageContainerName = "documents"
```

## Document Upload

To upload documents to Azure Blob Storage, you can use the Azure Storage Service connector:
**Repository**: https://central.ballerina.io/ballerinax/azure_storage_service/4.3.3

## Features Demonstrated

### Advanced Index Configuration
- Multiple field types (String, Int64, DateTimeOffset)
- Field attributes (searchable, filterable, sortable, facetable)
- CORS configuration for web applications

### Intelligent Indexing
- Automatic content extraction from various document formats
- Metadata preservation (file name, size, modification date, content type)
- Custom field mappings and transformations
- Built-in cognitive skills for language detection and sentiment analysis

## Running the Example

```bash
bal run
```
