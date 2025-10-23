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

import ballerina/test;
import ballerina/uuid;

configurable string serviceUrl = "http://localhost:9090";
configurable string adminKey = "test-admin-key";

final Client searchClient = check initClient();

function initClient() returns Client|error {
    return new (serviceUrl, {});
}

@test:Config {
    groups: ["mock_tests"]
}
isolated function testCreateSearchIndex() returns error? {
    string indexName = "test-index-" + uuid:createType1AsString().substring(0, 8);
    
    SearchIndex searchIndex = {
        name: indexName,
        fields: [
            {
                name: "id",
                'type: "Edm.String",
                'key: true,
                searchable: false,
                filterable: false,
                sortable: false
            },
            {
                name: "title",
                'type: "Edm.String",
                searchable: true,
                filterable: true,
                sortable: true
            },
            {
                name: "content",
                'type: "Edm.String",
                searchable: true,
                filterable: false,
                sortable: false
            },
            {
                name: "rating",
                'type: "Edm.Double",
                searchable: false,
                filterable: true,
                sortable: true
            }
        ]
    };
    
    SearchIndex response = check searchClient->indexesCreate(searchIndex, {"api-key": adminKey}, {
        api\-version: "2025-09-01"
    });
    test:assertTrue(response.name == indexName, msg = "Expected index name to match created index");
    test:assertTrue(response.fields.length() == 4, msg = "Expected 4 fields in the index");
}

@test:Config {
    groups: ["mock_tests"]
}
isolated function testListIndexes() returns error? {
    ListIndexesResult response = check searchClient->indexesList({"api-key": adminKey}, {
        api\-version: "2025-09-01"
    });
    test:assertTrue(response.value.length() >= 0, msg = "Expected to retrieve indexes list");
}

@test:Config {
    groups: ["mock_tests"]
}
isolated function testGetServiceStatistics() returns error? {
    ServiceStatistics stats = check searchClient->getServiceStatistics({"api-key": adminKey}, {
        api\-version: "2025-09-01"
    });
    test:assertTrue(stats.counters is record {}, msg = "Expected service statistics to have counters");
}
