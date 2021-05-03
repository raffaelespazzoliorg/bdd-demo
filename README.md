# bdd-demo

this is to be set at the beginning

```shell
export namespace=poc-dev
```

#Create Pipeline

Execute the infra-deployment.sh script to deploy Jenkins amd create pipeline(s)


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

## running oracle

### build oracle image

run only once

```shell
oc apply -f ./oracle/build.yaml -n ${namespace}
```

### deploy oracle

```shell
oc adm policy add-scc-to-user anyuid -z oracle -n ${namespace}
oc apply -f ./oracle/statefulset.yaml -n ${namespace}
```

## deploying the rest application

```shell
oc apply -f spring-pet-clinic-rest/spring-pet-clinic.yaml -n ${namespace}
```
