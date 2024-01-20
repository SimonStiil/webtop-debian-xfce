properties([disableConcurrentBuilds(), buildDiscarder(logRotator(artifactDaysToKeepStr: '5', artifactNumToKeepStr: '5', daysToKeepStr: '5', numToKeepStr: '5'))])

@Library('pipeline-library')
import dk.stiil.pipeline.Constants

podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: kaniko
        image: gcr.io/kaniko-project/executor:debug
        command:
        - sleep
        args: 
        - 99d
        volumeMounts:
        - name: kaniko-secret
          mountPath: /kaniko/.docker
      restartPolicy: Never
      volumes:
      - name: kaniko-secret
        secret:
          secretName: dockerhub-dockercred
          items:
          - key: .dockerconfigjson
            path: config.json
''') {
  node(POD_LABEL) {
    TreeMap scmData
    stage('checkout SCM') {  
      scmData = checkout scm
      gitMap = scmGetOrgRepo scmData.GIT_URL
      githubWebhookManager gitMap: gitMap, webhookTokenId: 'jenkins-webhook-repo-cleanup'
      // Non importaint comment
    }
    stage('Build Docker Image') {
      container('kaniko') {
        def properties = readProperties file: 'package.env'
        withEnv(["GIT_COMMIT=${scmData.GIT_COMMIT}", "PACKAGE_NAME=${properties.PACKAGE_NAME}", "GIT_BRANCH=${BRANCH_NAME}"]) {
          if (isMainBranch()){
            sh '''
              /kaniko/executor --force --context `pwd` --log-format text --destination docker.io/simonstiil/$PACKAGE_NAME:$BRANCH_NAME --destination docker.io/simonstiil/$PACKAGE_NAME:latest --label org.opencontainers.image.description="Build based on https://github.com/SimonStiil/keyvaluedatabase/commit/$GIT_COMMIT" --label org.opencontainers.image.revision=$GIT_COMMIT --label org.opencontainers.image.version=$GIT_BRANCH
            '''
          } else {
            sh '''
              /kaniko/executor --force --context `pwd` --log-format text --destination docker.io/simonstiil/$PACKAGE_NAME:$BRANCH_NAME --label org.opencontainers.image.description="Build based on https://github.com/SimonStiil/keyvaluedatabase/commit/$GIT_COMMIT" --label org.opencontainers.image.revision=$GIT_COMMIT --label org.opencontainers.image.version=$GIT_BRANCH
            '''
          }
        }
        
      }
    }
  }
}