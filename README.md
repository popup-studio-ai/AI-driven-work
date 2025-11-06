# AI-Driven Work

POPUP STUDIO의 AI Agent를 활용한 업무 프로세스 개선 프로젝트입니다.

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
- **통합**: mcp-atlassian (Claude Code와 Atlassian 도구 연동)

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
│   ├── claude-code-jira-rules.md    # Claude Code - Jira 작업 규칙 (AI Agent용)
│   ├── confluence-guidelines.md     # Confluence 운영 규칙
│   ├── claude-code-guide.md         # Claude Code 사용법
│   ├── mcp-server-selection-guide.md # MCP Server 선택 가이드
│   └── workflow-examples.md         # 업무 플로우 예시
├── .claude/
│   └── commands/
│       ├── daily-standup.md
│       ├── weekly-report.md
│       ├── assign-me.md
│       └── save-slack-thread.md
├── config/
│   ├── mcp-atlassian-config.json
│   └── README.md                    # 설정 방법 설명
└── scripts/
    └── setup.sh                     # 환경 설정 스크립트
```

## 시작하기

### 자동 설정 (권장)

가장 빠르고 쉬운 방법은 **setup.sh 스크립트**를 사용하는 것입니다:

```bash
# 1. 리포지토리 클론
git clone https://github.com/popupstudio/AI-driven-work.git
cd AI-driven-work

# 2. 자동 설정 스크립트 실행
./scripts/setup.sh
```

#### setup.sh가 자동으로 처리하는 작업:

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
2. **Claude Code - Jira 작업 규칙 확인**: `docs/claude-code-jira-rules.md` (AI Agent 동작 이해)
3. **Confluence 운영 규칙 숙지**: `docs/confluence-guidelines.md`
4. **업무 플로우 예시**: `docs/workflow-examples.md`
5. **일일 업무 시작**: `/daily-standup` 실행

## 기여 방법

POPUP STUDIO 전 직원이 이 리포지토리를 참고하여 업무를 진행합니다.
개선 사항이나 제안이 있다면 이슈를 등록하거나 Pull Request를 생성해주세요.

## 라이선스

(추후 작성 예정)
