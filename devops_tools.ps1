#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Installation of DevOps tools using winget and VS Code extensions
.DESCRIPTION
    Script installs common DevOps tools via winget and extensions for VS Code
.NOTES
    Run as Administrator
#>

[CmdletBinding()]
param(
    [switch]$SkipWingetApps,
    [switch]$SkipVSCodeExtensions,
    [switch]$SkipIaCTools,
    [switch]$SkipPSModules,
    [switch]$AutoYes,
    [switch]$WhatIf
)

# === CONFIGURATION ===

# Winget applications to install
$WingetApps = @(
    # --- Basic tools ---
    @{ Id = "Microsoft.PowerShell";                     Name = "PowerShell 7" }
    @{ Id = "Microsoft.WindowsTerminal";                Name = "Windows Terminal" }
    @{ Id = "Git.Git";                                  Name = "Git" }
    @{ Id = "GitHub.cli";                               Name = "GitHub CLI" }
    
    # --- Editors and IDE ---
    @{ Id = "Microsoft.VisualStudioCode";               Name = "Visual Studio Code" }
    @{ Id = "Microsoft.VisualStudio.2022.Community";    Name = "Visual Studio 2022 Community" }
    
    # --- Containers and Kubernetes ---
    @{ Id = "Docker.DockerDesktop";                     Name = "Docker Desktop" }
    @{ Id = "Kubernetes.kubectl";                       Name = "kubectl" }
    @{ Id = "Helm.Helm";                                Name = "Helm" }
    @{ Id = "Kubernetes.minikube";                      Name = "Minikube" }
    @{ Id = "derailed.k9s";                             Name = "k9s" }
    @{ Id = "Mirantis.Lens";                            Name = "Lens (Kubernetes IDE)" }
    @{ Id = "ahmetb.kubectx";                           Name = "kubectx/kubens" }
    @{ Id = "stern.stern";                              Name = "stern (multi-pod logs)" }
    
    # --- Infrastructure as Code ---
    @{ Id = "Hashicorp.Terraform";                      Name = "Terraform" }
    @{ Id = "Hashicorp.Packer";                         Name = "Packer" }
    @{ Id = "Hashicorp.Vault";                          Name = "Vault" }
    @{ Id = "Hashicorp.Vagrant";                        Name = "Vagrant" }
    @{ Id = "Microsoft.Azd";                            Name = "Azure Developer CLI (azd)" }
    
    # --- IaC Import/Export tools ---
    @{ Id = "Azure.aztfexport";                         Name = "aztfexport" }
    
    # --- IaC Security (Trivy includes tfsec) ---
    @{ Id = "aquasecurity.trivy";                       Name = "Trivy (security scanner)" }
    
    # --- Cloud CLI tools ---
    @{ Id = "Microsoft.AzureCLI";                       Name = "Azure CLI" }
    @{ Id = "Microsoft.Bicep";                          Name = "Bicep CLI" }
    @{ Id = "Azure.kubelogin";                          Name = "kubelogin (AKS AAD)" }
    @{ Id = "Amazon.AWSCLI";                            Name = "AWS CLI" }
    @{ Id = "Amazon.SAM-CLI";                           Name = "AWS SAM CLI" }
    @{ Id = "Amazon.SessionManagerPlugin";              Name = "AWS Session Manager Plugin" }
    @{ Id = "Weaveworks.eksctl";                        Name = "eksctl" }
    @{ Id = "Google.CloudSDK";                          Name = "Google Cloud SDK" }
    
    # --- Programming languages ---
    @{ Id = "Python.Python.3.12";                       Name = "Python 3.12" }
    @{ Id = "OpenJS.NodeJS.LTS";                        Name = "Node.js LTS" }
    @{ Id = "Microsoft.OpenJDK.21";                     Name = "OpenJDK 21" }
    @{ Id = "GoLang.Go";                                Name = "Go" }
    @{ Id = "Rustlang.Rustup";                          Name = "Rust" }
    
    # --- Database clients ---
    @{ Id = "Microsoft.Azure.StorageExplorer";          Name = "Azure Storage Explorer" }
    @{ Id = "dbeaver.dbeaver";                          Name = "DBeaver" }
    
    # --- Utilities ---
    @{ Id = "Postman.Postman";                          Name = "Postman" }
    @{ Id = "jqlang.jq";                                Name = "jq (JSON processor)" }
    @{ Id = "sharkdp.bat";                              Name = "bat (better cat)" }
    @{ Id = "junegunn.fzf";                             Name = "fzf (fuzzy finder)" }
    @{ Id = "BurntSushi.ripgrep.MSVC";                  Name = "ripgrep" }
    @{ Id = "Starship.Starship";                        Name = "Starship prompt" }
    @{ Id = "direnv.direnv";                            Name = "direnv" }
    @{ Id = "ngrok.ngrok";                              Name = "ngrok" }
    @{ Id = "Mozilla.sops";                             Name = "SOPS (secrets)" }
    
    # --- Security ---
    @{ Id = "KeePassXCTeam.KeePassXC";                  Name = "KeePassXC" }
    
    # --- Documentation and productivity ---
    @{ Id = "Obsidian.Obsidian";                        Name = "Obsidian" }
)

