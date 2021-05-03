# bdd-demo

this is to be set at the beginning

```shell
export namespace=poc-dev
```

#deploy jenkins

```shell
oc login
oc new-project ${namespace}
oc process openshift//jenkins-ephemeral | oc apply -f- -n ${namespace}
oc set env dc/jenkins JENKINS_JAVA_OVERRIDES=-Dhudson.model.DirectoryBrowserSupport.CSP='' INSTALL_PLUGINS=ansicolor:0.5.2 -n ${namespace}
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

The E2E tests require a selenium instance to be running. You can quickly spin up a chrome selenium instance with:

```bash
podman run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:4.0.0-beta-3-20210426
```

Once you have a selenium instance, you can run `npm run e2e` to execute the end-to-end tests.


## running oracle

### build oracle image

run only once

```shell
oc apply -f ./oracle/build.yaml -n ${namespace}
```

### deploy oracle

```shell
oc apply -f ./oracle/statefulset.yaml -n ${namespace}
```


cat Dockerfile.xe | oc new-build https://github.com/oracle/docker-images.git --strategy docker --context-dir ./OracleDatabase/SingleInstance/dockerfiles/18.4.0 --dockerfile - --name oracle-xe

