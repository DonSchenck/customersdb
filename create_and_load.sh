echo 'CREATE AND POPULATE DATABASE TABLE(S)'
echo '-------------------------------------'

echo 'Waiting for pod to be available...'
Sleep 15

echo 'Getting pod name...'
export PODNAME=$(oc get pods -o custom-columns=POD:.metadata.name --no-headers | grep -v 'deploy$' | grep customersdb)
echo $PODNAME

echo 'Copying table-creation script to pod...'
oc cp create_table_customers.sql $PODNAME:/tmp/create_table_customers.sql

echo 'Copying data to pod...'
oc cp customers.csv $PODNAME:/tmp/customers.csv

echo 'Creating table(s)...'
oc exec $PODNAME -- psql -d customersdb -U customersdb --no-password -f "/tmp/create_table_customers.sql"

echo 'Importing data...'
oc exec $PODNAME -- psql -d customersdb -U customersdb -c "\copy customers FROM '/tmp/customers.csv' delimiter ',' csv"

echo 'FINISHED'