# VS Code extensions to install
$VSCodeExtensions = @(
    # === POWERSHELL ===
    @{ Id = "ms-vscode.powershell"; Name = "PowerShell" }
    
    # === AZURE - Core ===
    @{ Id = "ms-azuretools.vscode-azureresourcegroups"; Name = "Azure Resource Groups" }
    @{ Id = "ms-vscode.azure-account"; Name = "Azure Account" }
    @{ Id = "ms-azuretools.azure-dev"; Name = "Azure Developer CLI" }
    
    # === AZURE - Compute & Containers ===
    @{ Id = "ms-azuretools.vscode-azurefunctions"; Name = "Azure Functions" }
    @{ Id = "ms-azuretools.vscode-azureappservice"; Name = "Azure App Service" }
    @{ Id = "ms-azuretools.vscode-azurestaticwebapps"; Name = "Azure Static Web Apps" }
    @{ Id = "ms-azuretools.vscode-azurevirtualmachines"; Name = "Azure Virtual Machines" }
    @{ Id = "ms-azuretools.vscode-docker"; Name = "Docker" }
    @{ Id = "ms-kubernetes-tools.vscode-kubernetes-tools"; Name = "Kubernetes" }
    @{ Id = "ms-kubernetes-tools.aks-devx-tools"; Name = "AKS DevX Tools" }
    
    # === AZURE - Storage & Data ===
    @{ Id = "ms-azuretools.vscode-azurestorage"; Name = "Azure Storage" }
    @{ Id = "ms-azuretools.vscode-cosmosdb"; Name = "Azure Cosmos DB" }
    
    # === AZURE - IaC ===
    @{ Id = "ms-azuretools.vscode-bicep"; Name = "Bicep" }
    
    # === AZURE - DevOps ===
    @{ Id = "ms-azure-devops.azure-pipelines"; Name = "Azure Pipelines" }
    
    # === AZURE - Logic Apps ===
    @{ Id = "ms-azuretools.vscode-logicapps"; Name = "Azure Logic Apps" }
    
    # === AWS ===
    @{ Id = "amazonwebservices.aws-toolkit-vscode"; Name = "AWS Toolkit" }
    @{ Id = "kddejong.vscode-cfn-lint"; Name = "CloudFormation Linter" }
    @{ Id = "dsteenman.cloudformation-yaml-snippets"; Name = "CloudFormation Snippets" }
    
    # === GOOGLE CLOUD ===
    @{ Id = "googlecloudtools.cloudcode"; Name = "Google Cloud Code" }
    
    # === TERRAFORM & IaC (official only) ===
    @{ Id = "hashicorp.terraform"; Name = "Terraform" }
    @{ Id = "hashicorp.hcl"; Name = "HCL" }
    @{ Id = "infracost.infracost"; Name = "Infracost" }
    
    # === KUBERNETES & GitOps ===
    @{ Id = "redhat.vscode-yaml"; Name = "YAML" }
    @{ Id = "mindaro.mindaro"; Name = "Bridge to Kubernetes" }
    @{ Id = "weaveworks.vscode-gitops-tools"; Name = "GitOps Tools" }
    
    # === GIT ===
    @{ Id = "eamodio.gitlens"; Name = "GitLens" }
    @{ Id = "mhutchie.git-graph"; Name = "Git Graph" }
    @{ Id = "github.vscode-pull-request-github"; Name = "GitHub Pull Requests" }
    @{ Id = "github.copilot"; Name = "GitHub Copilot" }
    @{ Id = "github.copilot-chat"; Name = "GitHub Copilot Chat" }
    @{ Id = "github.vscode-github-actions"; Name = "GitHub Actions" }
    
    # === PYTHON ===
    @{ Id = "ms-python.python"; Name = "Python" }
    @{ Id = "ms-python.vscode-pylance"; Name = "Pylance" }
    @{ Id = "ms-python.debugpy"; Name = "Python Debugger" }
    @{ Id = "ms-python.black-formatter"; Name = "Black Formatter" }
    
    # === JAVA (Extension Pack includes all) ===
    @{ Id = "vscjava.vscode-java-pack"; Name = "Java Extension Pack" }
    
    # === JAVASCRIPT/TYPESCRIPT ===
    @{ Id = "dbaeumer.vscode-eslint"; Name = "ESLint" }
    @{ Id = "esbenp.prettier-vscode"; Name = "Prettier" }
    
    # === REMOTE DEVELOPMENT ===
    @{ Id = "ms-vscode-remote.remote-wsl"; Name = "Remote - WSL" }
    @{ Id = "ms-vscode-remote.remote-ssh"; Name = "Remote - SSH" }
    @{ Id = "ms-vscode-remote.remote-containers"; Name = "Remote - Containers" }
    @{ Id = "ms-vscode.remote-explorer"; Name = "Remote Explorer" }
    
    # === DIAGRAMS & DOCUMENTATION ===
    @{ Id = "hediet.vscode-drawio"; Name = "Draw.io Integration" }
    @{ Id = "bierner.markdown-mermaid"; Name = "Markdown Mermaid" }
    @{ Id = "yzhang.markdown-all-in-one"; Name = "Markdown All in One" }
    
    # === PRODUCTIVITY ===
    @{ Id = "EditorConfig.EditorConfig"; Name = "EditorConfig" }
    @{ Id = "streetsidesoftware.code-spell-checker"; Name = "Code Spell Checker" }
    @{ Id = "ms-vscode.live-server"; Name = "Live Server" }
    @{ Id = "humao.rest-client"; Name = "REST Client" }
    @{ Id = "gruntfuggly.todo-tree"; Name = "Todo Tree" }
    @{ Id = "alefragnani.project-manager"; Name = "Project Manager" }
)

