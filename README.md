# DevOps Tools Installer v4.0

Comprehensive PowerShell script for automated installation of DevOps, Cloud, and Infrastructure tools on Windows.

## Features

- Interactive installation with Yes/No prompts for each application
- Version checking for already installed applications
- Support for Azure, AWS, Google Cloud, and M365/Entra ID
- Automatic VS Code extension installation
- PowerShell module installation with category selection

## Requirements

- Windows 10/11 with PowerShell 5.1 or PowerShell 7+
- Administrator privileges
- Winget (App Installer) from Microsoft Store
- Internet connection

## Usage

```powershell
# Interactive mode - prompts for each application
.\devops_tools.ps1

# Auto-install all (skip already installed)
.\devops_tools.ps1 -AutoYes

# Test mode - no changes made
.\devops_tools.ps1 -WhatIf

# Skip specific categories
.\devops_tools.ps1 -SkipWingetApps
.\devops_tools.ps1 -SkipVSCodeExtensions
.\devops_tools.ps1 -SkipPSModules
.\devops_tools.ps1 -SkipIaCTools
```

---

## Winget Applications (41)

### Basic Tools

| Application | Description |
|-------------|-------------|
| **PowerShell 7** | Modern cross-platform PowerShell with improved performance and new features |
| **Windows Terminal** | Modern terminal application with tabs, panes, GPU-accelerated text rendering |
| **Git** | Distributed version control system |
| **GitHub CLI** | Command-line interface for GitHub - manage PRs, issues, repos from terminal |

### Editors and IDE

| Application | Description |
|-------------|-------------|
| **Visual Studio Code** | Lightweight but powerful source code editor with extensive extension ecosystem |
| **Visual Studio 2022 Community** | Full-featured IDE for .NET, C++, Python development |

### Containers and Kubernetes

| Application | Description |
|-------------|-------------|
| **Docker Desktop** | Container platform for building, sharing, and running containerized applications |
| **kubectl** | Kubernetes command-line tool for cluster management |
| **Helm** | Kubernetes package manager for deploying applications |
| **Minikube** | Local Kubernetes cluster for development and testing |
| **k9s** | Terminal-based UI for Kubernetes cluster management |
| **Lens** | Kubernetes IDE with visual cluster management and monitoring |
| **kubectx/kubens** | Fast switching between Kubernetes contexts and namespaces |
| **stern** | Multi-pod and container log tailing for Kubernetes |

### Infrastructure as Code

| Application | Description |
|-------------|-------------|
| **Terraform** | Infrastructure as Code tool for provisioning cloud resources declaratively |
| **Packer** | Tool for creating identical machine images for multiple platforms |
| **Vault** | Secrets management and data protection tool |
| **Vagrant** | Tool for building and managing virtual machine environments |
| **Azure Developer CLI (azd)** | Developer-centric command-line tool for Azure application development |
| **aztfexport** | Export existing Azure resources to Terraform configuration |
| **Trivy** | Comprehensive security scanner for containers, IaC, filesystems (includes tfsec) |

### Cloud CLI Tools

| Application | Description |
|-------------|-------------|
| **Azure CLI** | Command-line interface for managing Azure resources |
| **Bicep CLI** | Domain-specific language for deploying Azure resources declaratively |
| **kubelogin** | Kubernetes credential plugin for Azure AD authentication |
| **AWS CLI** | Command-line interface for Amazon Web Services |
| **AWS SAM CLI** | CLI for building serverless applications on AWS |
| **AWS Session Manager Plugin** | Plugin for starting sessions to EC2 instances via AWS Systems Manager |
| **eksctl** | Official CLI for Amazon EKS cluster management (by Weaveworks) |
| **Google Cloud SDK** | Command-line interface for Google Cloud Platform |

### Programming Languages

| Application | Description |
|-------------|-------------|
| **Python 3.12** | Popular programming language for scripting, automation, and data science |
| **Node.js LTS** | JavaScript runtime for server-side development |
| **OpenJDK 21** | Open-source Java Development Kit |
| **Go** | Programming language designed for simplicity and efficiency |
| **Rust** | Systems programming language focused on safety and performance |

