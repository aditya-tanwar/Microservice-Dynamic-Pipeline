


pipeline{
    agent any

    stages {
        stage('Dynamic Pipeline') {
            steps {
                script {
                    def microservices = readFile('components').split('\n')
                    def parallelStages = [:]

                    microservices.each { microservice ->
                        parallelStages["${microservice}"] = {
                            stage("${microservice}") {
                                echo "${microservice}"
                                script{
                                    stage ("build") {
                                        echo "build"
                                        sh "docker build -t ${microservice}-`date +'%F'`:v1 ${microservice}/"
                                    }
                                }
                            }
                        }
                    }
                    parallel parallelStages
                }
            }
        }
    }
}
