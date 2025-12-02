pipeline {
    agent {
        kubernetes {
            label 'docker-helm'
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-admin
  containers:
    - name: docker
      image: docker:25-dind
      securityContext:
        privileged: true
      volumeMounts:
        - name: docker-graph-storage
          mountPath: /var/lib/docker
    - name: helm
      image: alpine/helm:3
      command: [cat]
      tty: true
    - name: mcp/git
          image: mcp/git:latest
          command: ['sleep']
          args: ['99d']
  volumes:
    - name: docker-graph-storage
      emptyDir: {}
"""
        }
    }
    environment {
        IMAGE_NAME= "loulah/vprofile"
        TAG = "${BUILD_NUMBER}"
        LATEST_TAG= "latest"
        HELM_NAMESPACE = "production"
    }
    options {
            skipDefaultCheckout() // Skips default checkout for the entire pipeline
        }

    stages {
        stage("checkout code"){
            steps{
                container('docker') {
                    sh "git clone https://github.com/kareemloulah/NinjaApp.git"
                    }
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                container('docker') {
                    sh "cd Application"
                    sh "docker build -t ${IMAGE_NAME}:${TAG} -t  ${IMAGE_NAME}:${LATEST_TAG}  -f ./Application/app/Dockerfile ./Application/app"
                    withCredentials([usernamePassword(credentialsId: 'dockerlogin', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                        sh "echo ${docker_pass} | docker login -u ${docker_user} --password-stdin docker.io"
                        sh "docker push ${IMAGE_NAME}:${TAG}"
                        sh "docker push ${IMAGE_NAME}:${LATEST_TAG}"
                    }
                }
            }
            post {
                failure {
                    mail to: 'loulahkareem@gmail.com',
                    subject: "Pipeline Failure: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                    body: "The '${env.STAGE_NAME}' stage failed. Check the console output: ${env.BUILD_URL}"
                }
            }
        }
        stage('Local Smoke Test (docker-compose)') {
            steps {
                container('docker') {
                    sh """
                    echo "Starting local smoke test..."
                    apk add --no-cache curl
                    cd Application
                    docker compose up -d

                    echo "Waiting for container to come up..."
                    sleep 100
                    
                    # HEALTH CHECK
                    curl http://localhost:80/login || (echo "Smoke test failed!" && exit 1)
                    echo "Smoke test passed!"
                    """
                }
            }
            post {
                failure {
                    mail to: 'loulahkareem@gmail.com',
                    subject: "Pipeline Failure: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                    body: "The '${env.STAGE_NAME}' stage failed. Check the console output: ${env.BUILD_URL}"
                }
            }
        }
        // stage('Deploy with Helm') {
        //     steps {
        //         container('helm') {
        //             sh """
        //     helm upgrade --install my-app ./k8s/app-chart/ \\
        //       --set images.go.tag=${BUILD_NUMBER} \\
        //       --namespace $HELM_NAMESPACE \\
        //       --create-namespace --wait
        //   """
        //         }
        //     }
        // }
    }
}