### Database Clients

| Application | Description |
|-------------|-------------|
| **Azure Storage Explorer** | GUI tool for managing Azure Storage accounts, blobs, queues, tables |
| **DBeaver** | Universal database tool supporting multiple database systems |

### Utilities

| Application | Description |
|-------------|-------------|
| **Postman** | API development and testing platform with collaboration features |
| **jq** | Lightweight command-line JSON processor |
| **bat** | Enhanced cat command with syntax highlighting and git integration |
| **fzf** | Command-line fuzzy finder for files, history, processes |
| **ripgrep** | Extremely fast text search tool (faster than grep) |
| **Starship** | Minimal, blazing-fast, customizable shell prompt |
| **direnv** | Environment variable manager that loads/unloads based on directory |
| **ngrok** | Secure tunnels to localhost for webhooks and testing |
| **SOPS** | Secrets management tool for encrypting files with AWS KMS, GCP KMS, Azure Key Vault |

### Security

| Application | Description |
|-------------|-------------|
| **KeePassXC** | Cross-platform password manager with strong encryption |

### Documentation and Productivity

| Application | Description |
|-------------|-------------|
| **Obsidian** | Knowledge base and note-taking application using Markdown |

---

## VS Code Extensions (40)

### PowerShell

| Extension | Description |
|-----------|-------------|
| **PowerShell** | Rich PowerShell support including IntelliSense, debugging, syntax highlighting |

### Azure

| Extension | Description |
|-----------|-------------|
| **Azure Resource Groups** | View and manage Azure resources directly in VS Code |
| **Azure Account** | Common Azure sign-in and subscription management |
| **Azure Developer CLI** | Integration with azd for Azure application development |
| **Azure Functions** | Create, debug, and deploy Azure Functions |
| **Azure App Service** | Create, manage, and deploy to Azure App Service |
| **Azure Static Web Apps** | Create and manage Azure Static Web Apps |
| **Azure Virtual Machines** | Manage Azure VMs directly from VS Code |
| **Azure Storage** | Manage Azure Blob, File, Queue, and Table storage |
| **Azure Cosmos DB** | Browse and manage Cosmos DB databases |
| **Bicep** | Language support for Bicep files with IntelliSense and validation |
| **Azure Pipelines** | Syntax highlighting and IntelliSense for Azure Pipelines YAML |
| **Azure Logic Apps** | Design and manage Azure Logic Apps workflows |

### AWS

| Extension | Description |
|-----------|-------------|
| **AWS Toolkit** | Develop, debug, and deploy AWS applications from VS Code |
| **CloudFormation Linter** | Validate CloudFormation templates against AWS specifications |
| **CloudFormation Snippets** | Code snippets for AWS CloudFormation templates |

### Google Cloud

| Extension | Description |
|-----------|-------------|
| **Google Cloud Code** | Develop, debug, and deploy GCP applications with Cloud Run, GKE support |

### Terraform & IaC

| Extension | Description |
|-----------|-------------|
| **Terraform** | Official HashiCorp extension with syntax highlighting, IntelliSense, validation |
| **HCL** | HashiCorp Configuration Language support |
| **Infracost** | Cloud cost estimates for Terraform directly in VS Code |

### Kubernetes & Docker

| Extension | Description |
|-----------|-------------|
| **Docker** | Build, manage, and deploy containerized applications |
| **Kubernetes** | Develop, deploy, and debug Kubernetes applications |
| **AKS DevX Tools** | Enhanced Azure Kubernetes Service development experience |
| **YAML** | YAML language support with Kubernetes schema validation |
| **Bridge to Kubernetes** | Run and debug code locally while connected to Kubernetes cluster |
| **GitOps Tools** | Manage Flux and Argo CD GitOps deployments |

### Git & GitHub

