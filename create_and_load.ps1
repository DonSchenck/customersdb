(kubectl get pods | select-string '^customersdb([^\s]+)-(?!deploy)') -match 'customersdb([^\s]+)'; $podname = $matches[0]

Write-Host $podname

oc cp .\create_table_customers.sql ${podname}:/tmp/create_table_customers.sql

oc cp .\customers.csv ${podname}:/tmp/customers.csv

oc exec ${podname} -- psql -d customersdb -U customersdb --no-password -f "/tmp/create_table_customers.sql"

oc exec ${podname} -- psql -d customersdb -U customersdb -c "\copy customers FROM '/tmp/customers.csv' delimiter ',' csv"