# PowerShell modules
$PSModules = @{
    # === AZURE CORE ===
    AzureCore = @(
        "Az"
        "Az.Accounts"
        "Az.Resources"
        "Az.ResourceGraph"
        "Az.Subscription"
    )
    
    # === AZURE COMPUTE ===
    AzureCompute = @(
        "Az.Compute"
        "Az.Functions"
        "Az.App"
        "Az.ContainerInstance"
        "Az.ContainerRegistry"
        "Az.Aks"
        "Az.Batch"
        "Az.DesktopVirtualization"
        "Az.ImageBuilder"
        "Az.SpringCloud"
    )
    
    # === AZURE NETWORKING ===
    AzureNetworking = @(
        "Az.Network"
        "Az.Dns"
        "Az.PrivateDns"
        "Az.FrontDoor"
        "Az.Cdn"
        "Az.TrafficManager"
    )
    
    # === AZURE STORAGE & DATA ===
    AzureStorageData = @(
        "Az.Storage"
        "Az.Sql"
        "Az.CosmosDB"
        "Az.MySql"
        "Az.PostgreSql"
        "Az.MariaDb"
        "Az.RedisCache"
        "Az.DataFactory"
        "Az.Synapse"
        "Az.Databricks"
        "Az.DataLakeStore"
        "Az.DataShare"
        "Az.Kusto"
        "Az.StreamAnalytics"
        "Az.EventHub"
        "Az.ServiceBus"
        "Az.EventGrid"
        "Az.StorageMover"
    )
    
    # === AZURE SECURITY & IDENTITY ===
    AzureSecurity = @(
        "Az.KeyVault"
        "Az.ManagedServiceIdentity"
        "Az.Security"
        "Az.SecurityInsights"
        "Az.Attestation"
        "Az.ConfidentialLedger"
    )
    
    # === AZURE MANAGEMENT & GOVERNANCE ===
    AzureManagement = @(
        "Az.Monitor"
        "Az.ApplicationInsights"
        "Az.OperationalInsights"
        "Az.Advisor"
        "Az.PolicyInsights"
        "Az.Blueprint"
        "Az.CostManagement"
        "Az.Billing"
        "Az.Maintenance"
        "Az.ResourceMover"
        "Az.Support"
    )
    
    # === AZURE DEVOPS & AUTOMATION ===
    AzureDevOps = @(
        "Az.Automation"
        "Az.LogicApp"
        "Az.DevCenter"
    )
    
    # === AZURE BACKUP & RECOVERY ===
    AzureBackup = @(
        "Az.RecoveryServices"
        "Az.DataProtection"
    )
    
    # === AZURE INTEGRATION ===
    AzureIntegration = @(
        "Az.ApiManagement"
        "Az.SignalR"
        "Az.NotificationHubs"
        "Az.Communication"
        "Az.BotService"
    )
    
    # === AZURE WEB ===
    AzureWeb = @(
        "Az.Websites"
        "Az.StaticWebApp"
    )
    
    # === AZURE AI & ML ===
    AzureAI = @(
        "Az.CognitiveServices"
        "Az.MachineLearning"
        "Az.MachineLearningServices"
    )
    
    # === AZURE IOT ===
    AzureIoT = @(
        "Az.IotHub"
        "Az.IotCentral"
        "Az.TimeSeriesInsights"
    )
    
    # === AZURE HYBRID ===
    AzureHybrid = @(
        "Az.StackHCI"
        "Az.ConnectedMachine"
        "Az.ConnectedKubernetes"
    )
    
    # === M365 & ENTRA ID - Microsoft Graph ===
    MicrosoftGraph = @(
        "Microsoft.Graph"
        "Microsoft.Graph.Authentication"
        "Microsoft.Graph.Users"
        "Microsoft.Graph.Groups"
        "Microsoft.Graph.Identity.DirectoryManagement"
        "Microsoft.Graph.Identity.Governance"
        "Microsoft.Graph.Identity.SignIns"
        "Microsoft.Graph.Applications"
        "Microsoft.Graph.DeviceManagement"
        "Microsoft.Graph.DeviceManagement.Enrollment"
        "Microsoft.Graph.DeviceManagement.Actions"
        "Microsoft.Graph.DeviceManagement.Administration"
        "Microsoft.Graph.Devices.CorporateManagement"
        "Microsoft.Graph.Security"
        "Microsoft.Graph.Compliance"
        "Microsoft.Graph.Reports"
        "Microsoft.Graph.Mail"
        "Microsoft.Graph.Calendar"
        "Microsoft.Graph.Files"
        "Microsoft.Graph.Sites"
        "Microsoft.Graph.Teams"
        "Microsoft.Graph.Planner"
        "Microsoft.Graph.Notes"
        "Microsoft.Graph.People"
        "Microsoft.Graph.PersonalContacts"
        "Microsoft.Graph.Bookings"
        "Microsoft.Graph.SchemaExtensions"
        "Microsoft.Graph.DirectoryObjects"
        "Microsoft.Graph.CloudCommunications"
        "Microsoft.Graph.CrossDeviceExperiences"
    )
    
    # === M365 - Legacy Entra ID ===
    EntraIDLegacy = @(
        "AzureAD"
        "AzureADPreview"
        "MSOnline"
    )
    
    # === M365 - Exchange Online ===
    ExchangeOnline = @(
        "ExchangeOnlineManagement"
    )
    
    # === M365 - Teams ===
    Teams = @(
        "MicrosoftTeams"
    )
    
    # === M365 - SharePoint ===
    SharePoint = @(
        "Microsoft.Online.SharePoint.PowerShell"
        "PnP.PowerShell"
    )
    
    # === M365 - Power Platform ===
    PowerPlatform = @(
        "Microsoft.PowerApps.Administration.PowerShell"
        "Microsoft.PowerApps.PowerShell"
    )
    
    # === M365 - Helper ===
    M365Helper = @(
        "MSAL.PS"
        "MSIdentityTools"
    )
    
    # === AWS ===
    AWS = @(
        "AWS.Tools.Installer"
        "AWS.Tools.Common"
        "AWS.Tools.EC2"
        "AWS.Tools.AutoScaling"
        "AWS.Tools.Lambda"
        "AWS.Tools.ECS"
        "AWS.Tools.EKS"
        "AWS.Tools.ECR"
        "AWS.Tools.Batch"
        "AWS.Tools.Lightsail"
        "AWS.Tools.ElasticBeanstalk"
        "AWS.Tools.AppRunner"
        "AWS.Tools.ElasticLoadBalancingV2"
        "AWS.Tools.Route53"
        "AWS.Tools.Route53Domains"
        "AWS.Tools.CloudFront"
        "AWS.Tools.DirectConnect"
        "AWS.Tools.GlobalAccelerator"
        "AWS.Tools.APIGateway"
        "AWS.Tools.VPCLattice"
        "AWS.Tools.S3"
        "AWS.Tools.EFS"
        "AWS.Tools.FSx"
        "AWS.Tools.StorageGateway"
        "AWS.Tools.Backup"
        "AWS.Tools.Glacier"
        "AWS.Tools.RDS"
        "AWS.Tools.DynamoDBv2"
        "AWS.Tools.ElastiCache"
        "AWS.Tools.Redshift"
        "AWS.Tools.Neptune"
        "AWS.Tools.DocumentDB"
        "AWS.Tools.MemoryDB"
        "AWS.Tools.Keyspaces"
        "AWS.Tools.Timestream"
        "AWS.Tools.IAM"
        "AWS.Tools.IdentityStore"
        "AWS.Tools.SSOAdmin"
        "AWS.Tools.SSO"
        "AWS.Tools.SSOOIDC"
        "AWS.Tools.SecretsManager"
        "AWS.Tools.KMS"
        "AWS.Tools.CertificateManager"
        "AWS.Tools.WAF"
        "AWS.Tools.WAFV2"
        "AWS.Tools.Shield"
        "AWS.Tools.SecurityHub"
        "AWS.Tools.GuardDuty"
        "AWS.Tools.Inspector2"
        "AWS.Tools.Macie2"
        "AWS.Tools.Detective"
        "AWS.Tools.CloudWatch"
        "AWS.Tools.CloudWatchLogs"
        "AWS.Tools.CloudTrail"
        "AWS.Tools.Config"
        "AWS.Tools.Organizations"
        "AWS.Tools.ControlTower"
        "AWS.Tools.ServiceCatalog"
        "AWS.Tools.SSM"
        "AWS.Tools.ResourceGroups"
        "AWS.Tools.ResourceGroupsTaggingAPI"
        "AWS.Tools.CostExplorer"
        "AWS.Tools.Budgets"
        "AWS.Tools.TrustedAdvisor"
        "AWS.Tools.CodeCommit"
        "AWS.Tools.CodeBuild"
        "AWS.Tools.CodeDeploy"
        "AWS.Tools.CodePipeline"
        "AWS.Tools.CodeArtifact"
        "AWS.Tools.CloudFormation"
        "AWS.Tools.ServiceQuotas"
        "AWS.Tools.SNS"
        "AWS.Tools.SQS"
        "AWS.Tools.EventBridge"
        "AWS.Tools.StepFunctions"
        "AWS.Tools.AppSync"
        "AWS.Tools.Athena"
        "AWS.Tools.Glue"
        "AWS.Tools.EMR"
        "AWS.Tools.Kinesis"
        "AWS.Tools.KinesisFirehose"
        "AWS.Tools.QuickSight"
        "AWS.Tools.DataPipeline"
        "AWS.Tools.LakeFormation"
        "AWS.Tools.OpenSearchService"
        "AWS.Tools.SageMaker"
        "AWS.Tools.Rekognition"
        "AWS.Tools.Comprehend"
        "AWS.Tools.Polly"
        "AWS.Tools.Translate"
        "AWS.Tools.Lex"
        "AWS.Tools.Textract"
        "AWS.Tools.Bedrock"
    )
    
    # === DEVOPS & UTILITY ===
    DevOpsUtility = @(
        "Pester"
        "PSReadLine"
        "Terminal-Icons"
        "posh-git"
        "PSScriptAnalyzer"
        "ImportExcel"
        "PSGraph"
        "Plaster"
        "SecretManagement"
        "SecretStore"
        "Az.KeyVault.SecretManagement"
        "powershell-yaml"
        "Posh-SSH"
    )
}