| Extension | Description |
|-----------|-------------|
| **GitLens** | Supercharge Git with blame annotations, code lens, and rich history |
| **Git Graph** | Visualize Git repository with interactive graph |
| **GitHub Pull Requests** | Review and manage GitHub pull requests and issues |
| **GitHub Copilot** | AI pair programmer providing code suggestions |
| **GitHub Copilot Chat** | Conversational AI assistant for coding questions |
| **GitHub Actions** | Manage GitHub Actions workflows with syntax highlighting |

### Python

| Extension | Description |
|-----------|-------------|
| **Python** | Rich Python support with IntelliSense, linting, debugging |
| **Pylance** | Fast, feature-rich Python language server |
| **Python Debugger** | Python debugging support using debugpy |
| **Black Formatter** | Automatic Python code formatting with Black |

### Java

| Extension | Description |
|-----------|-------------|
| **Java Extension Pack** | Complete Java development support (includes debugger, Maven, test runner) |

### JavaScript/TypeScript

| Extension | Description |
|-----------|-------------|
| **ESLint** | JavaScript/TypeScript linting with ESLint |
| **Prettier** | Opinionated code formatter for JS, TS, CSS, HTML, JSON, and more |

### Remote Development

| Extension | Description |
|-----------|-------------|
| **Remote - WSL** | Open folders in Windows Subsystem for Linux |
| **Remote - SSH** | Open folders on remote machines via SSH |
| **Remote - Containers** | Open folders inside Docker containers |
| **Remote Explorer** | View and manage remote connections |

### Diagrams & Documentation

| Extension | Description |
|-----------|-------------|
| **Draw.io Integration** | Create and edit diagrams using Draw.io directly in VS Code |
| **Markdown Mermaid** | Preview Mermaid diagrams in Markdown files |
| **Markdown All in One** | Comprehensive Markdown support with preview, TOC, formatting |

### Productivity

| Extension | Description |
|-----------|-------------|
| **EditorConfig** | Override editor settings based on .editorconfig files |
| **Code Spell Checker** | Spelling checker for source code |
| **Live Server** | Local development server with live reload |
| **REST Client** | Send HTTP requests and view responses directly in VS Code |
| **Todo Tree** | Show TODO, FIXME, and other comment tags in a tree view |
| **Project Manager** | Easily switch between projects |

---

## PowerShell Modules

### Azure Core (5 modules)

| Module | Description |
|--------|-------------|
| **Az** | Main Azure PowerShell module (meta-module) |
| **Az.Accounts** | Account and authentication management for Azure |
| **Az.Resources** | Azure Resource Manager operations |
| **Az.ResourceGraph** | Query resources across subscriptions using Azure Resource Graph |
| **Az.Subscription** | Subscription management operations |

### Azure Compute (10 modules)

| Module | Description |
|--------|-------------|
| **Az.Compute** | Virtual machines, VM scale sets, disks management |
| **Az.Functions** | Azure Functions management |
| **Az.App** | Azure Container Apps management |
| **Az.ContainerInstance** | Azure Container Instances operations |
| **Az.ContainerRegistry** | Azure Container Registry management |
| **Az.Aks** | Azure Kubernetes Service management |
| **Az.Batch** | Azure Batch account and job management |
| **Az.DesktopVirtualization** | Azure Virtual Desktop management |
| **Az.ImageBuilder** | Azure Image Builder operations |
| **Az.SpringCloud** | Azure Spring Apps management |

### Azure Networking (6 modules)

| Module | Description |
|--------|-------------|
| **Az.Network** | Virtual networks, NSGs, load balancers, firewalls, VPN gateways |
| **Az.Dns** | Azure public DNS zones and records |
| **Az.PrivateDns** | Azure private DNS zones management |
| **Az.FrontDoor** | Azure Front Door and WAF policies |
| **Az.Cdn** | Azure CDN profiles and endpoints |
| **Az.TrafficManager** | Traffic Manager profiles and endpoints |

### Azure Storage & Data (18 modules)

