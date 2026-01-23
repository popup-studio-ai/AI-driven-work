# POPUP STUDIO MCP Setup Script
# Usage: powershell -ep bypass -File setup.ps1

$ErrorActionPreference = "Stop"

function Write-Status {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[!!] $Message" -ForegroundColor Yellow
}

function Write-Err {
    param([string]$Message)
    Write-Host "[X] $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "[i] $Message" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "   POPUP STUDIO AI-Driven Work" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""
Write-Host "This script sets up Claude Code and Atlassian MCP Server."
Write-Host ""

# Job type selection
Write-Info "Please answer a few questions:"
Write-Host ""
Write-Host "1. Developer (Backend/Frontend/DevOps/QA)"
Write-Host "2. Non-developer (Planning/Design/Marketing/Operations)"
Write-Host ""
$JOB_TYPE = Read-Host 'Select job type (1 or 2)'
Write-Host ""

# ============================================================
# Step 1: Node.js Check
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "   Step 1: Node.js Check" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

try {
    $nodeVersion = node --version
    $versionNumber = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
    if ($versionNumber -lt 18) {
        Write-Err "Node.js version is below 18. (Current: $nodeVersion)"
        Write-Host "Please install Node.js 18+: https://nodejs.org/"
        exit 1
    }
    Write-Status "Node.js $nodeVersion OK"
}
catch {
    Write-Err "Node.js is not installed."
    Write-Host "Please install Node.js: https://nodejs.org/"
    exit 1
}
Write-Host ""

# ============================================================
# Step 2: Claude Code Install
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "   Step 2: Claude Code Install" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

$claudeInstalled = $false
try {
    $claudeVersion = claude --version 2>$null
    if ($claudeVersion) {
        $claudeInstalled = $true
    }
}
catch { }

if ($claudeInstalled) {
    Write-Status "Claude Code installed"
}
else {
    Write-Warn "Claude Code is not installed."
    Write-Host ""
    $installClaude = Read-Host 'Install Claude Code? (y/n)'

    if ($installClaude -match '^[yY]') {
        Write-Host ""
        Write-Host "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
        Write-Host ""
        Write-Status "Claude Code installed"
    }
    else {
        Write-Host ""
        Write-Err "Claude Code is required. Exiting."
        exit 1
    }
}
Write-Host ""

# ============================================================
# Step 3: Config Directory
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "   Step 3: Config Directory" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

$CLAUDE_CONFIG_DIR = Join-Path $env:USERPROFILE ".config\claude"
$CLAUDE_MCP_DIR = $CLAUDE_CONFIG_DIR

if (-not (Test-Path $CLAUDE_CONFIG_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_CONFIG_DIR -Force | Out-Null
}
if (-not (Test-Path $CLAUDE_MCP_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_MCP_DIR -Force | Out-Null
}

Write-Status "Config directory created"
Write-Host "   $CLAUDE_CONFIG_DIR"
Write-Host ""

# ============================================================
# Step 4: Slash Commands
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "   Step 4: Slash Commands" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

$CLAUDE_COMMANDS_DIR = Join-Path $CLAUDE_CONFIG_DIR ".claude\commands"
if (-not (Test-Path $CLAUDE_COMMANDS_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_COMMANDS_DIR -Force | Out-Null
}

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_DIR = Split-Path -Parent $SCRIPT_DIR
$SOURCE_COMMANDS_DIR = Join-Path $PROJECT_DIR ".claude\commands"

if (Test-Path $SOURCE_COMMANDS_DIR) {
    Copy-Item -Path (Join-Path $SOURCE_COMMANDS_DIR "*") -Destination $CLAUDE_COMMANDS_DIR -Recurse -Force
    Write-Status "Slash commands copied"
    Write-Host "   - /daily-standup"
    Write-Host "   - /weekly-report"
    Write-Host "   - /assign-me"
    Write-Host "   - /save-slack-thread"
}
else {
    Write-Warn "Slash commands directory not found"
}
Write-Host ""

# ============================================================
# Step 5: MCP Server Selection
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "   Step 5: MCP Server Selection" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

# Job type recommendation
if ($JOB_TYPE -eq "1") {
    Write-Info "Recommended for developers: mcp-atlassian"
    Write-Host "   - All 16 tools"
    Write-Host "   - Unlimited usage"
    Write-Host "   - Full control"
    Write-Host "   - CI/CD integration"
    Write-Host ""
}
else {
    Write-Info "Recommended for non-developers: Rovo MCP Server"
    Write-Host "   - Very easy setup (2 min)"
    Write-Host "   - OAuth authentication"
    Write-Host "   - Auto updates"
    Write-Host ""
}

Write-Host "Select MCP Server:"
Write-Host ""
Write-Host "1. Rovo MCP Server (Cloud-based, Easy setup)"
Write-Host "   - Setup time: 2 min"
Write-Host "   - Auth: OAuth (browser click)"
Write-Host "   - Cost: Free (beta)"
Write-Host "   - Recommended: Non-developers"
Write-Host ""
Write-Host "2. mcp-atlassian (Local Docker, Advanced)"
Write-Host "   - Setup time: 15 min"
Write-Host "   - Auth: API token"
Write-Host "   - Cost: Free (permanent)"
Write-Host "   - Recommended: Developers, CI/CD"
Write-Host ""
$MCP_CHOICE = Read-Host 'Select (1 or 2)'
Write-Host ""

# ============================================================
# Step 6: MCP Server Setup
# ============================================================

if ($MCP_CHOICE -eq "1") {
    # ========================================================
    # Rovo MCP Server Setup
    # ========================================================
    Write-Host "==========================================" -ForegroundColor Blue
    Write-Host "   Rovo MCP Server Setup" -ForegroundColor Blue
    Write-Host "==========================================" -ForegroundColor Blue
    Write-Host ""

    Write-Host "Setting up Rovo MCP Server..."
    Write-Host ""

    Write-Info "Running command:"
    Write-Host "  claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse"
    Write-Host ""

    try {
        claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse
        Write-Host ""
        Write-Status "Rovo MCP Server setup complete"
        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host "   Setup Complete!" -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. Run Claude Code:"
        Write-Host "   claude" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "2. OAuth authentication:"
        Write-Host "   - Browser will open automatically"
        Write-Host "   - Login with Atlassian account"
        Write-Host "   - Click 'Allow' button"
        Write-Host ""
        Write-Host "3. Test connection:"
        Write-Host "   Show Jira projects" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "4. First slash command:"
        Write-Host "   /daily-standup" -ForegroundColor Cyan
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Err "Rovo MCP Server setup failed."
        Write-Host ""
        Write-Host "Manual setup:"
        Write-Host "  claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse"
        Write-Host ""
        exit 1
    }
}
elseif ($MCP_CHOICE -eq "2") {
    # ========================================================
    # mcp-atlassian Setup
    # ========================================================
    Write-Host "==========================================" -ForegroundColor Blue
    Write-Host "   mcp-atlassian Setup" -ForegroundColor Blue
    Write-Host "==========================================" -ForegroundColor Blue
    Write-Host ""

    # Docker check
    Write-Host "Checking Docker installation..."
    Write-Host ""

    try {
        $dockerVersion = docker --version
        Write-Status "Docker installed: $dockerVersion"
    }
    catch {
        Write-Err "Docker is not installed."
        Write-Host ""
        Write-Host "Please install Docker Desktop first:"
        Write-Host "  https://docs.docker.com/desktop/install/windows-install/"
        Write-Host ""
        Write-Host "Run this script again after installation."
        Write-Host ""
        exit 1
    }
    Write-Host ""

    # Docker image download
    Write-Host "Downloading Docker image..."
    Write-Host ""

    try {
        docker pull ghcr.io/sooperset/mcp-atlassian:latest
        Write-Host ""
        Write-Status "Docker image downloaded"
    }
    catch {
        Write-Host ""
        Write-Err "Docker image download failed"
        Write-Host ""
        Write-Host "Manual download:"
        Write-Host "  docker pull ghcr.io/sooperset/mcp-atlassian:latest"
        Write-Host ""
        exit 1
    }
    Write-Host ""

    # Check existing config
    $MCP_ATLASSIAN_DIR = Join-Path $env:USERPROFILE ".mcp-atlassian"
    $ENV_FILE = Join-Path $MCP_ATLASSIAN_DIR ".env"
    $USE_EXISTING_CONFIG = $false

    if (Test-Path $ENV_FILE) {
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "   Existing Config Found" -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""

        $envFileContent = Get-Content $ENV_FILE -Raw
        $EXISTING_JIRA_EMAIL = ""
        $EXISTING_CONFLUENCE_EMAIL = ""

        if ($envFileContent -match "JIRA_USERNAME=(.+)") {
            $EXISTING_JIRA_EMAIL = $Matches[1].Trim()
        }
        if ($envFileContent -match "CONFLUENCE_USERNAME=(.+)") {
            $EXISTING_CONFLUENCE_EMAIL = $Matches[1].Trim()
        }

        if ($EXISTING_JIRA_EMAIL -or $EXISTING_CONFLUENCE_EMAIL) {
            Write-Host "Existing config info:"
            if ($EXISTING_JIRA_EMAIL) {
                Write-Host "  Jira email: $EXISTING_JIRA_EMAIL" -ForegroundColor Cyan
            }
            if ($EXISTING_CONFLUENCE_EMAIL) {
                Write-Host "  Confluence email: $EXISTING_CONFLUENCE_EMAIL" -ForegroundColor Cyan
            }
            Write-Host ""
            Write-Host "1. Use existing config (quick)"
            Write-Host "2. Enter new config (change account)"
            Write-Host ""
            $CONFIG_CHOICE = Read-Host 'Select (1 or 2, default: 1)'
            Write-Host ""

            if ($CONFIG_CHOICE -ne "2") {
                $USE_EXISTING_CONFIG = $true
                Write-Status "Using existing config"
                Write-Host ""
            }
        }
    }

    # New config input
    if (-not $USE_EXISTING_CONFIG) {
        # API token guide
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host "   Atlassian API Token" -ForegroundColor Yellow
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. Visit this URL:"
        Write-Host "   https://id.atlassian.com/manage-profile/security/api-tokens" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "2. Click 'Create API token'"
        Write-Host ""
        Write-Host "3. Enter token name (e.g., MCP-ATLASSIAN)"
        Write-Host ""
        Write-Host "4. Copy the generated token (save it securely)"
        Write-Host ""
        Read-Host 'Press Enter when you have the API token'
        Write-Host ""

        # Atlassian info input
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host "   Atlassian Info Input" -ForegroundColor Yellow
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host ""

        $CONFLUENCE_URL = Read-Host 'Confluence URL (e.g., https://company.atlassian.net/wiki)'
        $CONFLUENCE_USERNAME = Read-Host 'Confluence email'
        $CONFLUENCE_API_TOKEN = Read-Host 'Confluence API token'
        Write-Host ""

        $JIRA_URL = Read-Host 'Jira URL (e.g., https://company.atlassian.net)'
        $JIRA_USERNAME = Read-Host 'Jira email'
        $JIRA_API_TOKEN = Read-Host 'Jira API token'
        Write-Host ""

        # Optional filter settings
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host "   Optional Settings (Press Enter to skip)" -ForegroundColor Yellow
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host ""

        $JIRA_PROJECTS_FILTER = Read-Host 'Jira project filter (comma separated, e.g., PROJ,DEV)'
        $CONFLUENCE_SPACES_FILTER = Read-Host 'Confluence space filter (comma separated, e.g., POPUP,DEV)'
        Write-Host ""

        $READ_ONLY_INPUT = Read-Host 'Use read-only mode? (y/n, recommended: n)'
        if ($READ_ONLY_INPUT -match '^[yY]') {
            $READ_ONLY_MODE = "true"
        }
        else {
            $READ_ONLY_MODE = ""
        }
        Write-Host ""

        # Create .env file
        Write-Host "Creating environment file..."
        Write-Host ""

        if (-not (Test-Path $MCP_ATLASSIAN_DIR)) {
            New-Item -ItemType Directory -Path $MCP_ATLASSIAN_DIR -Force | Out-Null
        }

        $envLines = @(
            "# Confluence settings",
            "CONFLUENCE_URL=$CONFLUENCE_URL",
            "CONFLUENCE_USERNAME=$CONFLUENCE_USERNAME",
            "CONFLUENCE_API_TOKEN=$CONFLUENCE_API_TOKEN",
            "",
            "# Jira settings",
            "JIRA_URL=$JIRA_URL",
            "JIRA_USERNAME=$JIRA_USERNAME",
            "JIRA_API_TOKEN=$JIRA_API_TOKEN"
        )

        if ($JIRA_PROJECTS_FILTER) {
            $envLines += ""
            $envLines += "# Project filter"
            $envLines += "JIRA_PROJECTS_FILTER=$JIRA_PROJECTS_FILTER"
        }

        if ($CONFLUENCE_SPACES_FILTER) {
            if (-not $JIRA_PROJECTS_FILTER) {
                $envLines += ""
                $envLines += "# Space filter"
            }
            $envLines += "CONFLUENCE_SPACES_FILTER=$CONFLUENCE_SPACES_FILTER"
        }

        if ($READ_ONLY_MODE) {
            $envLines += ""
            $envLines += "# Read-only mode"
            $envLines += "READ_ONLY_MODE=$READ_ONLY_MODE"
        }

        $envLines | Out-File -FilePath $ENV_FILE -Encoding UTF8

        Write-Status "Environment file created"
        Write-Host "   $ENV_FILE"
        Write-Host ""
    }

    # Claude Desktop App config
    Write-Host "Creating Claude Desktop App config..."
    Write-Host ""

    $MCP_CONFIG_FILE = Join-Path $CLAUDE_MCP_DIR "claude_desktop_config.json"
    $envFilePathForJson = $ENV_FILE -replace '\\', '/'

    $configJson = @{
        mcpServers = @{
            "mcp-atlassian" = @{
                command = "docker"
                args = @(
                    "run",
                    "-i",
                    "--rm",
                    "--env-file",
                    $envFilePathForJson,
                    "ghcr.io/sooperset/mcp-atlassian:latest"
                )
            }
        }
    }

    $configJson | ConvertTo-Json -Depth 10 | Out-File -FilePath $MCP_CONFIG_FILE -Encoding UTF8

    Write-Status "Claude Desktop App config created"
    Write-Host "   $MCP_CONFIG_FILE"
    Write-Host ""

    # Claude Code CLI setup
    Write-Host "Setting up Claude Code CLI..."
    Write-Host ""

    $claudeExists = $false
    try {
        $claudeCheck = Get-Command claude -ErrorAction SilentlyContinue
        if ($claudeCheck) {
            $claudeExists = $true
        }
    }
    catch { }

    if ($claudeExists) {
        # MCP scope selection
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host "   MCP Server Scope Selection" -ForegroundColor Yellow
        Write-Host "==========================================" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. Use in all projects (recommended)"
        Write-Host "   - Access Jira/Confluence from any project"
        Write-Host "   - One-time setup for everywhere"
        Write-Host ""
        Write-Host "2. Use in this project only"
        Write-Host "   - Only in current project"
        Write-Host "   - No setup needed for other projects"
        Write-Host ""
        $MCP_SCOPE_CHOICE = Read-Host 'Select (1 or 2, default: 1)'
        Write-Host ""

        # Set scope
        if ($MCP_SCOPE_CHOICE -eq "2") {
            $MCP_SCOPE = "local"
            $SCOPE_DESC = "this project only"
        }
        else {
            $MCP_SCOPE = "user"
            $SCOPE_DESC = "all projects"
        }

        Write-Host "Selected scope: $SCOPE_DESC" -ForegroundColor Cyan
        Write-Host ""

        # Remove existing mcp-atlassian config
        try {
            claude mcp remove mcp-atlassian 2>$null
        }
        catch { }

        # Add MCP server to Claude Code CLI
        $envFilePath = $ENV_FILE -replace '\\', '/'
        try {
            $addCmd = "claude mcp add --scope $MCP_SCOPE --transport stdio mcp-atlassian -- docker run -i --rm --env-file `"$envFilePath`" ghcr.io/sooperset/mcp-atlassian:latest"
            Invoke-Expression $addCmd
            Write-Status "Claude Code CLI setup complete (scope: $MCP_SCOPE)"
            Write-Host ""

            # Connection test
            Write-Host "Testing connection..."
            $mcpList = claude mcp list 2>$null
            if ($mcpList -match "mcp-atlassian") {
                Write-Status "MCP server registered!"
            }
            else {
                Write-Warn "Cannot verify MCP server. Please restart Claude Code and test."
            }
            Write-Host ""
        }
        catch {
            Write-Err "Claude Code CLI setup failed"
            Write-Host ""
            Write-Host "Manual setup command:"
            Write-Host "  claude mcp add --scope $MCP_SCOPE --transport stdio mcp-atlassian -- docker run -i --rm --env-file `"$envFilePath`" ghcr.io/sooperset/mcp-atlassian:latest" -ForegroundColor Cyan
            Write-Host ""
        }
    }
    else {
        Write-Warn "Claude Code CLI not installed."
        Write-Host "Only Claude Desktop App config was created."
        Write-Host ""
    }

    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "   Setup Complete!" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Run Claude Code:"
    Write-Host "   claude" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "2. Test connection:"
    Write-Host "   Show Jira projects" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. First slash command:"
    Write-Host "   /daily-standup" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Security notice:" -ForegroundColor Yellow
    Write-Host "   Never share your API token!"
    Write-Host "   Keep $ENV_FILE file secure."
    Write-Host ""
}
else {
    Write-Err "Invalid selection. (Enter 1 or 2)"
    exit 1
}

# ============================================================
# Documentation
# ============================================================
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Documentation" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($MCP_CHOICE -eq "1") {
    Write-Host "Rovo MCP Server details:"
    Write-Host "  $PROJECT_DIR\reference\atlassian-rovo-mcp-server.md"
}
else {
    Write-Host "mcp-atlassian details:"
    Write-Host "  $PROJECT_DIR\reference\mcp-atlassian.md"
}

Write-Host ""
Write-Host "MCP Server selection guide:"
Write-Host "  $PROJECT_DIR\docs\mcp-server-selection-guide.md"
Write-Host ""
Write-Host "Claude Code guide:"
Write-Host "  $PROJECT_DIR\docs\claude-code-guide.md"
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "   Done! Happy coding!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
