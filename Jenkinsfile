#!/usr/bin/env groovy

pipeline {
    agent any
    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(
            logRotator(
                daysToKeepStr: '1',
                artifactNumToKeepStr: '1',
                numToKeepStr: '1'
            )
        )
    }
    environment {
        PACKAGE_PATH='isecops-infrastructure'
        TOOLS_VERSION='1.0.1'
        DOCKER_RO_CREDENTIALS='pdxc-r'
        ARTIFACTORY_RW_CREDENTIALS='pdxc-jenkins'
    }

    stages {
        stage('Check dockerfile') {
            agent {
                dockerfile {
                    args '-v ./code:/tmp/code'
                }
            }
            steps {
                sh """
                |terraform version
                |ls /tmp/code
                |""".stripMargin()
            }
        }
    }
}

def withAwsCredentials(Map args, Closure body) {
    withCredentials ([
        string(credentialsId: args.roleArnCredId, variable: args.roleArnCredId),
        string(credentialsId: args.externalIdCredId, variable: args.externalIdCredId)])
    {
        try {
            withAWS (role: env[args.roleArnCredId], externalId: env[args.externalIdCredId]) {
                wrap ([$class: 'MaskPasswordsBuildWrapper', varPasswordPairs: [
                    [password: env.AWS_ACCESS_KEY_ID, var: 'AWS_ACCESS_KEY_ID'],
                    [password: env.AWS_SECRET_ACCESS_KEY, var: 'AWS_SECRET_ACCESS_KEY']]]
                ) {
                    body()
                }
            }
        } catch (Throwable th) {
            echo th.getMessage()
        }
    }
}