| Module | Description |
|--------|-------------|
| **Az.Storage** | Storage accounts, blobs, files, queues, tables |
| **Az.Sql** | Azure SQL Database and Managed Instance |
| **Az.CosmosDB** | Azure Cosmos DB accounts and databases |
| **Az.MySql** | Azure Database for MySQL |
| **Az.PostgreSql** | Azure Database for PostgreSQL |
| **Az.MariaDb** | Azure Database for MariaDB |
| **Az.RedisCache** | Azure Cache for Redis management |
| **Az.DataFactory** | Azure Data Factory pipelines and datasets |
| **Az.Synapse** | Azure Synapse Analytics workspaces |
| **Az.Databricks** | Azure Databricks workspaces |
| **Az.DataLakeStore** | Azure Data Lake Storage Gen1 |
| **Az.DataShare** | Azure Data Share accounts |
| **Az.Kusto** | Azure Data Explorer (Kusto) clusters |
| **Az.StreamAnalytics** | Azure Stream Analytics jobs |
| **Az.EventHub** | Azure Event Hubs namespaces and hubs |
| **Az.ServiceBus** | Azure Service Bus namespaces, queues, topics |
| **Az.EventGrid** | Azure Event Grid topics and subscriptions |
| **Az.StorageMover** | Azure Storage Mover service |

### Azure Security & Identity (6 modules)

| Module | Description |
|--------|-------------|
| **Az.KeyVault** | Azure Key Vault secrets, keys, certificates |
| **Az.ManagedServiceIdentity** | Managed Identity operations |
| **Az.Security** | Microsoft Defender for Cloud settings |
| **Az.SecurityInsights** | Microsoft Sentinel (SIEM) operations |
| **Az.Attestation** | Azure Attestation service |
| **Az.ConfidentialLedger** | Azure Confidential Ledger management |

### Azure Management & Governance (11 modules)

| Module | Description |
|--------|-------------|
| **Az.Monitor** | Azure Monitor metrics, alerts, action groups, diagnostics |
| **Az.ApplicationInsights** | Application Insights resources |
| **Az.OperationalInsights** | Log Analytics workspaces and queries |
| **Az.Advisor** | Azure Advisor recommendations |
| **Az.PolicyInsights** | Azure Policy compliance and remediation |
| **Az.Blueprint** | Azure Blueprints definitions and assignments |
| **Az.CostManagement** | Cost analysis and budgets |
| **Az.Billing** | Billing accounts and invoices |
| **Az.Maintenance** | Maintenance configurations |
| **Az.ResourceMover** | Resource move operations across regions |
| **Az.Support** | Azure support tickets |

### Azure DevOps & Automation (3 modules)

| Module | Description |
|--------|-------------|
| **Az.Automation** | Automation accounts, runbooks, DSC |
| **Az.LogicApp** | Logic Apps workflows |
| **Az.DevCenter** | Dev Center and Dev Box management |

### Azure Backup & Recovery (2 modules)

| Module | Description |
|--------|-------------|
| **Az.RecoveryServices** | Azure Backup and Site Recovery vaults |
| **Az.DataProtection** | Backup vaults and policies |

### Azure Integration (5 modules)

| Module | Description |
|--------|-------------|
| **Az.ApiManagement** | Azure API Management services |
| **Az.SignalR** | Azure SignalR Service |
| **Az.NotificationHubs** | Azure Notification Hubs |
| **Az.Communication** | Azure Communication Services |
| **Az.BotService** | Azure Bot Service |

### Azure Web (2 modules)

| Module | Description |
|--------|-------------|
| **Az.Websites** | App Service web apps, plans, slots |
| **Az.StaticWebApp** | Azure Static Web Apps |

### Azure AI & ML (3 modules)

| Module | Description |
|--------|-------------|
| **Az.CognitiveServices** | Azure Cognitive Services accounts |
| **Az.MachineLearning** | Azure Machine Learning (classic) |
| **Az.MachineLearningServices** | Azure Machine Learning workspaces |

### Azure IoT (3 modules)

