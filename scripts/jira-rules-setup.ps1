# Jira Rules Setup Script (Windows PowerShell)
# AI-driven-work 프로젝트의 Jira 관련 기능을 다른 프로젝트에 추가합니다.
#
# Usage:
#   .\scripts\jira-rules-setup.ps1 <target-project-path> [-DryRun]
#
# Examples:
#   .\scripts\jira-rules-setup.ps1 C:\projects\my-web-app
#   .\scripts\jira-rules-setup.ps1 C:\projects\my-web-app -DryRun

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$TargetProjectPath,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

# 에러 발생 시 중단
$ErrorActionPreference = "Stop"

# 색상 출력 함수
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "🎯 Jira Rules Setup" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

if ($DryRun) {
    Write-ColorOutput "🔍 DRY-RUN 모드: 실제 변경 없이 미리보기만 수행합니다." "Cyan"
    Write-Host ""
}

# 타겟 경로 확인
if (-not (Test-Path $TargetProjectPath)) {
    Write-ColorOutput "❌ 타겟 디렉토리가 존재하지 않습니다: $TargetProjectPath" "Red"
    exit 1
}

$TargetProjectPath = Resolve-Path $TargetProjectPath

# 소스 경로
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$SOURCE_PROJECT_DIR = Split-Path -Parent $SCRIPT_DIR
$SOURCE_COMMANDS_DIR = Join-Path $SOURCE_PROJECT_DIR ".claude\commands"
$SOURCE_INSTRUCTIONS_DIR = Join-Path $SOURCE_PROJECT_DIR ".claude\instructions"
$SOURCE_JIRA_RULES = Join-Path $SOURCE_INSTRUCTIONS_DIR "jira-rules.md"

# 타겟 경로
$TARGET_COMMANDS_DIR = Join-Path $TargetProjectPath ".claude\commands"
$TARGET_INSTRUCTIONS_DIR = Join-Path $TargetProjectPath ".claude\instructions"
$TARGET_JIRA_RULES = Join-Path $TARGET_INSTRUCTIONS_DIR "jira-rules.md"

Write-ColorOutput "소스 프로젝트: $SOURCE_PROJECT_DIR" "Cyan"
Write-ColorOutput "타겟 프로젝트: $TargetProjectPath" "Cyan"
Write-Host ""

# 소스 디렉토리 확인
if (-not (Test-Path $SOURCE_COMMANDS_DIR) -or -not (Test-Path $SOURCE_INSTRUCTIONS_DIR)) {
    Write-ColorOutput "❌ 소스 프로젝트에 .claude 디렉토리가 없습니다. AI-driven-work 프로젝트에서 실행하세요." "Red"
    exit 1
}

# 백업 디렉토리 생성
$BACKUP_DIR = ""
if (-not $DryRun) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $BACKUP_DIR = Join-Path $TargetProjectPath ".claude\.backup-$timestamp"
    New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
    Write-ColorOutput "📦 백업 디렉토리 생성: $BACKUP_DIR" "Green"
    Write-Host ""
}

# ============================================================
# 헬퍼 함수
# ============================================================

function Backup-File {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath)) {
        return
    }

    if ($DryRun) {
        Write-ColorOutput "  [DRY-RUN] 백업 생성: $FilePath" "Cyan"
        return
    }

    $fileName = Split-Path $FilePath -Leaf
    $backupFile = Join-Path $BACKUP_DIR "$fileName.backup"
    Copy-Item $FilePath $backupFile
    Write-Host "  💾 백업 생성: $fileName"
}

