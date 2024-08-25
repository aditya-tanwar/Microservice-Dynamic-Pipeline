

pipeline{
    agent any

// this will disable the automatic checkout
    options {
        skipDefaultCheckout true
    }

    parameters {
        string(name: 'app_version', defaultValue: '', descriptions: 'Application Version to build')
    }

// Setting up fixed values as environmental variables 
    environment {
        NEXUS_URL = "192.168.0.104:8082"
    }

    stages {

    // Git Checkout 

        stage ('Git-Checkout') {
            steps {
                git credentialsId: 'git', poll: false, url: 'https://github.com/aditya-tanwar/Microservice-Dynamic-Pipeline.git', branch: env.BRANCH_NAME
            }
        }

// Trivy Filesystem Scanning 

        stage ('Trivy-File-System-Scanning') {
            steps {
                sh 'trivy fs . --format json --output trivy-results.json'
            }
        }

// Dependency Check 

        stage ('Dependency-Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }


// Dynamic Pipelines         
        
        stage ('Dynamic Pipeline') {
            steps {
                script {
                    def microservices = readFile('components').split('\n')
                    def parallelStages = [:]

                    microservices.each { microservice ->
                        parallelStages["${microservice}"] = {
                            stage ("${microservice}") {
                                echo "${microservice}"
                                script{

                                    stage ("Docker-Image-Build") {
                                        echo "build"
                                        sh "docker build -t ${microservice}-`date +'%F'`:v1 ${microservice}/"

                                    }

                                    stage ("Docker-Image-Scan") {
                                        sh '''
                                            trivy image --scanners vuln,misconfig,secret ${microservice}-$(date +"%F"):v${app_version} --format json -o TEST-RESULTS/trivy-log-message-processor-$(date +"%F")-v${app_version}.json
                                            dockle -f json log-message-processor-$(date +"%F"):v${app_version} > TEST-RESULTS/dockle-log-message-processor-$(date +"%F")-v${app_version}.json

                                        '''
                                    }

                                    stage ("Taggin & Pushing Image") {
                                        sh '''
                                            if [ $( cat TEST-RESULTS/dockle-log-message-processor-$(date +"%F")-v${app_version}.json | jq -r '.summary.fatal' ) -lt 3 ]; then
                                                docker tag log-message-processor-$(date +"%F"):v${app_version} ${NEXUS_URL}/log-message-processor-$(date +"%F"):v${app_version}
                                            else
                                                echo "Docker image build failed , Please check the trivy and Dockle reports for troubleshooting"
                                            fi
                                        '''
                                        sh "echo 'Pushing image to docker hosted rerpository on Nexus'"

                                        withCredentials([usernamePassword(credentialsId: 'nexuslogin', passwordVariable: 'PSW', usernameVariable: 'USER')]){
                                        sh "echo ${PSW} | docker login -u ${USER} --password-stdin ${NEXUS_URL}"
                                        sh 'docker push ${NEXUS_URL}/log-message-processor-$(date +"%F"):v${app_version}'
                                        }   
                                    }
                                }
                            }
                        }
                        parallel parallelStages
                    }
                }
            }
        } // End of Dynamic Pipeline stage


    }
}
