// testing jenkins
def testSuites = ['service1', 'service2', 'service3']
def substages = ['substage1', 'substage2', 'substage3']

pipeline {
    agent any
    stages {
        stage('Parallel Tests') {
            steps {
                script {
                    def parallelStages = testSuites.collectEntries {
                        ["${it.capitalize()} Tests" : {
                            stage("Running ${it} tests") {
                                script {
                                    substages.each { substage ->
                                        stage("Executing ${substage}") {
                                            echo "Running ${substage} for ${it}..."
                                            // Add actual test execution for the substage here
                                        }
                                    }
                                }
                            }
                        }]
                    }
                    parallel parallelStages
                }
            }
        }
    }
}
