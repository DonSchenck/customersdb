`oc new-app --template=postgresql-ephemeral --param NAMESPACE=openshift --param DATABASE_SERVICE_NAME=customersdb --param POSTGRESQL_USER=customersdb --param POSTGRESQL_PASSWORD=customersdb --param POSTGRESQL_DATABASE=customersdb --labels=app.kubernetes.io/part-of=customers,systemname=customers,tier=database,database=postgresql,customers=database`

`(kubectl get pods | select-string '^customersdb([^\s]+)-(?!deploy)') -match 'customersdb([^\s]+)'; $podname = $matches[0]`

`oc cp .\create_table_customers.sql ${podname}:/tmp/create_table_customers.sql`

`oc cp .\customers.csv ${podname}:/tmp/customers.csv`


`oc exec ${podname} -- psql -d customersdb -U customersdb --no-password -f "/tmp/create_table_customers.sql"`

`oc exec ${podname} -- psql -d customersdb -U customersdb -c "\copy customers FROM '/tmp/customers.csv' delimiter ',' csv"`