# === FUNCTIONS ===

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    switch ($Type) {
        "Success" { Write-Host "[OK] $Message" -ForegroundColor Green }
        "Error"   { Write-Host "[ERROR] $Message" -ForegroundColor Red }
        "Warning" { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
        "Info"    { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
        "Header"  { Write-Host "`n$("=" * 60)`n$Message`n$("=" * 60)" -ForegroundColor Magenta }
        "Installed" { Write-Host "[INSTALLED] $Message" -ForegroundColor DarkGreen }
    }
}

function Test-WingetInstalled {
    try {
        $null = Get-Command winget -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Get-WingetAppInfo {
    param([string]$AppId)
    
    try {
        $result = winget list --id $AppId --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0 -and $result) {
            # Parse output to get version
            $lines = $result -split "`n" | Where-Object { $_ -match $AppId }
            if ($lines) {
                # Try to extract version from the line
                $line = $lines | Select-Object -First 1
                # Winget output format: Name  Id  Version  Available  Source
                $parts = $line -split '\s{2,}'
                if ($parts.Count -ge 3) {
                    $version = $parts[-3] # Version is usually 3rd from end
                    if ($version -match '^\d') {
                        return @{
                            Installed = $true
                            Version = $version.Trim()
                        }
                    }
                }
                return @{
                    Installed = $true
                    Version = "Unknown"
                }
            }
        }
    }
    catch { }
    
    return @{
        Installed = $false
        Version = $null
    }
}

function Get-VSCodeExtensionInfo {
    param([string]$ExtensionId)
    
    try {
        $extensions = code --list-extensions --show-versions 2>$null
        if ($extensions) {
            $match = $extensions | Where-Object { $_ -like "$ExtensionId@*" }
            if ($match) {
                $version = ($match -split '@')[1]
                return @{
                    Installed = $true
                    Version = $version
                }
            }
        }
    }
    catch { }
    
    return @{
        Installed = $false
        Version = $null
    }
}

function Get-PipPackageInfo {
    param([string]$PackageName)
    
    try {
        $result = pip show $PackageName 2>$null
        if ($LASTEXITCODE -eq 0 -and $result) {
            $versionLine = $result | Where-Object { $_ -match '^Version:' }
            if ($versionLine) {
                $version = ($versionLine -split ':\s*')[1]
                return @{
                    Installed = $true
                    Version = $version
                }
            }
        }
    }
    catch { }
    
    return @{
        Installed = $false
        Version = $null
    }
}

function Get-NpmPackageInfo {
    param([string]$PackageName)
    
    try {
        $result = npm list -g $PackageName --depth=0 2>$null
        if ($result -match "$PackageName@([\d\.]+)") {
            return @{
                Installed = $true
                Version = $matches[1]
            }
        }
    }
    catch { }
    
    return @{
        Installed = $false
        Version = $null
    }
}

function Get-GoPackageInfo {
    param([string]$PackageName)
    
    # Extract binary name from package path
    $binaryName = ($PackageName -split '/')[-1] -replace '@.*$', ''
    
    try {
        $goPath = Join-Path $env:GOPATH "bin\$binaryName.exe"
        if (-not $env:GOPATH) {
            $goPath = Join-Path $env:USERPROFILE "go\bin\$binaryName.exe"
        }
        
        if (Test-Path $goPath) {
            # Try to get version
            $versionOutput = & $goPath --version 2>$null
            if ($versionOutput -match '(\d+\.\d+\.\d+)') {
                return @{
                    Installed = $true
                    Version = $matches[1]
                }
            }
            return @{
                Installed = $true
                Version = "Installed"
            }
        }
    }
    catch { }
    
    return @{
        Installed = $false
        Version = $null
    }
}

function Get-PSModuleInfo {
    param([string]$ModuleName)
    
    try {
        $module = Get-Module -ListAvailable -Name $ModuleName -ErrorAction SilentlyContinue | 
                  Sort-Object Version -Descending | 
                  Select-Object -First 1
        
        if ($module) {
            return @{
                Installed = $true
                Version = $module.Version.ToString()
            }
        }
    }
    catch { }
    
    return @{
        Installed = $false
        Version = $null
    }
}

function Get-UserConfirmation {
    param(
        [string]$Message,
        [bool]$DefaultYes = $true
    )
    
    if ($AutoYes) {
        return $true
    }
    
    $prompt = if ($DefaultYes) { "$Message [Y/n]" } else { "$Message [y/N]" }
    $response = Read-Host $prompt
    
    if ([string]::IsNullOrWhiteSpace($response)) {
        return $DefaultYes
    }
    
    return $response -match '^[yY]'
}

function Install-WingetApp {
    param(
        [string]$AppId,
        [string]$AppName
    )
    
    # Check if already installed
    $appInfo = Get-WingetAppInfo -AppId $AppId
    
    if ($WhatIf) {
        if ($appInfo.Installed) {
            Write-ColorOutput "$AppName v$($appInfo.Version) - already installed" "Installed"
        }
        Write-ColorOutput "WHATIF: Would install $AppName ($AppId)" "Warning"
        return $true
    }
    
    # Show status and ask for confirmation
    if ($appInfo.Installed) {
        Write-Host "[INSTALLED] " -ForegroundColor DarkGreen -NoNewline
        Write-Host "$AppName " -ForegroundColor White -NoNewline
        Write-Host "v$($appInfo.Version)" -ForegroundColor Gray
        
        $confirm = Get-UserConfirmation -Message "  Already installed. Reinstall/Update $AppName ?" -DefaultYes $false
        if (-not $confirm) {
            return $true
        }
    }
    else {
        Write-Host "[NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
        Write-Host "$AppName" -ForegroundColor White
        
        $confirm = Get-UserConfirmation -Message "  Install $AppName ?" -DefaultYes $true
        if (-not $confirm) {
            Write-ColorOutput "Skipping $AppName (user selected No)" "Warning"
            return $false
        }
    }
    
    # Check if already installed - use upgrade instead of install
    $isUpgrade = $appInfo.Installed
    
    if ($isUpgrade) {
        Write-ColorOutput "Upgrading $AppName..." "Info"
    }
    else {
        Write-ColorOutput "Installing $AppName..." "Info"
    }
    
    try {
        if ($isUpgrade) {
            # Use upgrade for already installed apps
            winget upgrade --id $AppId --accept-source-agreements --accept-package-agreements --silent 2>$null
        }
        else {
            # Use install for new apps
            winget install --id $AppId --accept-source-agreements --accept-package-agreements --silent
        }
        
        # Check exit codes
        # 0 = Success
        # -1978335189 = Already installed/no update available (not an error)
        # -1978335212 = No applicable installer found
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "$AppName successfully installed/upgraded" "Success"
            return $true
        }
        elseif ($LASTEXITCODE -eq -1978335189) {
            Write-ColorOutput "$AppName is already up to date" "Success"
            return $true
        }
        elseif ($LASTEXITCODE -eq -1978335212) {
            Write-ColorOutput "$AppName - no applicable installer found (check package ID or architecture)" "Warning"
            return $false
        }
        else {
            Write-ColorOutput "Error installing $AppName (code: $LASTEXITCODE)" "Error"
            return $false
        }
    }
    catch {
        Write-ColorOutput "Exception installing $AppName : $_" "Error"
        return $false
    }
}

function Install-VSCodeExtension {
    param(
        [string]$ExtensionId,
        [string]$ExtensionName
    )
    
    # Check if already installed
    $extInfo = Get-VSCodeExtensionInfo -ExtensionId $ExtensionId
    
    if ($WhatIf) {
        if ($extInfo.Installed) {
            Write-Host "    [INSTALLED] $ExtensionName v$($extInfo.Version)" -ForegroundColor DarkGreen
        }
        Write-Host "    WHATIF: Would install $ExtensionName" -ForegroundColor Yellow
        return
    }
    
    # Show status and ask for confirmation
    if ($extInfo.Installed) {
        Write-Host "    [INSTALLED] " -ForegroundColor DarkGreen -NoNewline
        Write-Host "$ExtensionName " -ForegroundColor White -NoNewline
        Write-Host "v$($extInfo.Version)" -ForegroundColor Gray
        
        $confirm = Get-UserConfirmation -Message "      Already installed. Update $ExtensionName ?" -DefaultYes $false
        if (-not $confirm) {
            return
        }
    }
    else {
        Write-Host "    [NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
        Write-Host "$ExtensionName" -ForegroundColor White
        
        $confirm = Get-UserConfirmation -Message "      Install $ExtensionName ?" -DefaultYes $true
        if (-not $confirm) {
            return
        }
    }
    
    Write-Host "    Installing: $ExtensionName..." -ForegroundColor Gray
    
    try {
        $output = code --install-extension $ExtensionId --force 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] $ExtensionName installed" -ForegroundColor Green
        }
        else {
            Write-Host "    [WARN] $ExtensionName - may already exist" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "    [ERROR] $ExtensionName" -ForegroundColor Red
    }
}

