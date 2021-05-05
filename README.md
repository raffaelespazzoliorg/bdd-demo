# bdd-demo

This is to be set at the beginning.

```shell
export namespace=poc-dev
```

## Deploy Jenkins

```shell
oc new-project ${namespace}
oc process openshift//jenkins-ephemeral | oc apply -f- -n ${namespace}
oc set env dc/jenkins JENKINS_JAVA_OVERRIDES=-Dhudson.model.DirectoryBrowserSupport.CSP='' INSTALL_PLUGINS=ansicolor:0.5.2 -n ${namespace}
```

## Deploy pipeline

```shell
oc create serviceaccount oracle -n ${namespace}
oc adm policy add-scc-to-user anyuid -z oracle -n ${namespace}
oc apply -f ./pipeline/jenkins-pipeline.yaml -n ${namespace}
```

## The Angular Application

### Local Development

In the angular project directory, run `npm install`. This will install all required dependencies to develop and run the application locally.

Several utility scripts are provided with the application. Check out the `scripts` section of `package.json` to see what's available.

### Testing

The application is configured to run unit tests and end-to-end tests.

#### Unit Tests

Unit tests can be run with `npm run test`.
As is typical with Angular projects, unit are colocated with the units they are testing in `*.spec.*` files.

#### E2E Tests

E2E tests are defined using CucumberJS, Protractor. The cucumber tests are stored in `cucumber/`.

The feature specifications are at the root of the cucumber directory. Step definitions are in `cucumber/step_definitions`.

To run the E2E tests on your local machine, follow these steps:

1. Start the REST Api on your local machine
   1. Navigate to the project folder of the rest api
   1. Run `./mvnw spring-boot:run`
1. Start the Angular app, and have it listen for requests on your host ip address
   - `npm run start -- --host 0.0.0.0`
1. Start the selenium docker container
   - `podman run --name selenium -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:4.0.0-beta-3-20210426`
1. Run your end-to-end tests, using your host ip address
   - Linux: `` npm run e2e -- --dev-server-target="" --base-url http://`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/'`:4200 ``
   - Other: `npm run e2e -- --dev-server-target="" --base-url http://<YOUR_MACHINE_IP_ADDRESS>:4200`

## Run Oracle Database 18c (XE)

### Build Image

Run once and wait for build to complete before moving on.

```shell
oc apply -f ./oracle/build.yaml -n ${namespace}
```

### Deploy Container

```shell
oc create serviceaccount oracle -n ${namespace}
oc adm policy add-scc-to-user anyuid -z oracle -n ${namespace}
oc apply -f ./oracle/statefulset.yaml -n ${namespace}
```

## Deploy Application

```shell
oc apply -f spring-pet-clinic-rest/spring-pet-clinic.yaml -n ${namespace}
```


## Streaming demo

Deploy oracle dbs

```shell
export namespace=streaming-demo
oc new-project ${namespace}
```

```shell
oc adm policy add-scc-to-user anyuid -z default -n ${namespace}
oc apply -f ./streaming/example -n ${namespace}
export connect_url=$(oc get route connect -n ${namespace} -o jsonpath='{.spec.host}')
```

initial situation

```shell
oc exec -n ${namespace} mysql-0 -- bash -c 'mysql -u $MYSQL_USER  -p$MYSQL_PASSWORD inventory -e "select * from customers"' 
oc exec -n ${namespace} postgres-0 -- bash -c 'psql -U $POSTGRES_USER $POSTGRES_DB -c "select * from customers"'
```

activate stream

```shell
# Start PostgreSQL connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://${connect_url}/connectors/ -d @./streaming/stream/jdbc-sink.json

# Start MySQL connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://${connect_url}/connectors/ -d @./streaming/stream/source.json
```

check status on target database

```shell
oc exec -n ${namespace} postgres-0 -- bash -c 'psql -U $POSTGRES_USER $POSTGRES_DB -c "select * from customers"'
```

insert a record on source database

```shell
oc exec -ti -n ${namespace} mysql-0 -- bash -c 'mysql -u $MYSQL_USER  -p$MYSQL_PASSWORD inventory'
insert into customers values(default, 'John', 'Doe', 'john.doe@example.com');
```

check status on target database

```shell
oc exec -n ${namespace} postgres-0 -- bash -c 'psql -U $POSTGRES_USER $POSTGRES_DB -c "select * from customers"'
```
