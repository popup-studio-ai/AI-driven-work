# AI-Driven Work

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/popup-studio-ai/AI-driven-work)](https://github.com/popup-studio-ai/AI-driven-work/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/popup-studio-ai/AI-driven-work/pulls)

POPUP STUDIO의 AI Agent를 활용한 업무 프로세스 개선 프로젝트입니다.

---

## 🚀 빠른 시작

### 완전 초보자이신가요?

터미널, Node.js, Git 같은 용어가 낯설다면 **초보자 가이드**를 먼저 읽어보세요:

👉 **[완전 초보자를 위한 시작 가이드](docs/getting-started-for-beginners.md)**

- ✅ 터미널이 뭔지 모르는 분
- ✅ 프로그램 설치가 처음인 분
- ✅ 스크린샷과 단계별 설명이 필요한 분

### 이미 기술에 익숙하신가요?

아래 내용을 계속 읽으세요 👇

---

## 프로젝트 개요

Claude Code를 AI Agent로 활용하여 Jira, Confluence와 연동하고, 전 직원이 표준화된 방식으로 효율적인 업무를 진행할 수 있도록 지원합니다.

## 목적

- **업무 관리 자동화**: AI Agent가 프로젝트별 담당자, 이슈 처리 현황, 진행 상황을 자동으로 파악
- **관리 공수 절감**: 반복적인 관리 작업을 AI가 처리하여 실질적인 업무에 집중
- **전사적 표준화**: GitHub 리포지토리를 통한 일관된 업무 프로세스 구축
- **정보 중앙화**: Confluence를 단일 진실 공급원으로 삼아 산재된 정보를 통합 관리
- **지식 공유 활성화**: 문서화를 통한 조직 지식 축적 및 접근성 향상

## 기술 스택

- **AI Agent**: Claude Code
- **프로젝트 관리**: Jira
- **문서화**: Confluence
- **통합**: MCP (Model Context Protocol) 서버
  - **mcp-atlassian**: Jira/Confluence 연동
  - **향후 확장 예정**: Slack, GitHub, Notion 등 추가 MCP 서버 통합 계획

## 해결하고자 하는 문제

### 현재 문제점

1. **Slack 업무 지시의 한계**
   - 티켓 미발행으로 인한 Task 추적 어려움
   - 개개인의 Task 관리 능력에 의존
   - 업무 지시 내용이 휘발되어 검색 및 추적 불가

2. **Notion 프로젝트 관리의 비효율**
   - 관리를 위한 추가 공수 발생
   - 낮은 활용도 (사용하는 사람만 사용)
   - Jira와 중복된 관리 포인트

3. **정보의 산재 (Information Fragmentation)**
   - **Google Drive**: 문서, 스프레드시트가 개인별로 분산 저장
   - **Notion**: 일부 팀원만 사용하는 프로젝트 노트
   - **Slack**: 중요한 의사결정이 대화 속에 묻힘
   - **로컬**: 개인 PC에만 존재하는 기술 문서
   - 결과: 정보 접근성 저하, 중복 작업 발생, 지식 공유 어려움

### 해결 방안

#### 1. 업무 관리 통합
AI Agent를 통해 Jira/Confluence 정보를 자동으로 수집하고 분석하여, 별도의 관리 도구 없이 효율적인 업무 진행이 가능하도록 지원합니다.

#### 2. 문서화 중앙화
- **Confluence를 단일 진실 공급원(Single Source of Truth)으로 확립**
- **자동 마이그레이션**: AI Agent가 산재된 정보를 식별하고 Confluence로 이관 제안
- **정보 구조화**: 프로젝트별, 팀별 명확한 페이지 구조
- **검색 가능성**: 모든 문서가 한 곳에서 검색 가능
- **접근 권한 관리**: 프로젝트별 적절한 권한 설정

#### 3. 문서화 자동화
- Slack의 중요 스레드를 Confluence 페이지로 자동 변환
- Jira 이슈와 Confluence 문서 자동 연결
- 주간 보고서 자동 생성 및 아카이빙
- Google Drive 문서의 Confluence 동기화 워크플로우

## 프로젝트 구성

### 문서화

#### Jira 운영 규칙
- **이슈 타입 구분**: Story, Epic, Task, Sub-Task 사용 가이드
- **자율적 이슈 관리**:
  - 누구나 자유롭게 이슈 티켓 생성
  - 매일 업무 시작 전 Claude Code로 미할당 이슈 확인
  - 자율적으로 담당자 지정하여 업무 선택
- **주간 업무 공유**: 주간 보고서 작성 및 기록 방법

#### Claude Code - Jira 작업 규칙
- **AI Agent 전용 규칙**: Claude Code가 Jira 작업을 처리할 때 따라야 할 지침
- **이슈 타입 판단 기준**: Epic, Story, Task, Sub-Task 자동 구분 로직
- **담당자 지정 원칙**: Epic/Story는 책임자, Task/Sub-Task는 실행 담당자
- **자동화 작업 가이드**: /daily-standup, /weekly-report, /assign-me 처리 규칙
- **커뮤니케이션 원칙**: 명확하고 일관된 응답 방식

#### Claude Code 가이드
- **기본 개념**: rules, instructions, skill, slash command
- **공통 Slash Commands**:
  - `/daily-standup`: 미할당 이슈 확인 + 내 할당 이슈 현황
  - `/weekly-report`: 주간 보고서 생성 (완료 이슈 기반)
  - `/assign-me <issue-key>`: 이슈 담당자로 자신을 지정
  - `/save-slack-thread`: Slack 스레드를 Confluence 페이지로 변환
- **mcp-atlassian 설정 방법**

#### Confluence 운영 규칙
- 문서화 대상 정의
- 페이지 구조 및 관리 방법

#### Workflow 예시
- 신입 직원 온보딩 플로우
- 일일/주간 업무 루틴 예시

### Configuration 관리

**Infrastructure as Code 접근**으로 전 직원의 업무 환경을 표준화합니다:
- `.claude/` 디렉토리: 공통 slash commands
- `mcp-config.json`: mcp-atlassian 설정 템플릿
- `setup.sh`: 초기 환경 설정 스크립트

## 디렉토리 구조

```
AI-driven-work/
├── README.md
├── docs/
│   ├── jira-guidelines.md           # Jira 운영 규칙 (전 직원용)
│   ├── confluence-guidelines.md     # Confluence 운영 규칙
│   ├── claude-code-guide.md         # Claude Code 사용법
│   ├── mcp-server-selection-guide.md # MCP Server 선택 가이드
│   └── workflow-examples.md         # 업무 플로우 예시
├── .claude/
│   ├── instructions/
│   │   └── jira-rules.md            # Claude Code - Jira 작업 규칙 (AI Agent용, 자동 적용)
│   └── commands/
│       ├── daily-standup.md
│       ├── weekly-report.md
│       ├── assign-me.md
│       └── save-slack-thread.md
├── config/
│   ├── mcp-atlassian-config.json
│   └── README.md                    # 설정 방법 설명
└── scripts/
    ├── setup.sh                     # 환경 설정 스크립트 (macOS/Linux)
    ├── setup.ps1                    # 환경 설정 스크립트 (Windows)
    ├── jira-rules-setup.sh          # Jira 기능 추가 스크립트 (macOS/Linux)
    ├── jira-rules-setup.ps1         # Jira 기능 추가 스크립트 (Windows)
    ├── github-workflow-setup.sh     # GitHub 워크플로우 추가 스크립트 (macOS/Linux)
    └── github-workflow-setup.ps1    # GitHub 워크플로우 추가 스크립트 (Windows)
```

## 시작하기

### 자동 설정 (권장)

가장 빠르고 쉬운 방법은 자동 설정 스크립트를 사용하는 것입니다.

#### macOS / Linux 사용자

```bash
# 1. 리포지토리 클론
git clone https://github.com/popupstudio/AI-driven-work.git
cd AI-driven-work

# 2. 자동 설정 스크립트 실행
./scripts/setup.sh
```

#### Windows 사용자

**PowerShell**을 관리자 권한으로 실행한 후:

```powershell
# 1. 리포지토리 클론
git clone https://github.com/popupstudio/AI-driven-work.git
cd AI-driven-work

# 2. PowerShell 실행 정책 확인 (최초 1회)
Get-ExecutionPolicy

# 3. 실행 정책이 Restricted라면 변경 (최초 1회)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 4. 자동 설정 스크립트 실행
.\scripts\setup.ps1
```

> **참고**: Windows에서는 `.ps1` PowerShell 스크립트를 사용합니다.

#### 자동 설정 스크립트가 처리하는 작업:

1. **환경 확인**
   - Node.js 18+ 설치 확인
   - Docker 설치 확인 (mcp-atlassian 선택 시)

2. **Claude Code 설치**
   - 미설치 시 자동 설치 제안
   - 버전 확인

3. **MCP Server 선택**
   - **비개발자**: Rovo MCP Server (OAuth, 2분 설정)
   - **개발자**: mcp-atlassian (Docker, API 토큰, 15분 설정)

4. **자동 구성**
   - Atlassian API 토큰 입력 (또는 기존 설정 재사용)
   - 환경 변수 파일 생성 (`~/.mcp-atlassian/.env`)
   - Claude Code CLI 자동 등록 (`claude mcp add`)
   - 사용 범위 선택 (모든 프로젝트 vs 현재 프로젝트만)
   - 연결 테스트 자동 수행

5. **Slash Commands 복사**
   - `/daily-standup`, `/weekly-report`, `/assign-me`, `/save-slack-thread`

#### 설정 완료 후:

```bash
# Claude Code 실행
claude

# 연결 테스트
> Jira 프로젝트 목록 보여줘

# 첫 slash command 실행
> /daily-standup
```

### 수동 설정

직접 설정하고 싶다면 다음 가이드를 참고하세요:

- **비개발자 (Rovo)**: `docs/claude-code-guide.md`
- **개발자 (mcp-atlassian)**: `reference/mcp-atlassian.md`
- **MCP Server 선택 가이드**: `docs/mcp-server-selection-guide.md`

### 다음 단계

1. **Jira 운영 규칙 숙지**: `docs/jira-guidelines.md`
2. **Claude Code - Jira 작업 규칙 확인**: `.claude/instructions/jira-rules.md` (AI Agent 동작 이해)
3. **Confluence 운영 규칙 숙지**: `docs/confluence-guidelines.md`
4. **업무 플로우 예시**: `docs/workflow-examples.md`
5. **일일 업무 시작**: `/daily-standup` 실행

---

## 다른 프로젝트에 Jira 기능 추가하기

AI-driven-work 프로젝트가 아닌 **다른 프로젝트에서도 Jira 관련 기능을 사용**하고 싶다면, 자동 설정 스크립트를 사용하세요.

### 사용 방법

#### macOS / Linux

```bash
# AI-driven-work 프로젝트에서 실행
cd ~/Documents/GitHub/popup/AI-driven-work

# 다른 프로젝트에 Jira 기능 추가
./scripts/jira-rules-setup.sh <타겟_프로젝트_경로>

# 예시
./scripts/jira-rules-setup.sh ~/projects/my-web-app
./scripts/jira-rules-setup.sh ~/work/frontend-project
```

#### Windows

```powershell
# AI-driven-work 프로젝트에서 실행 (PowerShell)
cd C:\Users\YourName\Documents\GitHub\popup\AI-driven-work

# 다른 프로젝트에 Jira 기능 추가
.\scripts\jira-rules-setup.ps1 C:\projects\my-web-app

# 예시
.\scripts\jira-rules-setup.ps1 C:\projects\my-web-app
.\scripts\jira-rules-setup.ps1 C:\work\frontend-project
```

### Dry-run 모드 (미리보기)

실제 변경 없이 어떤 작업이 수행될지 미리 확인할 수 있습니다:

#### macOS / Linux
```bash
./scripts/jira-rules-setup.sh ~/projects/my-web-app --dry-run
```

#### Windows
```powershell
.\scripts\jira-rules-setup.ps1 C:\projects\my-web-app -DryRun
```

### 스크립트가 수행하는 작업

1. **Slash Commands 복사**
   - `/daily-standup`, `/weekly-report`, `/assign-me`, `/save-slack-thread`
   - 타겟 프로젝트의 `.claude/commands/` 디렉토리로 복사
   - 파일 충돌 시 선택 옵션 제공 (덮어쓰기/건너뛰기/이름변경/차이점 보기)

2. **Jira 지침 복사**
   - `.claude/instructions/jira-rules.md` 복사
   - Claude Code가 Jira 작업을 자동으로 처리할 수 있도록 설정

3. **기존 지침과 통합**
   - 타겟 프로젝트에 다른 instructions 파일이 있다면 자동 감지
   - 각 파일에 `jira-rules.md` 참조 추가하여 모든 지침이 함께 적용되도록 설정

4. **자동 백업**
   - 덮어쓰기 전 자동으로 백업 생성 (`.claude/.backup-YYYYMMDD-HHMMSS/`)
   - 문제 발생 시 복구 가능

### 적용 후 사용

타겟 프로젝트로 이동하여 Claude Code를 실행하면 Jira 기능을 바로 사용할 수 있습니다:

```bash
# 타겟 프로젝트로 이동
cd ~/projects/my-web-app

# Claude Code 실행
claude

# Jira 기능 테스트
> /daily-standup
> Jira에서 미할당 이슈 보여줘
```

### 주의사항

- **MCP Server 설정 필요**: `jira-rules-setup.sh`는 slash commands와 지침만 복사합니다. MCP Server 설정은 `setup.sh`로 미리 완료되어 있어야 합니다.
- **프로젝트별 독립 실행**: 각 프로젝트에서 Claude Code를 실행하면 해당 프로젝트의 지침이 적용됩니다.

---

## 다른 프로젝트에 GitHub 워크플로우 추가하기

다른 프로젝트에서도 **표준화된 Git 브랜치 전략과 PR 워크플로우**를 사용하고 싶다면, 자동 설정 스크립트를 사용하세요.

### 사용 방법

#### macOS / Linux

```bash
# AI-driven-work 프로젝트에서 실행
cd ~/Documents/GitHub/popup/AI-driven-work

# 다른 프로젝트에 GitHub 워크플로우 추가
./scripts/github-workflow-setup.sh <타겟_프로젝트_경로>

# 예시
./scripts/github-workflow-setup.sh ~/projects/my-web-app
./scripts/github-workflow-setup.sh ~/work/backend-api
```

#### Windows

```powershell
# AI-driven-work 프로젝트에서 실행 (PowerShell)
cd C:\Users\YourName\Documents\GitHub\popup\AI-driven-work

# 다른 프로젝트에 GitHub 워크플로우 추가
.\scripts\github-workflow-setup.ps1 C:\projects\my-web-app

# 예시
.\scripts\github-workflow-setup.ps1 C:\projects\my-web-app
.\scripts\github-workflow-setup.ps1 C:\work\backend-api
```

### Dry-run 모드 (미리보기)

실제 변경 없이 어떤 작업이 수행될지 미리 확인할 수 있습니다:

#### macOS / Linux
```bash
./scripts/github-workflow-setup.sh ~/projects/my-web-app --dry-run
```

#### Windows
```powershell
.\scripts\github-workflow-setup.ps1 C:\projects\my-web-app -DryRun
```

### 스크립트가 수행하는 작업

1. **GitHub Workflow 지침 복사**
   - `.claude/instructions/github-workflow.md` 복사
   - 브랜치 전략, 머지 전략, PR 워크플로우 가이드

2. **GitHub 설정 파일 생성**
   - `.github/CODEOWNERS` - 코드 소유자 자동 지정
   - `.github/ISSUE_TEMPLATE/bug_report.md` - 버그 리포트 템플릿
   - `.github/ISSUE_TEMPLATE/feature_request.md` - 기능 제안 템플릿

3. **기존 지침과 통합**
   - 타겟 프로젝트의 다른 instruction 파일 자동 감지
   - 각 파일에 `github-workflow.md` 참조 추가

4. **자동 백업**
   - 덮어쓰기 전 자동으로 백업 생성 (`.claude/.backup-YYYYMMDD-HHMMSS/`)

### 적용 후 설정

스크립트 실행 후 GitHub 저장소에서 Branch Protection Rules를 설정하세요:

1. **GitHub 저장소 설정**: `Settings → Branches`
2. **main 브랜치 보호**:
   - PR 필수
   - 최소 1명 승인 필요
   - Code Owners 승인 필수
3. **develop 브랜치 보호**:
   - PR 필수
   - 최소 1명 승인 필요

자세한 내용은 생성된 `.claude/instructions/github-workflow.md` 파일을 참고하세요.

---

## MCP 서버 확장 계획

이 프로젝트는 지속적으로 발전하며, 필요에 따라 다양한 MCP 서버를 추가할 예정입니다.

### 현재 통합된 MCP 서버

- **mcp-atlassian**: Jira/Confluence 연동

### 향후 추가 예정 MCP 서버

업무 효율성을 더욱 높이기 위해 다음 MCP 서버 통합을 검토 중입니다:

1. **Slack MCP Server**
   - Slack 메시지 자동 검색 및 분석
   - 중요 대화를 Confluence로 자동 마이그레이션
   - 채널별 업무 현황 모니터링

2. **GitHub MCP Server**
   - PR 자동 리뷰 및 머지 관리
   - Issue와 Jira 자동 연동
   - 커밋 히스토리 분석 및 보고서 생성

3. **Notion MCP Server**
   - Notion 페이지를 Confluence로 마이그레이션
   - 데이터베이스 자동 동기화
   - 정보 통합 및 중복 제거

4. **Google Drive MCP Server**
   - 문서 검색 및 Confluence 동기화
   - 스프레드시트 데이터 분석
   - 파일 권한 관리 자동화

5. **Linear MCP Server**
   - Linear 이슈와 Jira 동기화
   - 통합 프로젝트 관리 대시보드
   - 진행 상황 자동 리포팅

### MCP 서버 추가 시 자동 배포

새로운 MCP 서버가 추가되면:
- `setup.sh` 스크립트가 자동으로 업데이트됩니다
- 기존 사용자는 `setup.sh`를 다시 실행하여 새 MCP 서버를 선택적으로 추가할 수 있습니다
- 각 MCP 서버는 독립적으로 활성화/비활성화 가능합니다

### 제안 및 피드백

업무에 필요한 MCP 서버가 있다면 이슈로 제안해주세요. 팀의 실제 니즈에 맞춰 우선순위를 조정하여 추가할 예정입니다.

---

## 기여 방법

POPUP STUDIO 전 직원이 이 리포지토리를 참고하여 업무를 진행합니다.
개선 사항이나 제안이 있다면 이슈를 등록하거나 Pull Request를 생성해주세요.

### 기여 가이드라인

1. **이슈 등록**: 버그 리포트나 기능 제안을 GitHub Issue로 등록
2. **Fork & Branch**: 리포지토리를 포크하고 feature 브랜치 생성
3. **개발**: `.claude/instructions/github-workflow.md` 참고하여 작업
4. **Pull Request**: develop 브랜치로 PR 생성
5. **리뷰**: popup-kay의 승인 후 머지

자세한 내용은 `.claude/instructions/github-workflow.md`를 참고하세요.

## 라이선스

이 프로젝트는 [MIT License](LICENSE)로 배포됩니다.

### MIT License란?

- ✅ 상업적 사용 가능
- ✅ 수정 및 배포 자유
- ✅ 사적 사용 허용
- ✅ 파생 작업물 생성 가능

자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

### 사용 예시

이 프로젝트를 자유롭게 사용할 수 있습니다:

```bash
# 1. 리포지토리 클론
git clone https://github.com/popup-studio-ai/AI-driven-work.git

# 2. 자신의 팀/회사에 맞게 커스터마이징
cd AI-driven-work
# ... 수정 작업 ...

# 3. 개선사항을 커뮤니티에 기여 (선택사항)
git checkout -b feature/my-improvement
# ... PR 생성 ...
```

### 저작권 고지

```
MIT License

Copyright (c) 2025 POPUP STUDIO

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

전체 라이선스 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

---

**Made with ❤️ by POPUP STUDIO**

**Powered by [Claude Code](https://claude.com/claude-code)**