| Module | Description |
|--------|-------------|
| **Az.IotHub** | Azure IoT Hub management |
| **Az.IotCentral** | Azure IoT Central applications |
| **Az.TimeSeriesInsights** | Azure Time Series Insights environments |

### Azure Hybrid (3 modules)

| Module | Description |
|--------|-------------|
| **Az.StackHCI** | Azure Stack HCI clusters |
| **Az.ConnectedMachine** | Azure Arc-enabled servers |
| **Az.ConnectedKubernetes** | Azure Arc-enabled Kubernetes |

### Microsoft Graph / M365 (30 modules)

| Module | Description |
|--------|-------------|
| **Microsoft.Graph** | Main Microsoft Graph module (meta-module) |
| **Microsoft.Graph.Authentication** | Authentication for Microsoft Graph |
| **Microsoft.Graph.Users** | User management in Entra ID |
| **Microsoft.Graph.Groups** | Group management in Entra ID |
| **Microsoft.Graph.Identity.DirectoryManagement** | Directory roles, administrative units |
| **Microsoft.Graph.Identity.Governance** | Access reviews, entitlement management, PIM |
| **Microsoft.Graph.Identity.SignIns** | Sign-in logs, authentication methods |
| **Microsoft.Graph.Applications** | App registrations and service principals |
| **Microsoft.Graph.DeviceManagement** | Intune device management |
| **Microsoft.Graph.DeviceManagement.Enrollment** | Device enrollment configuration |
| **Microsoft.Graph.DeviceManagement.Actions** | Remote device actions |
| **Microsoft.Graph.DeviceManagement.Administration** | Intune admin settings |
| **Microsoft.Graph.Devices.CorporateManagement** | Intune apps management |
| **Microsoft.Graph.Security** | Security alerts and incidents |
| **Microsoft.Graph.Compliance** | Compliance policies |
| **Microsoft.Graph.Reports** | Usage reports and audit logs |
| **Microsoft.Graph.Mail** | Outlook mail operations |
| **Microsoft.Graph.Calendar** | Calendar management |
| **Microsoft.Graph.Files** | OneDrive and SharePoint files |
| **Microsoft.Graph.Sites** | SharePoint sites |
| **Microsoft.Graph.Teams** | Microsoft Teams management |
| **Microsoft.Graph.Planner** | Planner tasks and plans |
| **Microsoft.Graph.Notes** | OneNote notebooks |
| **Microsoft.Graph.People** | People and contacts |
| **Microsoft.Graph.PersonalContacts** | Personal contacts management |
| **Microsoft.Graph.Bookings** | Microsoft Bookings |
| **Microsoft.Graph.SchemaExtensions** | Directory schema extensions |
| **Microsoft.Graph.DirectoryObjects** | Directory object operations |
| **Microsoft.Graph.CloudCommunications** | Teams calls and meetings |
| **Microsoft.Graph.CrossDeviceExperiences** | Activity feed |

### M365 - Legacy Entra ID (3 modules)

| Module | Description |
|--------|-------------|
| **AzureAD** | Legacy Azure AD module (being deprecated) |
| **AzureADPreview** | Preview features for Azure AD |
| **MSOnline** | Oldest Azure AD module (deprecated) |

### M365 - Exchange Online (1 module)

| Module | Description |
|--------|-------------|
| **ExchangeOnlineManagement** | Exchange Online administration (EXO V3) |

### M365 - Teams (1 module)

| Module | Description |
|--------|-------------|
| **MicrosoftTeams** | Microsoft Teams administration |

### M365 - SharePoint (2 modules)

| Module | Description |
|--------|-------------|
| **Microsoft.Online.SharePoint.PowerShell** | SharePoint Online administration |
| **PnP.PowerShell** | Community-driven SharePoint automation (recommended) |

### M365 - Power Platform (2 modules)

| Module | Description |
|--------|-------------|
| **Microsoft.PowerApps.Administration.PowerShell** | Power Platform admin operations |
| **Microsoft.PowerApps.PowerShell** | Power Apps maker operations |

### M365 - Helper (2 modules)

