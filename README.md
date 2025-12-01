<h3 align="center"> Deploy 3-tier app </h3>


### Architecture

```mermaid
flowchart TB
    Users((Users)) -->|HTTPS| Internet
    Developer((Developer)) -->|SSH/Git| Internet
    
    Internet --> IGW[Internet Gateway]
    
    subgraph AWS["AWS Cloud - VPC 10.0.0.0/16"]
        IGW --> K8s
        
        subgraph K8s["Kubernetes Cluster"]
            Master[Master Node<br/>Control Plane]
            Worker1[Worker 1<br/>Workloads]
            Worker2[Worker 2<br/>Workloads]
            
            Master --> Worker1
            Master --> Worker2
        end
        
        subgraph Apps["Applications"]
            Microservices[Microservices<br/>vprofile namespace]
            Monitoring[Prometheus + Grafana<br/>monitoring namespace]
        end
        
        Jenkins[Jenkins CI/CD] -->|Deploy| Master
        Jenkins -->|Push Images| ECR[AWS ECR]
        Master -->|Pull Images| ECR
        
        K8s -.->|Metrics| Monitoring
    end
    
    classDef k8s fill:#326CE5,stroke:#fff,stroke-width:2px,color:#fff
    classDef app fill:#13aa52,stroke:#fff,stroke-width:2px,color:#fff
    classDef aws fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:#fff
    
    class Master,Worker1,Worker2 k8s
    class Microservices,Monitoring app
    class ECR,Jenkins aws
```

### Components

**Network Layer:**
- VPC with CIDR 10.0.0.0/16
- Public Subnet: ALB, NAT Gateway, Bastion Host
- Private Subnet: Kubernetes cluster (master + workers)
- CI/CD Subnet: Jenkins server (isolated)
- Security Groups: Strict ingress/egress rules per component

**Kubernetes Cluster (kubeadm):**
- 1 Master Node
- 2 Worker Nodes
- CNI Plugin: Calico/Cilium (NetworkPolicy support)
- Namespaces: `vprofile` (apps), `monitoring` (observability)

**Monitoring:**
- Prometheus: Metrics collection
- Grafana: Visualization dashboards
- Node Exporters: System metrics
- CloudWatch: Centralized logging and alarms
