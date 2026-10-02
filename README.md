\# Enterprise Production AI Platform



Production-oriented DevOps/MLOps platform proof-of-concept demonstrating how an AI inference API can be built, secured, tested, containerized, deployed to Kubernetes, delivered through GitOps, monitored with Prometheus/Grafana, and represented as reusable AWS and Azure infrastructure using Terraform.



> \*\*Implementation status:\*\* Application, Docker, Kubernetes, Helm, Argo CD GitOps, CI/security validation, Prometheus, and Grafana were demonstrated locally. AWS/EKS and Azure/AKS infrastructure are represented as validated Terraform IaC; cloud infrastructure was intentionally not provisioned to avoid unnecessary cost.



\---



\## 1. Project Objectives



This project demonstrates production-platform engineering patterns around an AI service:



\- FastAPI-based inference API

\- Automated Python testing

\- Secure Docker containerization

\- GitHub Actions CI

\- Container vulnerability scanning with Trivy

\- Kubernetes deployment

\- Helm packaging

\- Argo CD GitOps and self-healing

\- Prometheus application metrics

\- Grafana observability dashboard

\- AWS/EKS infrastructure as code

\- Azure/AKS infrastructure as code

\- Production security and operational design principles



The focus is not the complexity of the demo model itself. The focus is the \*\*production platform surrounding an AI workload\*\*.



\---



\## 2. High-Level Architecture



```text

&#x20;                        Developer

&#x20;                            |

&#x20;                            v

&#x20;                       Git / GitHub

&#x20;                            |

&#x20;                            v

&#x20;                   GitHub Actions CI

&#x20;            +---------------+---------------+

&#x20;            |               |               |

&#x20;            v               v               v

&#x20;         Pytest         Docker Build    IaC Validation

&#x20;                            |

&#x20;                            v

&#x20;                       Trivy Scan

&#x20;                            |

&#x20;                            v

&#x20;                     Container Image

&#x20;                            |

&#x20;                            v

&#x20;                   Helm Release Definition

&#x20;                            |

&#x20;                            v

&#x20;                        Argo CD

&#x20;                   GitOps Reconciliation

&#x20;                            |

&#x20;                            v

&#x20;                     Kubernetes Cluster

&#x20;                 +----------+-----------+

&#x20;                 |                      |

&#x20;                 v                      v

&#x20;         Production AI API       Config / Runtime

&#x20;            FastAPI                    |

&#x20;                 |                     |

&#x20;                 +----------+----------+

&#x20;                            |

&#x20;                   /health /ready /predict

&#x20;                            |

&#x20;                            v

&#x20;                        /metrics

&#x20;                            |

&#x20;                            v

&#x20;                       Prometheus

&#x20;                            |

&#x20;                            v

&#x20;                         Grafana

&#x20;                            |

&#x20;                            v

&#x20;                Operational Visibility





Cloud Infrastructure Design

\---------------------------



&#x20;       Terraform                         Terraform

&#x20;          AWS                              Azure

&#x20;           |                                 |

&#x20;           v                                 v

&#x20;          EKS                               AKS

&#x20;    AWS platform baseline            Azure platform baseline

```



\---



\## 3. Application Layer



The application exposes a lightweight production-style inference API.



\### Endpoints



| Endpoint | Method | Purpose |

|---|---|---|

| `/` | GET | API information |

| `/health` | GET | Liveness/health check |

| `/ready` | GET | Kubernetes readiness check |

| `/predict` | POST | Demo AI inference request |

| `/metrics` | GET | Prometheus metrics |



Example prediction request:



```json

{

&#x20; "text": "Deploy AI platform to production"

}

```



Example response:



```json

{

&#x20; "prediction": "Processed: Deploy AI platform to production",

&#x20; "confidence": 0.95,

&#x20; "model\_version": "demo-v1"

}

```



\---



\## 4. Automated Testing



Pytest validates the API behavior before later delivery stages are allowed to proceed.



Local validation:



```powershell

python -m pytest -v

```



The test suite validates core API endpoints including health, readiness, and inference behavior.



This provides the first quality gate in the delivery pipeline:



```text

Source Code

&#x20;   |

&#x20;   v

Automated Tests

&#x20;   |

&#x20;   +---- failure ---> stop

&#x20;   |

&#x20;   v

Container Build

```



\---



\## 5. Secure Containerization



The application is packaged using a lightweight Python 3.11 image.



Security controls include:



\- Non-root runtime user

\- Dedicated application user/group

\- Minimal base image

\- No unnecessary development tools in the runtime

\- Explicit application port