function Copy-FileWithConflictHandling {
    param(
        [string]$SourceFile,
        [string]$TargetFile
    )

    if (-not (Test-Path $SourceFile)) {
        Write-ColorOutput "  ⚠️  소스 파일이 존재하지 않습니다: $(Split-Path $SourceFile -Leaf)" "Yellow"
        return $false
    }

    # 타겟 파일이 이미 존재하는 경우
    if (Test-Path $TargetFile) {
        Write-ColorOutput "  ⚠️  $(Split-Path $TargetFile -Leaf) 이미 존재합니다." "Yellow"

        if ($DryRun) {
            Write-ColorOutput "  [DRY-RUN] 사용자에게 선택을 물어볼 예정" "Cyan"
            return $true
        }

        Write-Host "     (o)덮어쓰기 / (s)건너뛰기 / (r)이름변경 / (d)차이점 보기" -ForegroundColor Cyan
        $choice = Read-Host "     선택"

        switch ($choice.ToLower()) {
            "o" {
                Backup-File $TargetFile
                Copy-Item $SourceFile $TargetFile -Force
                Write-ColorOutput "  ✅ $(Split-Path $TargetFile -Leaf) 덮어쓰기 완료" "Green"
                return $true
            }
            "s" {
                Write-ColorOutput "  ⏭️  $(Split-Path $TargetFile -Leaf) 건너뜀" "Blue"
                return $true
            }
            "r" {
                $newName = Read-Host "     새 파일명 (확장자 제외)"
                $extension = [System.IO.Path]::GetExtension($TargetFile)
                $directory = Split-Path $TargetFile
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($TargetFile)
                $newTarget = Join-Path $directory "$baseName-$newName$extension"
                Copy-Item $SourceFile $newTarget
                Write-ColorOutput "  ✅ $(Split-Path $newTarget -Leaf) 생성 완료" "Green"
                return $true
            }
            "d" {
                Write-Host ""
                Write-Host "==========================================" -ForegroundColor White
                Write-Host "차이점:" -ForegroundColor White
                Write-Host "==========================================" -ForegroundColor White
                Compare-Object (Get-Content $TargetFile) (Get-Content $SourceFile) | Format-Table -AutoSize
                Write-Host "==========================================" -ForegroundColor White
                Write-Host ""
                # 재귀 호출
                return Copy-FileWithConflictHandling $SourceFile $TargetFile
            }
            default {
                Write-ColorOutput "  ⏭️  잘못된 입력. 건너뜀" "Blue"
                return $true
            }
        }
    } else {
        # 타겟 파일이 없는 경우 - 그냥 복사
        if ($DryRun) {
            Write-ColorOutput "  [DRY-RUN] 복사: $(Split-Path $SourceFile -Leaf) → $(Split-Path $TargetFile -Leaf)" "Cyan"
        } else {
            Copy-Item $SourceFile $TargetFile
            Write-ColorOutput "  ✅ $(Split-Path $TargetFile -Leaf) 복사 완료" "Green"
        }
        return $true
    }
}

function Add-JiraRulesReference {
    param([string]$InstructionFile)

    $relativePath = ".claude\instructions\jira-rules.md"

    # 이미 참조가 있는지 확인
    if (Test-Path $InstructionFile) {
        $content = Get-Content $InstructionFile -Raw
        if ($content -match "jira-rules\.md") {
            Write-ColorOutput "  ℹ️  $(Split-Path $InstructionFile -Leaf): 이미 jira-rules.md 참조 존재" "Blue"
            return
        }
    }

    if ($DryRun) {
        Write-ColorOutput "  [DRY-RUN] 참조 추가 예정: $(Split-Path $InstructionFile -Leaf)" "Cyan"
        return
    }

    # 백업 생성
    Backup-File $InstructionFile

    # 파일 시작 부분에 참조 추가
    $reference = @"
---

> **📋 Additional Instructions**: This project also follows Jira workflow rules.
> See: `$relativePath`

---


"@

    $originalContent = Get-Content $InstructionFile -Raw -ErrorAction SilentlyContinue
    $newContent = $reference + $originalContent
    Set-Content -Path $InstructionFile -Value $newContent -Encoding UTF8

    Write-ColorOutput "  ✅ $(Split-Path $InstructionFile -Leaf): jira-rules.md 참조 추가 완료" "Green"
}

# ============================================================
# 1단계: Slash Commands 복사
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "[1/4] Slash Commands 복사" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

# 타겟 commands 디렉토리 생성
if ($DryRun) {
    Write-ColorOutput "[DRY-RUN] 디렉토리 생성: $TARGET_COMMANDS_DIR" "Cyan"
} else {
    if (-not (Test-Path $TARGET_COMMANDS_DIR)) {
        New-Item -ItemType Directory -Path $TARGET_COMMANDS_DIR -Force | Out-Null
    }
    Write-ColorOutput "✅ 디렉토리 생성: $TARGET_COMMANDS_DIR" "Green"
}
Write-Host ""

# 각 command 파일 복사 (소스 디렉토리의 모든 .md 파일 자동 감지)
Write-ColorOutput "소스 디렉토리에서 command 파일 검색 중..." "Cyan"
Write-Host ""

$commandFiles = Get-ChildItem -Path $SOURCE_COMMANDS_DIR -Filter "*.md" -File -ErrorAction SilentlyContinue

