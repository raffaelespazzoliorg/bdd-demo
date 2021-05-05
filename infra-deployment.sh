
#!/bin/sh
# This is a comment!
echo Hello World        # This is a comment, too!
echo $NAMESPACE

oc login 

oc new-project $NAMESPACE

oc process openshift//jenkins-ephemeral | oc apply -f- -n $NAMESPACE

oc set env dc/jenkins JENKINS_JAVA_OVERRIDES=-Dhudson.model.DirectoryBrowserSupport.CSP='' INSTALL_PLUGINS=ansicolor:0.5.2 -n $NAMESPACE


oc process -f applier/templates/infra-build.yaml  | oc apply -f- -n $NAMESPACE