function Test-VSCodeAvailable {
    # Refresh PATH
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:PATH = $machinePath + ";" + $userPath
    
    # Add typical VS Code paths
    $vscodePaths = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin")
        (Join-Path $env:ProgramFiles "Microsoft VS Code\bin")
    )
    
    foreach ($path in $vscodePaths) {
        if ((Test-Path $path) -and ($env:PATH -notlike "*$path*")) {
            $env:PATH = $env:PATH + ";" + $path
        }
    }
    
    return (Get-Command code -ErrorAction SilentlyContinue) -ne $null
}

function Install-AllVSCodeExtensions {
    Write-ColorOutput "VS CODE EXTENSIONS" "Header"
    
    if (-not (Test-VSCodeAvailable)) {
        Write-ColorOutput "VS Code is not available. Skipping extension installation." "Warning"
        Write-Host "`nTo manually install extensions later, run:" -ForegroundColor Yellow
        Write-Host '  $extensions = @("ms-vscode.powershell","ms-azuretools.vscode-bicep","hashicorp.terraform")' -ForegroundColor Gray
        Write-Host '  foreach ($ext in $extensions) { code --install-extension $ext --force }' -ForegroundColor Gray
        return
    }
    
    # Get VS Code version
    $vscodeVersion = code --version 2>$null | Select-Object -First 1
    Write-ColorOutput "VS Code found (v$vscodeVersion), checking extensions..." "Success"
    
    # Group extensions by category
    $categories = @{
        "PowerShell" = $VSCodeExtensions | Where-Object { $_.Id -like "*powershell*" }
        "Azure" = $VSCodeExtensions | Where-Object { $_.Id -like "*azure*" -or $_.Id -like "*bicep*" }
        "AWS" = $VSCodeExtensions | Where-Object { $_.Id -like "*aws*" -or $_.Id -like "*cfn*" -or $_.Id -like "*cloudformation*" }
        "Google Cloud" = $VSCodeExtensions | Where-Object { $_.Id -like "*google*" -or $_.Id -like "*cloudcode*" }
        "Terraform & IaC" = $VSCodeExtensions | Where-Object { $_.Id -like "*terraform*" -or $_.Id -like "*hcl*" -or $_.Id -like "*infracost*" }
        "Kubernetes & Docker" = $VSCodeExtensions | Where-Object { $_.Id -like "*kubernetes*" -or $_.Id -like "*docker*" -or $_.Id -like "*yaml*" -or $_.Id -like "*gitops*" -or $_.Id -like "*mindaro*" -or $_.Id -like "*aks*" }
        "Git & GitHub" = $VSCodeExtensions | Where-Object { $_.Id -like "*git*" -or $_.Id -like "*github*" }
        "Python" = $VSCodeExtensions | Where-Object { $_.Id -like "*python*" -or $_.Id -like "*pylance*" -or $_.Id -like "*black*" }
        "Java" = $VSCodeExtensions | Where-Object { $_.Id -like "*java*" }
        "JavaScript/TypeScript" = $VSCodeExtensions | Where-Object { $_.Id -like "*eslint*" -or $_.Id -like "*prettier*" }
        "Remote Development" = $VSCodeExtensions | Where-Object { $_.Id -like "*remote*" }
        "Diagrams & Docs" = $VSCodeExtensions | Where-Object { $_.Id -like "*drawio*" -or $_.Id -like "*mermaid*" -or $_.Id -like "*markdown*" }
        "Productivity" = $VSCodeExtensions | Where-Object { $_.Id -like "*editor*" -or $_.Id -like "*spell*" -or $_.Id -like "*live-server*" -or $_.Id -like "*rest-client*" -or $_.Id -like "*todo*" -or $_.Id -like "*project-manager*" }
    }
    
    foreach ($category in $categories.GetEnumerator()) {
        if ($category.Value.Count -eq 0) { continue }
        
        # Count installed vs not installed
        $installedCount = 0
        foreach ($ext in $category.Value) {
            $info = Get-VSCodeExtensionInfo -ExtensionId $ext.Id
            if ($info.Installed) { $installedCount++ }
        }
        
        Write-Host "`n--- $($category.Key) ---" -ForegroundColor Cyan
        Write-Host "    ($installedCount/$($category.Value.Count) already installed)" -ForegroundColor Gray
        
        $installCategory = Get-UserConfirmation -Message "Process $($category.Key) extensions?" -DefaultYes $true
        
        if (-not $installCategory) {
            Write-Host "  [SKIP] Skipping $($category.Key) category" -ForegroundColor Yellow
            continue
        }
        
        foreach ($ext in $category.Value) {
            Install-VSCodeExtension -ExtensionId $ext.Id -ExtensionName $ext.Name
        }
    }
    
    Write-ColorOutput "VS Code extension processing completed" "Success"
}