\- Dependency installation from `requirements.txt`



The runtime identity was validated as a non-root user.



```text

uid=100(appuser)

gid=101(appgroup)

```



Build:



```powershell

docker build -t enterprise-production-ai-platform:1.0 .

```



Run:



```powershell

docker run --name production-ai-api -p 8000:8000 enterprise-production-ai-platform:1.0

```



\---



\## 6. CI and DevSecOps



GitHub Actions provides automated validation on repository changes.



The CI design includes:



```text

Git Push / Pull Request

&#x20;         |

&#x20;         v

&#x20;      Checkout

&#x20;         |

&#x20;         v

&#x20;     Python Setup

&#x20;         |

&#x20;         v

&#x20;       Pytest

&#x20;         |

&#x20;         v

&#x20;     Docker Build

&#x20;         |

&#x20;         v

&#x20;      Trivy Scan

&#x20;         |

&#x20;         +---- HIGH / CRITICAL ---> fail

&#x20;         |

&#x20;         v

&#x20;  Terraform Validation

&#x20;         |

&#x20;         v

&#x20;     Helm Validation

```



Implemented controls include:



\- Python dependency installation

\- Pytest execution

\- Docker image build

\- Trivy HIGH/CRITICAL vulnerability gate

\- Terraform formatting/validation

\- Helm lint/template validation



This demonstrates a \*\*shift-left security model\*\*, where quality, infrastructure, packaging, and security checks happen before deployment.



\---



\## 7. Kubernetes Deployment



The application was deployed and tested on local Kubernetes using Docker Desktop Kubernetes.



Implemented Kubernetes controls include:



\- Two replicas

\- Rolling updates

\- Liveness probe

\- Readiness probe

\- Resource requests and limits

\- ConfigMap-based configuration

\- ClusterIP service

\- Non-root pod execution

\- RuntimeDefault seccomp profile

\- Linux capability removal

\- Privilege escalation disabled



Example security posture:



```yaml

securityContext:

&#x20; runAsNonRoot: true

&#x20; runAsUser: 100

&#x20; runAsGroup: 101

&#x20; seccompProfile:

&#x20;   type: RuntimeDefault

```



Container security:



```yaml

securityContext:

&#x20; allowPrivilegeEscalation: false

&#x20; capabilities:

&#x20;   drop:

&#x20;     - ALL

```



The application was validated end-to-end through the Kubernetes service.



\---



\## 8. Helm Packaging



The Kubernetes application is packaged as a reusable Helm chart:



```text

helm/

└── production-ai-platform/

&#x20;   ├── Chart.yaml

&#x20;   ├── values.yaml

&#x20;   └── templates/

&#x20;       ├── \_helpers.tpl

&#x20;       ├── configmap.yaml

&#x20;       ├── deployment.yaml

&#x20;       └── service.yaml

```



Validation performed:



```powershell

helm lint helm/production-ai-platform

helm template production-ai helm/production-ai-platform

```



The Helm chart separates reusable templates from environment-specific values and becomes the deployment source consumed by Argo CD.



\---



\## 9. GitOps with Argo CD



Argo CD manages the Kubernetes application using Git as the desired-state source.



```text

Git Repository

&#x20;     |

&#x20;     | desired state

&#x20;     v

&#x20;  Argo CD

&#x20;     |

&#x20;     | compare

&#x20;     v

Kubernetes Actual State

&#x20;     |

&#x20;     +---- drift detected

&#x20;     |

&#x20;     v

Automatic Reconciliation

```



Configured GitOps capabilities:



\- Automated synchronization

\- Automatic pruning

\- Self-healing

\- Namespace creation

\- Helm-based deployment



\### Self-Healing Test



The desired replica count in Git was:



```text

2

```



The running deployment was manually changed to:



```text

1

```



Argo CD detected the configuration drift and automatically restored:



```text

2 replicas

```



This demonstrates declarative infrastructure operations and automatic drift reconciliation.



\---



\## 10. Prometheus Metrics



The FastAPI application exposes Prometheus-compatible metrics through:



```text

/metrics

```



Implemented application metrics include:



\- HTTP request count

\- HTTP request latency histogram

\- Prediction count

\- Endpoint/method/status labels



Examples:



```text

production\_ai\_http\_requests\_total

production\_ai\_http\_request\_duration\_seconds

production\_ai\_predictions\_total

```



Prometheus scrapes:



```text

host.docker.internal:8000/metrics

```



The Prometheus target was verified as:



```text

UP

```



\---



\## 11. Grafana Observability



