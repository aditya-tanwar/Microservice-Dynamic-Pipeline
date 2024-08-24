pipeline {
    agent any

    options {
    	skipDefaultCheckout true
  	}
    

    stages {

        stage("Cleaning the Workspace before starting further steps"){
            steps{
                cleanWs() // This is a jenkins inbuild function that is used to clean the workspace.
            }
        } // End of the Cleaning Workspace stage


        stage('Git-Checkout') {
            steps {
                git credentialsId: 'git', poll: false, url: 'https://github.com/elgris/microservice-app-example.git'
            }
        } // end of Git-Checkout stage 

        //---------------------------------

        stage("Trivy Scan - Git Repository "){
            steps{
                 sh "trivy repository --scanners vuln,secret,misconfig https://github.com/elgris/microservice-app-example.git --branch master --format json --output trivy-report.json"
                 sh "trivy repo --scanners vuln,secret,misconfig https://github.com/elgris/microservice-app-example.git --branch master --format table --output trivy-report-table " //default format 
                // sh "trivy fs auth-api/"   // this is for scanning the file system 
            }
        }




// Maintaining parallel Docker builds for the microservices 

        stage('image build') {
            parallel {
                stage('build image for auth api') {
                    steps {

                        sh 'docker build -t auth-api-$(date +"%F") auth-api/. '
                        // sh 'trivy image --scanners vuln,misconfig,secret auth-api-$(date +"%F") --format json' // TRIVY SCAN 
                        sh 'mkdir dockle-reports && dockle auth-api-$(date +"%F") && dockle -f json -o dockle-reports/auth-api-dockle-report.json auth-api-$(date +"%F")' // DOCKLE SCAN
                        sh '''
                            if [ $(cat dockle-reports/auth-api-dockle-report.json | jq .summary.fatal) -eq 1 ]; then
                                docker tag auth-api-$(date +"%F") adityatanwar03/auth-api-$(date +"%F")
                                docker push adityatanwar03/auth-api-$(date +"%F")
                            else
                                echo "Image is not pushed successfully"
                            fi
                        '''
                    }
                
                }
                stage('build image for user api') {
                    steps {
                        sh 'docker build -t users-api-$(date +"%F") users-api/.'
                        // sh 'trivy image --scanners vuln,misconfig,secret users-api-$(date +"%F") --format json'
                        sh 'dockle users-api-$(date +"%F") && dockle -f json -o dockle-reports/users-api-dockle-report.json users-api-$(date +"%F")'

                    }
                }
                stage('build image for todos-api') {
                    steps {
                        sh 'docker build -t todos-api-$(date +"%F") todos-api/.'
                        // sh 'trivy image --scanners vuln,misconfig,secret todos-api-$(date +"%F") --format json'
                        sh 'dockle todos-api-$(date +"%F") && dockle -f json -o dockle-reports/todos-api-dockle-report.json todos-api-$(date +"%F")'
                    }
                }
                stage('build image for frontend') {
                    steps {
                        sh 'docker build -t frontend-$(date +"%F") frontend/.'
                        // sh 'trivy image --scanners vuln,misconfig,secret frontend-$(date +"%F") --format json'
                        sh 'dockle frontend-$(date +"%F") && dockle -f json -o dockle-reports/frontend-dockle-report.json frontend-$(date +"%F")'
                    }
                }
                stage('build image for log-message') {
                    steps {
                        sh 'docker build -t log-message-processor-$(date +"%F") log-message-processor/.'
                        // sh 'trivy image --scanners vuln,misconfig,secret log-message-processor-$(date +"%F") --format json'
                        sh 'dockle log-message-processor-$(date +"%F") && dockle -f json -o dockle-reports/log-message-processor-dockle-report.json log-message-processor-$(date +"%F")'
                    }
                }

            }
        }


    }

}