if ($commandFiles.Count -eq 0) {
    Write-ColorOutput "⚠️  소스 디렉토리에 command 파일이 없습니다." "Yellow"
} else {
    foreach ($cmdFile in $commandFiles) {
        $sourceFile = $cmdFile.FullName
        $targetFile = Join-Path $TARGET_COMMANDS_DIR $cmdFile.Name
        Copy-FileWithConflictHandling $sourceFile $targetFile | Out-Null
    }
    Write-ColorOutput "✅ 총 $($commandFiles.Count)개의 command 파일 처리 완료" "Green"
}

Write-Host ""

# ============================================================
# 2단계: Jira 지침 복사
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "[2/4] Jira 지침 복사" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

# 타겟 instructions 디렉토리 생성
if ($DryRun) {
    Write-ColorOutput "[DRY-RUN] 디렉토리 생성: $TARGET_INSTRUCTIONS_DIR" "Cyan"
} else {
    if (-not (Test-Path $TARGET_INSTRUCTIONS_DIR)) {
        New-Item -ItemType Directory -Path $TARGET_INSTRUCTIONS_DIR -Force | Out-Null
    }
    Write-ColorOutput "✅ 디렉토리 생성: $TARGET_INSTRUCTIONS_DIR" "Green"
}
Write-Host ""

# jira-rules.md 복사
Copy-FileWithConflictHandling $SOURCE_JIRA_RULES $TARGET_JIRA_RULES | Out-Null

Write-Host ""

# ============================================================
# 3단계: 기존 instructions 파일에 참조 추가
# ============================================================
Write-Host "==========================================" -ForegroundColor Blue
Write-Host "[3/4] 기존 Instructions 파일 확인" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Write-Host ""

# 타겟에 있는 다른 instruction 파일들 찾기
if (Test-Path $TARGET_INSTRUCTIONS_DIR) {
    $otherInstructions = Get-ChildItem -Path $TARGET_INSTRUCTIONS_DIR -Filter "*.md" |
                         Where-Object { $_.Name -ne "jira-rules.md" }

    if ($otherInstructions.Count -eq 0) {
        Write-ColorOutput "ℹ️  다른 instruction 파일이 없습니다." "Blue"
    } else {
        Write-ColorOutput "발견된 instruction 파일: $($otherInstructions.Count)개" "Cyan"
        Write-Host ""

        foreach ($instFile in $otherInstructions) {
            Write-Host "  📄 $($instFile.Name)"
            Add-JiraRulesReference $instFile.FullName
        }
    }
} else {
    Write-ColorOutput "ℹ️  instructions 디렉토리가 없습니다." "Blue"
}

Write-Host ""

# ============================================================
# 4단계: 완료 메시지
# ============================================================
Write-Host "==========================================" -ForegroundColor Green
Write-Host "✨ [4/4] 설정 완료! ✨" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

if ($DryRun) {
    Write-ColorOutput "🔍 DRY-RUN 모드였습니다. 실제 변경은 이루어지지 않았습니다." "Cyan"
    Write-Host ""
    Write-Host "실제로 적용하려면 -DryRun 옵션 없이 다시 실행하세요:"
    Write-ColorOutput "  .\scripts\jira-rules-setup.ps1 $TargetProjectPath" "Yellow"
} else {
    Write-ColorOutput "📝 다음 단계:" "Yellow"
    Write-Host ""
    Write-Host "1. 타겟 프로젝트로 이동:"
    Write-ColorOutput "   cd $TargetProjectPath" "Cyan"
    Write-Host ""
    Write-Host "2. Claude Code 실행:"
    Write-ColorOutput "   claude" "Cyan"
    Write-Host ""
    Write-Host "3. Jira slash command 테스트:"
    Write-ColorOutput "   /daily-standup" "Cyan"
    Write-Host ""
    Write-Host "4. Jira 관련 작업 시도:"
    Write-ColorOutput "   Jira에서 미할당 이슈 보여줘" "Cyan"
    Write-Host ""

    if ($BACKUP_DIR) {
        Write-ColorOutput "💾 백업 위치:" "Yellow"
        Write-Host "   $BACKUP_DIR"
        Write-Host ""
        Write-ColorOutput "⚠️  문제가 발생한 경우 백업에서 복구할 수 있습니다." "Yellow"
        Write-Host ""
    }
}

Write-Host "==========================================" -ForegroundColor Green
Write-Host "🎉 완료! 즐거운 작업 되세요! 🎉" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
