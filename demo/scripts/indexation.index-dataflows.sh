#!/bin/sh 

#Indexes dataflows of catagory schemes defined in datasources.json at 'queries' section
curl -X POST http://localhost:3004/admin/dataflows?api-key=secret
#Prints report of last indexation:
echo Results:
curl -X GET http://localhost:3004/admin/report?api-key=secret