function Install-IaCTools {
    Write-ColorOutput "IAC TOOLS (pip, npm, go, binary)" "Header"
    
    # --- Pip tools ---
    $pipTools = @(
        @{ Name = "pre-commit";     Desc = "Git hooks framework" }
        @{ Name = "detect-secrets"; Desc = "Secret detection" }
        @{ Name = "cfn-lint";       Desc = "CloudFormation linter" }
        @{ Name = "diagrams";       Desc = "Infrastructure diagrams" }
    )
    
    $pipAvailable = Get-Command pip -ErrorAction SilentlyContinue
    
    if ($pipAvailable) {
        Write-Host "`n--- pip tools ---" -ForegroundColor Cyan
        foreach ($tool in $pipTools) {
            $pkgInfo = Get-PipPackageInfo -PackageName $tool.Name
            
            if ($WhatIf) {
                if ($pkgInfo.Installed) {
                    Write-Host "[INSTALLED] $($tool.Name) v$($pkgInfo.Version)" -ForegroundColor DarkGreen
                }
                Write-ColorOutput "WHATIF: pip install $($tool.Name)" "Warning"
                continue
            }
            
            if ($pkgInfo.Installed) {
                Write-Host "[INSTALLED] " -ForegroundColor DarkGreen -NoNewline
                Write-Host "$($tool.Name) " -ForegroundColor White -NoNewline
                Write-Host "v$($pkgInfo.Version)" -ForegroundColor Gray
                
                $confirm = Get-UserConfirmation -Message "  Already installed. Update $($tool.Name)?" -DefaultYes $false
                if (-not $confirm) { continue }
            }
            else {
                Write-Host "[NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
                Write-Host "$($tool.Name) ($($tool.Desc))" -ForegroundColor White
                
                $confirm = Get-UserConfirmation -Message "  Install $($tool.Name)?" -DefaultYes $true
                if (-not $confirm) { continue }
            }
            
            Write-ColorOutput "Installing $($tool.Name)..." "Info"
            try {
                pip install $tool.Name --upgrade --quiet --user 2>$null
                Write-ColorOutput "$($tool.Name) installed" "Success"
            }
            catch {
                Write-ColorOutput "Error installing $($tool.Name)" "Error"
            }
        }
    }
    else {
        Write-ColorOutput "pip is not available, skipping pip tools" "Warning"
    }
    
    # --- npm tools ---
    $npmAvailable = Get-Command npm -ErrorAction SilentlyContinue
    
    if ($npmAvailable) {
        Write-Host "`n--- npm tools ---" -ForegroundColor Cyan
        $npmTools = @(
            @{ Name = "aws-cdk";     Desc = "AWS CDK" }
            @{ Name = "cdktf-cli";   Desc = "Terraform CDK" }
        )
        
        foreach ($tool in $npmTools) {
            $pkgInfo = Get-NpmPackageInfo -PackageName $tool.Name
            
            if ($WhatIf) {
                if ($pkgInfo.Installed) {
                    Write-Host "[INSTALLED] $($tool.Name) v$($pkgInfo.Version)" -ForegroundColor DarkGreen
                }
                Write-ColorOutput "WHATIF: npm install -g $($tool.Name)" "Warning"
                continue
            }
            
            if ($pkgInfo.Installed) {
                Write-Host "[INSTALLED] " -ForegroundColor DarkGreen -NoNewline
                Write-Host "$($tool.Name) " -ForegroundColor White -NoNewline
                Write-Host "v$($pkgInfo.Version)" -ForegroundColor Gray
                
                $confirm = Get-UserConfirmation -Message "  Already installed. Update $($tool.Name)?" -DefaultYes $false
                if (-not $confirm) { continue }
            }
            else {
                Write-Host "[NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
                Write-Host "$($tool.Name) ($($tool.Desc))" -ForegroundColor White
                
                $confirm = Get-UserConfirmation -Message "  Install $($tool.Name)?" -DefaultYes $true
                if (-not $confirm) { continue }
            }
            
            Write-ColorOutput "Installing $($tool.Name)..." "Info"
            try {
                npm install -g $tool.Name 2>$null
                Write-ColorOutput "$($tool.Name) installed" "Success"
            }
            catch {
                Write-ColorOutput "Error installing $($tool.Name)" "Error"
            }
        }
    }
    else {
        Write-ColorOutput "npm is not available, skipping npm tools" "Warning"
    }
    
    # --- Go tools ---
    $goAvailable = Get-Command go -ErrorAction SilentlyContinue
    
    if ($goAvailable) {
        Write-Host "`n--- Go tools ---" -ForegroundColor Cyan
        $goTools = @(
            @{ Pkg = "github.com/GoogleCloudPlatform/terraformer@latest"; Name = "terraformer"; Desc = "Import existing infrastructure" }
            @{ Pkg = "github.com/terraform-linters/tflint@latest";        Name = "tflint"; Desc = "Terraform linter" }
            @{ Pkg = "github.com/cloudskiff/driftctl@latest";             Name = "driftctl"; Desc = "Drift detection" }
            @{ Pkg = "github.com/minamijoyo/tfmigrate@latest";            Name = "tfmigrate"; Desc = "Terraform state migration" }
            @{ Pkg = "sigs.k8s.io/kustomize/kustomize/v5@latest";         Name = "kustomize"; Desc = "Kubernetes customization" }
        )
        
        foreach ($tool in $goTools) {
            $pkgInfo = Get-GoPackageInfo -PackageName $tool.Pkg
            
            if ($WhatIf) {
                if ($pkgInfo.Installed) {
                    Write-Host "[INSTALLED] $($tool.Name) v$($pkgInfo.Version)" -ForegroundColor DarkGreen
                }
                Write-ColorOutput "WHATIF: go install $($tool.Pkg)" "Warning"
                continue
            }
            
            if ($pkgInfo.Installed) {
                Write-Host "[INSTALLED] " -ForegroundColor DarkGreen -NoNewline
                Write-Host "$($tool.Name) " -ForegroundColor White -NoNewline
                Write-Host "v$($pkgInfo.Version)" -ForegroundColor Gray
                
                $confirm = Get-UserConfirmation -Message "  Already installed. Update $($tool.Name)?" -DefaultYes $false
                if (-not $confirm) { continue }
            }
            else {
                Write-Host "[NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
                Write-Host "$($tool.Name) ($($tool.Desc))" -ForegroundColor White
                
                $confirm = Get-UserConfirmation -Message "  Install $($tool.Name)?" -DefaultYes $true
                if (-not $confirm) { continue }
            }
            
            Write-ColorOutput "Installing $($tool.Name) via go install..." "Info"
            try {
                go install $tool.Pkg 2>$null
                Write-ColorOutput "$($tool.Name) installed" "Success"
            }
            catch {
                Write-ColorOutput "Error installing $($tool.Name)" "Error"
            }
        }
    }
    else {
        Write-ColorOutput "Go is not available, skipping Go tools" "Warning"
    }
    
    # --- Binary downloads ---
    Write-Host "`n--- Binary downloads ---" -ForegroundColor Cyan
    
    # Terragrunt
    $tgPath = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages\terragrunt.exe"
    $tgInstalled = Test-Path $tgPath
    
    if ($tgInstalled) {
        $tgVersion = "Unknown"
        try {
            $vOut = & $tgPath --version 2>$null
            if ($vOut -match '(\d+\.\d+\.\d+)') { $tgVersion = $matches[1] }
        } catch {}
        
        Write-Host "[INSTALLED] " -ForegroundColor DarkGreen -NoNewline
        Write-Host "Terragrunt " -ForegroundColor White -NoNewline
        Write-Host "v$tgVersion" -ForegroundColor Gray
        
        if (-not $WhatIf) {
            $confirm = Get-UserConfirmation -Message "  Already installed. Update Terragrunt?" -DefaultYes $false
            if (-not $confirm) { $tgInstalled = $true }
            else { $tgInstalled = $false }
        }
    }
    else {
        Write-Host "[NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
        Write-Host "Terragrunt (Terraform wrapper)" -ForegroundColor White
    }
    
    if (-not $tgInstalled -and -not $WhatIf) {
        $confirm = Get-UserConfirmation -Message "  Download Terragrunt?" -DefaultYes $true
        if ($confirm) {
            Write-ColorOutput "Downloading Terragrunt..." "Info"
            try {
                $tgVersion = (Invoke-RestMethod "https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest").tag_name
                $tgUrl = "https://github.com/gruntwork-io/terragrunt/releases/download/$tgVersion/terragrunt_windows_amd64.exe"
                Invoke-WebRequest -Uri $tgUrl -OutFile $tgPath -UseBasicParsing
                Write-ColorOutput "Terragrunt $tgVersion downloaded" "Success"
            }
            catch {
                Write-ColorOutput "Error downloading Terragrunt: $_" "Error"
            }
        }
    }
    
    # Infracost
    $icFolder = Join-Path $env:LOCALAPPDATA "infracost"
    $icPath = Join-Path $icFolder "infracost.exe"
    $icInstalled = Test-Path $icPath
    
    if ($icInstalled) {
        $icVersion = "Unknown"
        try {
            $vOut = & $icPath --version 2>$null
            if ($vOut -match '(\d+\.\d+\.\d+)') { $icVersion = $matches[1] }
        } catch {}
        
        Write-Host "[INSTALLED] " -ForegroundColor DarkGreen -NoNewline
        Write-Host "Infracost " -ForegroundColor White -NoNewline
        Write-Host "v$icVersion" -ForegroundColor Gray
        
        if (-not $WhatIf) {
            $confirm = Get-UserConfirmation -Message "  Already installed. Update Infracost?" -DefaultYes $false
            if (-not $confirm) { $icInstalled = $true }
            else { $icInstalled = $false }
        }
    }
    else {
        Write-Host "[NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
        Write-Host "Infracost (Cloud cost estimation)" -ForegroundColor White
    }
    
    if (-not $icInstalled -and -not $WhatIf) {
        $confirm = Get-UserConfirmation -Message "  Download Infracost?" -DefaultYes $true
        if ($confirm) {
            Write-ColorOutput "Installing Infracost..." "Info"
            try {
                if (-not (Test-Path $icFolder)) {
                    New-Item -ItemType Directory -Path $icFolder -Force | Out-Null
                }
                $icVersion = (Invoke-RestMethod "https://api.github.com/repos/infracost/infracost/releases/latest").tag_name
                $icUrl = "https://github.com/infracost/infracost/releases/download/$icVersion/infracost-windows-amd64.exe"
                Invoke-WebRequest -Uri $icUrl -OutFile $icPath -UseBasicParsing
                Write-ColorOutput "Infracost $icVersion downloaded" "Success"
                $env:PATH = $env:PATH + ";" + $icFolder
            }
            catch {
                Write-ColorOutput "Error installing Infracost: $_" "Error"
            }
        }
    }
}

