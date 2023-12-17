/* groovylint-disable CompileStatic, DuplicateStringLiteral, LineLength, NestedBlockDepth */
pipeline {
    agent any

    parameters {
        string(name: 'ENV', defaultValue: 'dev', description: 'Env name')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'tf action: plan/apply/destroy')
        string(name: 'TARGET', defaultValue: '', description: 'tf target')
        string(name: 'REGION', defaultValue: 'us-east-1', description: 'AWS region')
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
        buildDiscarder(logRotator(
            artifactDaysToKeepStr: ("${BRANCH_NAME}" == 'master' && "${params.ENV}" == 'prod') ? '30' : '5',
            artifactNumToKeepStr: ("${BRANCH_NAME}" == 'master' && "${params.ENV}" == 'prod') ? '10' : '2',
            daysToKeepStr:  ("${BRANCH_NAME}" == 'master' && "${params.ENV}" == 'prod') ? '30' : '5',
            numToKeepStr:  ("${BRANCH_NAME}" == 'master' && "${params.ENV}" == 'prod') ? '30' : '10',
            ))
        ansiColor('xterm')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }

    stages {
        stage('Init') {
            steps {
                sh "terraform init -backend-config=backend-${params.ENV}.hcl -upgrade"
            }
        }

        stage('Plan') {
            when {
                expression {
                    params.ACTION != 'destroy'
                }
            }
            steps {
                script {
                    if (params.TARGET != '') {
                        sh """
                        terraform plan -var-file ${params.ENV}.tfvars -var="env=${params.ENV}" -var="region=${params.REGION}" -var="cluster_name=${params.ENV}-eks-cluster" -target="${params.TARGET}" -out=${params.ENV}_${params.TARGET}.tfplan
                        """
                    } else {
                        sh """
                        terraform plan -var-file ${params.ENV}.tfvars -var="env=${params.ENV}" -var="region=${params.REGION}" -var="cluster_name=${params.ENV}-eks-cluster" -out=${params.ENV}_${params.TARGET}.tfplan
                        """
                    }
                }
            }
        }

        stage('Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }
            steps {
                script {
                    if (params.TARGET != '') {
                        sh """
                        terraform plan -destroy -var-file ${params.ENV}.tfvars -var="env=${params.ENV}" -var="region=${params.REGION}" -var="cluster_name=${params.ENV}-eks-cluster" -target="${params.TARGET}" -out=${params.ENV}_${params.TARGET}.tfplan
                        """
                    } else {
                        sh """
                        terraform plan -destroy -var-file ${params.ENV}.tfvars -var="env=${params.ENV}" -var="region=${params.REGION}" -var="cluster_name=${params.ENV}-eks-cluster" -out=${params.ENV}_${params.TARGET}.tfplan
                        """
                    }
                }
            }
        }

        stage('Apply') {
            when {
                beforeInput true
                expression {
                    params.ACTION ==~ /(apply|destroy)/
                }
            }
            input {
                message 'Apply plan?'
                ok 'Yes'
            }
            steps {
                sh """
                terraform apply "${params.ENV}_${params.TARGET}.tfplan"
                """
            }
        }
    }

    post {
        // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    cleanWhenAborted: true,
                    cleanWhenFailure: true,
                    cleanWhenSuccess: true,
                    cleanWhenUnstable: true)
        }
    }
}