Grafana consumes Prometheus metrics to provide operational visibility.



The project dashboard contains panels for:



\- Total AI Predictions

\- HTTP Request Rate

\- P95 Request Latency

\- HTTP 5xx Error Rate



Monitoring flow:



```text

FastAPI

&#x20;  |

&#x20;  | /metrics

&#x20;  v

Prometheus

&#x20;  |

&#x20;  | PromQL

&#x20;  v

Grafana

&#x20;  |

&#x20;  v

Operational Dashboard

```



Example PromQL request-rate query:



```promql

sum(rate(production\_ai\_http\_requests\_total\[5m]))

```



P95 latency design:



```promql

histogram\_quantile(

&#x20; 0.95,

&#x20; sum by (le) (

&#x20;   rate(production\_ai\_http\_request\_duration\_seconds\_bucket\[5m])

&#x20; )

)

```



The Grafana dashboard definition is stored in:



```text

observability/grafana/production-ai-platform-dashboard.json

```



This makes the dashboard part of the repository rather than configuration existing only in the local Grafana instance.



\---



\## 12. AWS Infrastructure as Code



AWS infrastructure is represented through Terraform under:



```text

terraform/aws/

```



The AWS baseline includes infrastructure required for an EKS-oriented production platform.



Terraform was initialized, formatted, and validated locally.



```powershell

terraform -chdir=terraform/aws init

terraform -chdir=terraform/aws validate

```



\### Important Scope Note



The AWS configuration represents \*\*validated infrastructure-as-code design\*\*.



A live EKS environment was \*\*not provisioned\*\* as part of this proof-of-concept in order to avoid unnecessary cloud infrastructure charges.



This distinction is intentional:



```text

Terraform Design + Validation    -> Demonstrated

Live AWS EKS Provisioning        -> Not claimed

```



\---



\## 13. Azure Infrastructure as Code



Azure infrastructure is represented through Terraform under:



```text

terraform/azure/

```



The Azure platform baseline includes an AKS-oriented architecture and associated production-platform services defined in Terraform.



Terraform provider:



```text

hashicorp/azurerm

```



The configuration was initialized, formatted, and validated successfully:



```powershell

terraform -chdir=terraform/azure init

terraform fmt ./terraform/azure

terraform -chdir=terraform/azure validate

```



Final validation:



```text

Success! The configuration is valid.

```



\### Important Scope Note



The Azure configuration demonstrates \*\*validated AKS platform infrastructure-as-code\*\*.



Azure infrastructure was not provisioned during this proof-of-concept, preventing unnecessary cloud costs.



```text

Terraform Design + Validation    -> Demonstrated

Live Azure AKS Provisioning      -> Not claimed

```



\---



\## 14. Multi-Cloud Platform Design



The repository demonstrates a cloud-portable application/platform model:



```text

&#x20;                        Application

&#x20;                             |

&#x20;                   Containerized Workload

&#x20;                             |

&#x20;                           Helm

&#x20;                             |

&#x20;                         Kubernetes

&#x20;                        /          \\

&#x20;                       /            \\

&#x20;                     EKS            AKS

&#x20;                    AWS            Azure

&#x20;                     |               |

&#x20;                 Terraform       Terraform

```



The application delivery layer remains largely Kubernetes/Helm based, while Terraform handles cloud-specific infrastructure.



This separation reduces coupling between the application and a specific cloud provider.



\---



\## 15. Security Architecture



Security is applied across multiple layers.



```text

Source

&#x20; |

&#x20; +--> Automated Tests

&#x20; |

&#x20; +--> CI Security Gate

&#x20; |       |

&#x20; |       +--> Trivy

&#x20; |

&#x20; +--> Secure Container

&#x20; |       |

&#x20; |       +--> non-root user

&#x20; |

&#x20; +--> Kubernetes Security

&#x20; |       |

&#x20; |       +--> runAsNonRoot

&#x20; |       +--> seccomp

&#x20; |       +--> drop capabilities

&#x20; |       +--> no privilege escalation

&#x20; |

&#x20; +--> GitOps

&#x20; |       |

&#x20; |       +--> declarative desired state

&#x20; |       +--> drift reconciliation

&#x20; |

&#x20; +--> Cloud Security Design

&#x20;         |

&#x20;         +--> cloud IAM / managed identity patterns

&#x20;         +--> secrets-management architecture

```



\---



\## 16. Reliability and Operational Design



Production-oriented reliability controls demonstrated in the project include:



\- Multiple application replicas

\- Rolling updates

\- Zero-unavailable rolling deployment configuration

\- Liveness checks