function Install-PowerShellModules {
    Write-ColorOutput "POWERSHELL MODULES" "Header"
    
    Write-Host "`nSelect module categories to install:" -ForegroundColor White
    
    $categories = @(
        @{ Key = "AzureCore";       Name = "Azure - Core modules"; Default = $true }
        @{ Key = "AzureCompute";    Name = "Azure - Compute"; Default = $true }
        @{ Key = "AzureNetworking"; Name = "Azure - Networking"; Default = $true }
        @{ Key = "AzureStorageData"; Name = "Azure - Storage & Data"; Default = $true }
        @{ Key = "AzureSecurity";   Name = "Azure - Security & Identity"; Default = $true }
        @{ Key = "AzureManagement"; Name = "Azure - Management & Governance"; Default = $true }
        @{ Key = "AzureDevOps";     Name = "Azure - DevOps & Automation"; Default = $true }
        @{ Key = "AzureBackup";     Name = "Azure - Backup & Recovery"; Default = $true }
        @{ Key = "AzureIntegration"; Name = "Azure - Integration"; Default = $false }
        @{ Key = "AzureWeb";        Name = "Azure - Web Apps"; Default = $true }
        @{ Key = "AzureAI";         Name = "Azure - AI & ML"; Default = $false }
        @{ Key = "AzureIoT";        Name = "Azure - IoT"; Default = $false }
        @{ Key = "AzureHybrid";     Name = "Azure - Hybrid (Arc)"; Default = $false }
        @{ Key = "MicrosoftGraph";  Name = "M365 - Microsoft Graph (complete)"; Default = $true }
        @{ Key = "EntraIDLegacy";   Name = "M365 - Entra ID Legacy (AzureAD)"; Default = $false }
        @{ Key = "ExchangeOnline";  Name = "M365 - Exchange Online"; Default = $true }
        @{ Key = "Teams";           Name = "M365 - Teams"; Default = $true }
        @{ Key = "SharePoint";      Name = "M365 - SharePoint & PnP"; Default = $true }
        @{ Key = "PowerPlatform";   Name = "M365 - Power Platform"; Default = $false }
        @{ Key = "M365Helper";      Name = "M365 - Helper modules (MSAL)"; Default = $true }
        @{ Key = "AWS";             Name = "AWS - Complete module set"; Default = $true }
        @{ Key = "DevOpsUtility";   Name = "DevOps & Utility modules"; Default = $true }
    )
    
    $selectedCategories = @()
    
    foreach ($cat in $categories) {
        # Count installed modules in category
        $modules = $PSModules[$cat.Key]
        $installedCount = 0
        if ($modules) {
            foreach ($mod in $modules) {
                $modInfo = Get-PSModuleInfo -ModuleName $mod
                if ($modInfo.Installed) { $installedCount++ }
            }
        }
        
        if ($WhatIf -or $AutoYes) {
            $selectedCategories += $cat.Key
            continue
        }
        
        $defaultText = if ($cat.Default) { "[Y/n]" } else { "[y/N]" }
        $countText = "($installedCount/$($modules.Count) installed)"
        $response = Read-Host "  $($cat.Name) $countText $defaultText"
        
        $selected = if ([string]::IsNullOrWhiteSpace($response)) {
            $cat.Default
        } else {
            $response -match '^[yY]'
        }
        
        if ($selected) {
            $selectedCategories += $cat.Key
        }
    }
    
    Write-Host ""
    
    # Install selected categories
    $totalModules = 0
    $installedModules = 0
    $skippedModules = 0
    
    foreach ($catKey in $selectedCategories) {
        $modules = $PSModules[$catKey]
        if ($null -eq $modules) { continue }
        
        Write-ColorOutput "Category: $catKey" "Info"
        
        foreach ($module in $modules) {
            $totalModules++
            $modInfo = Get-PSModuleInfo -ModuleName $module
            
            if ($WhatIf) {
                if ($modInfo.Installed) {
                    Write-Host "  [INSTALLED] $module v$($modInfo.Version)" -ForegroundColor DarkGreen
                }
                else {
                    Write-Host "  WHATIF: Would install module $module" -ForegroundColor Yellow
                }
                continue
            }
            
            if ($modInfo.Installed) {
                Write-Host "  [INSTALLED] " -ForegroundColor DarkGreen -NoNewline
                Write-Host "$module " -ForegroundColor White -NoNewline
                Write-Host "v$($modInfo.Version)" -ForegroundColor Gray
                $installedModules++
                
                if (-not $AutoYes) {
                    $confirm = Get-UserConfirmation -Message "    Update $module ?" -DefaultYes $false
                    if (-not $confirm) { 
                        $skippedModules++
                        continue 
                    }
                }
                else {
                    $skippedModules++
                    continue
                }
            }
            else {
                Write-Host "  [NOT INSTALLED] " -ForegroundColor Yellow -NoNewline
                Write-Host "$module" -ForegroundColor White
                
                if (-not $AutoYes) {
                    $confirm = Get-UserConfirmation -Message "    Install $module ?" -DefaultYes $true
                    if (-not $confirm) { 
                        $skippedModules++
                        continue 
                    }
                }
            }
            
            Write-Host "    Installing $module..." -ForegroundColor Gray
            try {
                Install-Module -Name $module -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck -ErrorAction Stop
                Write-Host "    [OK] $module" -ForegroundColor Green
                $installedModules++
            }
            catch {
                Write-Host "    [ERROR] $module - $_" -ForegroundColor Red
            }
        }
    }
    
    Write-ColorOutput "Modules: $installedModules installed, $skippedModules skipped, $totalModules total" "Success"
}

