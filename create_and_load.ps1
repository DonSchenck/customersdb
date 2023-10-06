
echo 'CREATE AND POPULATE DATABASE TABLE(S)'
echo '-------------------------------------'

echo 'Waiting for pod to be available...'
Sleep(15)

echo 'Getting pod name...'
(kubectl get pods | select-string '^customersdb([^\s]+)-(?!deploy)') -match 'customersdb([^\s]+)'; $podname = $matches[0]
Write-Host $podname

echo 'Copying table-creation script to pod...'
oc cp .\create_table_customers.sql ${podname}:/tmp/create_table_customers.sql

echo 'Copying data to pod...'
oc cp .\customers.csv ${podname}:/tmp/customers.csv

echo 'Creating table(s)...'
oc exec ${podname} -- psql -d customersdb -U customersdb --no-password -f "/tmp/create_table_customers.sql"

echo 'Importing data...'
oc exec ${podname} -- psql -d customersdb -U customersdb -c "\copy customers FROM '/tmp/customers.csv' delimiter ',' csv"

echo 'FINISHED'