\- Readiness checks

\- Resource requests/limits

\- GitOps drift reconciliation

\- Metrics-based observability

\- P95 latency monitoring

\- HTTP error-rate monitoring

\- Infrastructure-as-code reproducibility



\---



\## 17. Repository Structure



```text

enterprise-production-ai-platform/

│

├── .github/

│   └── workflows/

│

├── app/

│   └── main.py

│

├── argocd/

│   └── application.yaml

│

├── helm/

│   └── production-ai-platform/

│

├── kubernetes/

│   └── base/

│

├── observability/

│   ├── grafana/

│   └── prometheus/

│

├── terraform/

│   ├── aws/

│   ├── azure/

│   └── modules/

│

├── tests/

│

├── Dockerfile

├── requirements.txt

└── README.md

```



\---



\## 18. What Was Actually Demonstrated



| Capability | Status |

|---|---|

| FastAPI application | Implemented |

| Automated API tests | Implemented and executed |

| Docker container | Built and executed |

| Non-root container | Verified |

| Kubernetes deployment | Deployed locally |

| Kubernetes service | Tested |

| Health/readiness probes | Implemented |

| Helm chart | Linted, rendered and deployed |

| Argo CD | Installed and configured |

| GitOps synchronization | Demonstrated |

| Argo CD self-healing | Demonstrated |

| Prometheus metrics | Implemented |

| Prometheus scraping | Demonstrated |

| Grafana dashboard | Demonstrated |

| AWS Terraform | Initialized and validated |

| Azure Terraform | Initialized and validated |

| Live AWS EKS provisioning | Not performed |

| Live Azure AKS provisioning | Not performed |



\---



\## 19. Key Engineering Decisions



\### Why Kubernetes?



Provides standardized orchestration, health management, scaling patterns, deployment strategies, and cloud portability.



\### Why Helm?



Separates reusable Kubernetes templates from configurable environment values.



\### Why Argo CD?



Provides declarative GitOps delivery, drift detection, reconciliation, and a clear separation between CI and deployment control.



\### Why Terraform?



Makes infrastructure reproducible, reviewable, version-controlled, and portable across environments.



\### Why Prometheus and Grafana?



Prometheus provides metrics collection and PromQL-based analysis, while Grafana provides operational visualization.



\### Why CI security scanning?



Security issues should be identified before artifacts reach runtime environments rather than relying only on post-deployment detection.



\---



\## 20. CI vs CD / GitOps Responsibility



A key architectural principle in this project is separation of responsibilities:



```text

CI

&#x20;|

&#x20;+--> Test

&#x20;+--> Validate

&#x20;+--> Build

&#x20;+--> Security Scan

&#x20;|

&#x20;v

Trusted Artifact / Configuration



GitOps / CD

&#x20;|

&#x20;+--> Read desired state from Git

&#x20;+--> Deploy

&#x20;+--> Detect drift

&#x20;+--> Reconcile

&#x20;|

&#x20;v

Kubernetes Runtime

```



CI determines whether a change is technically acceptable.



Argo CD determines whether the runtime matches the approved desired state stored in Git.



\---



\## 21. Future Production Enhancements



The following would be logical next steps for a full production environment:



\- Live EKS/AKS provisioning

\- Managed container registry integration

\- Workload Identity / Pod Identity

\- Cloud-native secret management

\- TLS and ingress

\- Horizontal Pod Autoscaling

\- NetworkPolicies

\- Centralized logs and distributed tracing

\- Alertmanager/on-call integration

\- SLO/SLI definitions

\- Remote Terraform state

\- Environment promotion across dev/staging/prod

\- Policy-as-code

\- SBOM/signing and software-supply-chain controls

\- Managed production Prometheus/Grafana or cloud-native monitoring integration



These are intentionally separated from the capabilities already demonstrated so the repository does not overstate its implementation scope.



\---



\## 22. Project Summary



This project demonstrates the engineering path from a simple AI API to a production-oriented platform:



```text

AI API

&#x20; ↓

Automated Testing

&#x20; ↓

Secure Container

&#x20; ↓

CI + Security Scanning

&#x20; ↓

Kubernetes

&#x20; ↓

Helm

&#x20; ↓

Argo CD GitOps

&#x20; ↓

Prometheus + Grafana

&#x20; ↓

AWS/Azure Infrastructure as Code

```



The result is a practical portfolio implementation covering \*\*DevOps, DevSecOps, Kubernetes platform engineering, GitOps, observability, Infrastructure as Code, multi-cloud architecture, and production AI workload delivery\*\*.