function Show-Summary {
    Write-ColorOutput "INSTALLATION SUMMARY" "Header"
    
    Write-Host "`nNext steps:" -ForegroundColor White
    Write-Host "1. Restart terminal to load new PATH variables"
    Write-Host "2. Run 'docker --version' to verify Docker installation"
    Write-Host "3. Run 'az login' to sign in to Azure"
    Write-Host "4. Run 'aws configure' to configure AWS"
    Write-Host "5. Run 'gcloud init' to configure Google Cloud"
    Write-Host "6. Run 'Connect-MgGraph' to sign in to Microsoft Graph"
    Write-Host "7. Set WSL2 as backend for Docker Desktop"
    
    Write-Host "`nIaC tools - usage examples:" -ForegroundColor Cyan
    Write-Host "- aztfexport: aztfexport resource-group [rg-name]"
    Write-Host "- terraformer: terraformer import azure --resources=*"
    Write-Host "- checkov: checkov -d ./terraform"
    Write-Host "- tflint: tflint --init; tflint"
    Write-Host "- infracost: infracost breakdown --path=."
    Write-Host "- cfn-lint: cfn-lint template.yaml"
    
    Write-Host "`nRecommended additional steps:" -ForegroundColor Yellow
    Write-Host "- Install WSL2: wsl --install"
    Write-Host "- Configure Git: git config --global user.name 'Your Name'"
    Write-Host "- Configure Git: git config --global user.email 'your@email.com'"
    Write-Host "- Infracost API key: infracost auth login"
    Write-Host "- Pre-commit hooks: pre-commit install"
    Write-Host "- gcloud components: gcloud components install kubectl gke-gcloud-auth-plugin"
}

# === MAIN PROGRAM ===

Write-ColorOutput "DEVOPS TOOLS INSTALLER v4.0" "Header"
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "Computer: $env:COMPUTERNAME"
Write-Host "User: $env:USERNAME"

if ($AutoYes) {
    Write-ColorOutput "Running in AutoYes mode - all prompts will be automatically accepted" "Warning"
}

if ($WhatIf) {
    Write-ColorOutput "Running in WhatIf mode - no changes will be made" "Warning"
}

# Check winget
if (-not (Test-WingetInstalled)) {
    Write-ColorOutput "Winget is not installed! Install App Installer from Microsoft Store." "Error"
    exit 1
}

Write-ColorOutput "Winget found" "Success"

# Track if VS Code was installed
$vsCodeInstalled = $false

# Install winget applications
if (-not $SkipWingetApps) {
    Write-ColorOutput "WINGET APPLICATIONS" "Header"
    Write-Host "Checking installed applications...`n" -ForegroundColor Gray
    
    foreach ($app in $WingetApps) {
        $result = Install-WingetApp -AppId $app.Id -AppName $app.Name
        
        # Remember if VS Code was installed
        if ($app.Id -eq "Microsoft.VisualStudioCode" -and $result) {
            $vsCodeInstalled = $true
        }
    }
}

# Install IaC tools
if (-not $SkipIaCTools) {
    Install-IaCTools
}

# Install PowerShell modules
if (-not $SkipPSModules) {
    Install-PowerShellModules
}

# Install VS Code extensions - after VS Code installation
if (-not $SkipVSCodeExtensions) {
    # Wait for VS Code to register in PATH
    if ($vsCodeInstalled) {
        Write-ColorOutput "Waiting for VS Code installation to complete..." "Info"
        Start-Sleep -Seconds 5
    }
    
    Install-AllVSCodeExtensions
}

# Show summary
Show-Summary

Write-ColorOutput "INSTALLATION COMPLETED" "Header"
