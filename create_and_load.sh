export PODNAME=$(oc get pods -o custom-columns=POD:.metadata.name --no-headers | grep -v 'deploy$' | grep quote)
echo $PODNAME

oc cp .\create_table_customers.sql $PODNAME:/tmp/create_table_customers.sql

oc cp .\customers.csv $PODNAME:/tmp/customers.csv

oc exec $PODNAME -- psql -d customersdb -U customersdb --no-password -f "/tmp/create_table_customers.sql"

oc exec $PODNAME -- psql -d customersdb -U customersdb -c "\copy customers FROM '/tmp/customers.csv' delimiter ',' csv"