| Module | Description |
|--------|-------------|
| **MSAL.PS** | Microsoft Authentication Library for PowerShell |
| **MSIdentityTools** | Identity diagnostics and troubleshooting |

### AWS (90+ modules)

| Category | Modules |
|----------|---------|
| **Core** | AWS.Tools.Installer, AWS.Tools.Common |
| **Compute** | EC2, AutoScaling, Lambda, ECS, EKS, ECR, Batch, Lightsail, ElasticBeanstalk, AppRunner |
| **Networking** | ElasticLoadBalancingV2, Route53, Route53Domains, CloudFront, DirectConnect, GlobalAccelerator, APIGateway, VPCLattice |
| **Storage** | S3, EFS, FSx, StorageGateway, Backup, Glacier |
| **Database** | RDS, DynamoDBv2, ElastiCache, Redshift, Neptune, DocumentDB, MemoryDB, Keyspaces, Timestream |
| **Security** | IAM, IdentityStore, SSOAdmin, SSO, SSOOIDC, SecretsManager, KMS, CertificateManager, WAF, WAFV2, Shield, SecurityHub, GuardDuty, Inspector2, Macie2, Detective |
| **Management** | CloudWatch, CloudWatchLogs, CloudTrail, Config, Organizations, ControlTower, ServiceCatalog, SSM, ResourceGroups, ResourceGroupsTaggingAPI, CostExplorer, Budgets, TrustedAdvisor |
| **DevOps** | CodeCommit, CodeBuild, CodeDeploy, CodePipeline, CodeArtifact, CloudFormation, ServiceQuotas |
| **Integration** | SNS, SQS, EventBridge, StepFunctions, AppSync |
| **Analytics** | Athena, Glue, EMR, Kinesis, KinesisFirehose, QuickSight, DataPipeline, LakeFormation, OpenSearchService |
| **AI/ML** | SageMaker, Rekognition, Comprehend, Polly, Translate, Lex, Textract, Bedrock |

### DevOps & Utility (13 modules)

| Module | Description |
|--------|-------------|
| **Pester** | PowerShell testing framework |
| **PSReadLine** | Enhanced command-line editing experience |
| **Terminal-Icons** | File and folder icons in terminal |
| **posh-git** | Git status and tab completion for PowerShell |
| **PSScriptAnalyzer** | Static code analysis for PowerShell |
| **ImportExcel** | Excel file manipulation without Excel installed |
| **PSGraph** | Build graphs using GraphViz from PowerShell |
| **Plaster** | PowerShell template-based scaffolding |
| **SecretManagement** | Cross-platform secrets management abstraction |
| **SecretStore** | Local secure secret storage |
| **Az.KeyVault.SecretManagement** | Azure Key Vault as secret store |
| **powershell-yaml** | YAML parsing for PowerShell |
| **Posh-SSH** | SSH sessions from PowerShell |

---

## IaC Tools (pip, npm, go, binary)

### pip Tools

| Tool | Description |
|------|-------------|
| **pre-commit** | Git hooks framework for code quality |
| **detect-secrets** | Detect secrets in source code |
| **cfn-lint** | CloudFormation template linter |
| **diagrams** | Create infrastructure diagrams as code |

### npm Tools

| Tool | Description |
|------|-------------|
| **aws-cdk** | AWS Cloud Development Kit |
| **cdktf-cli** | Terraform Cloud Development Kit |

### Go Tools

| Tool | Description |
|------|-------------|
| **terraformer** | Import existing infrastructure to Terraform |
| **tflint** | Terraform linter for best practices |
| **driftctl** | Detect infrastructure drift |
| **tfmigrate** | Terraform state migration tool |
| **kustomize** | Kubernetes native configuration management |

### Binary Downloads

| Tool | Description |
|------|-------------|
| **Terragrunt** | Terraform wrapper for DRY configurations |
| **Infracost** | Cloud cost estimates for Terraform |

---

## License

MIT License - Feel free to use and modify.

## Contributing

Pull requests welcome. For major changes, please open an issue first.
