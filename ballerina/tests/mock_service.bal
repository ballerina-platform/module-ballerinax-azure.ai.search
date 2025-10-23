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

import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {
    
    // Mock endpoint for creating search indexes
    resource function post indexes(@http:Payload SearchIndex payload) returns SearchIndex|http:BadRequest {
        // Validate the request payload
        if payload.name.toString() is "" || payload.fields.length() == 0 {
            return http:BAD_REQUEST;
        }

        // Return the same index with mock metadata
        SearchIndex response = {
            name: payload.name,
            fields: payload.fields,
            "etag": "\"0x8D123456789ABCD\"",
            "similarityAlgorithm": {
                "@odata.type": "#Microsoft.Azure.Search.BM25Similarity"
            }
        };
        return response;
    }

    // Mock endpoint for listing indexes
    resource function get indexes() returns ListIndexesResult {
        SearchIndex mockIndex = {
            name: "mock-index",
            fields: [
                {
                    name: "id",
                    'type: "Edm.String",
                    'key: true,
                    searchable: false
                }
            ]
        };
        
        ListIndexesResult response = {
            value: [mockIndex]
        };
        return response;
    }

    // Mock endpoint for getting service statistics
    resource function get servicestats() returns ServiceStatistics {
        ServiceStatistics stats = {
            counters: {
                documentCount: {
                    usage: 0,
                    quota: 1000000
                },
                indexesCount: {
                    usage: 1,
                    quota: 3
                },
                storageSize: {
                    usage: 0,
                    quota: 52428800
                }, 
                indexersCount: {
                    usage: 0,
                    quota: 10
                },
                dataSourcesCount: {
                    usage: 0,
                    quota: 100
                },
                synonymMaps: {
                    usage: 0,
                    quota: 100
                },
                skillsetCount: {
                    usage: 0,
                    quota: 100
                },
                vectorIndexSize: {
                    usage: 0,
                    quota: 100000
                }
            },
            limits: {
                maxFieldsPerIndex: 1000,
                maxFieldNestingDepthPerIndex: 10,
                maxComplexCollectionFieldsPerIndex: 40,
                maxComplexObjectsInCollectionsPerDocument: 3000
            }
        };
        return stats;
    }
};

function init() returns error? {
    log:printInfo("Initiating mock server...");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
