# Weekly Report Refactoring - Design Document

> **Feature**: weekly-report-refactoring
> **Version**: 2.0.0
> **Created**: 2026-02-01
> **Status**: Design Phase

---

## 1. Overview

### 1.1 Problem Statement

현재 `/weekly-report` 명령어의 문제점:

| 문제 | 상세 |
|------|------|
| **기간 계산 불명확** | 주간 회의 기준 날짜 계산 로직이 모호함 |
| **프로젝트 누락** | 3개(PS, BK, BKAM)에서 4개(+BKIT)로 증가했으나 미반영 |
| **Context 오염** | 단일 commands 파일에 모든 로직이 포함되어 Context 낭비 |
| **이슈 타입 누락** | Story 중심이나 Epic, Sub-task 등 모든 타입 조회 필요 |
| **팀원 확장성** | 팀원 증가에 유연하게 대응하기 어려움 |

### 1.2 Solution Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Weekly Report System v2.0                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │   Skills    │───>│   Agents    │───>│     Templates       │  │
│  │ (Trigger)   │    │ (Executor)  │    │ (Output Format)     │  │
│  └─────────────┘    └─────────────┘    └─────────────────────┘  │
│        │                  │                      │               │
│        v                  v                      v               │
│  weekly-report.md   jira-collector    weekly-report.template.md  │
│  (Entry Point)      (Data Fetch)      (Report Format)            │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                       Data Flow                                  │
│  User Request → Skill → Agent(MCP) → JSON → Template → Output   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Component Design

### 2.1 Directory Structure

```
.claude/
├── skills/
│   └── weekly-report.md          # [NEW] 스킬 정의 (Entry Point)
├── agents/
│   └── jira-collector.md         # [NEW] Jira 데이터 수집 Agent
├── templates/
│   └── weekly-report.template.md # [NEW] 보고서 양식 템플릿
├── scripts/
│   └── collect-jira-issues.py    # [UPDATE] 프로젝트 4개 지원
├── commands/
│   └── weekly-report.md          # [DEPRECATE] 기존 명령어 → 스킬로 마이그레이션
└── instructions/
    └── jira-rules.md             # 기존 유지
```

### 2.2 Component Specifications

#### 2.2.1 Skill: `weekly-report.md`

**위치**: `.claude/skills/weekly-report.md`

**역할**:
- 사용자 요청 파싱 및 파라미터 처리
- Agent 호출 및 실행 흐름 제어
- 최종 보고서 생성 및 Confluence 저장

**Frontmatter 설계**:
```yaml
---
name: weekly-report
description: 주간 업무 보고서 생성 (팀/개인)
version: 2.0.0
triggers:
  - weekly report
  - 주간 보고서
  - 주간 업무
agents:
  - jira-collector        # Agent 사전 로드
templates:
  - weekly-report         # Template 사전 로드
parameters:
  project:
    type: string
    description: "Jira 프로젝트 키 (PS, BK, BKIT, BKAM). 없으면 전체"
    required: false
  mode:
    type: enum
    values: [team, me]
    default: team
    description: "보고서 유형 (팀 전체 / 개인)"
---
```

**실행 흐름**:
```
1. 기간 계산 (월요일 기준)
   ├─ 지난주: 이전 월요일 00:00 ~ 일요일 23:59
   └─ 이번주: 이번 월요일 00:00 ~ 일요일 23:59

2. Agent 호출 (jira-collector)
   ├─ 프로젝트 파라미터 전달
   └─ 팀원 목록 전달

3. 데이터 수집 결과 수신 (JSON)

4. Template 적용
   └─ weekly-report.template.md 로드

5. Confluence 저장
   ├─ 폴더 확인/생성 요청
   └─ 페이지 생성
```

#### 2.2.2 Agent: `jira-collector.md`

**위치**: `.claude/agents/jira-collector.md`

**역할**:
- MCP를 통한 Jira 데이터 수집
- 팀원별/프로젝트별 이슈 분류
- 구조화된 JSON 데이터 반환

**Frontmatter 설계**:
```yaml
---
name: jira-collector
description: Jira 이슈 데이터 수집 Agent
version: 1.0.0
type: data-collector
tools:
  - mcp__mcp-atlassian__jira_search
  - mcp__mcp-atlassian__jira_get_issue
  - mcp__mcp-atlassian__jira_get_project_issues  # 프로젝트별 이슈 조회 (선택적)
config:
  projects:
    - key: PS
      name: POPUP-STUDIO
      description: 회사 공용 및 기타 업무
    - key: BK
      name: Bkend
      description: bkend.ai 프로덕트
    - key: BKIT
      name: Bkit
      description: bkit.ai 프로덕트
    - key: BKAM
      name: Bkamp
      description: bkamp.ai 프로덕트
  team_members:
    - name: 김태형
      email: taekim@popupstudio.ai
      role: 대표
    - name: 김명일
      email: reinhard@popupstudio.ai
      role: Backend Developer
    - name: 김경호
      email: kay@popupstudio.ai
      role: Developer
    - name: 김용운
      email: koyu@popupstudio.ai
      role: Developer
    - name: 박선영
      email: sypark@popupstudio.ai
      role: Designer
    - name: 이승준
      email: steve@popupstudio.ai
      role: Developer
    - name: 최준호
      email: jack@popupstudio.ai
      role: Developer
    - name: 김민수
      email: mskim@popupstudio.ai
      role: Developer
    - name: 김현진
      email: jacob@popupstudio.ai
      role: Developer
    - name: 이병일
      email: lion@popupstudio.ai
      role: Developer
    - name: 노원대
      email: drwon@popupstudio.ai
      role: Developer
    - name: 황인준
      email: injunh@popupstudio.ai
      role: Developer
---
```

**JQL 쿼리 설계**:

| 쿼리 목적 | JQL |
|----------|-----|
| 이번 주 변경 | `project in ({projects}) AND assignee = "{email}" AND updated >= "{start}" AND updated <= "{end}" ORDER BY updated DESC` |
| 이번 주 완료 | `project in ({projects}) AND assignee = "{email}" AND status changed to Done during ("{start}", "{end}")` |
| 진행 중 | `project in ({projects}) AND assignee = "{email}" AND status in ("In Progress", "진행 중")` |
| 다음 주 예정 | `project in ({projects}) AND assignee = "{email}" AND (status in ("To Do", "Backlog") OR dueDate >= "{next_start}" AND dueDate <= "{next_end}")` |

**이슈 타입 처리**:
```
모든 이슈 타입 포함:
- Epic: 상위 작업 단위
- Story: 기능 단위 작업
- Task: 일반 작업
- Sub-task: 하위 작업
- Bug: 버그 수정
```

#### 2.2.3 Template: `weekly-report.template.md`

**위치**: `.claude/templates/weekly-report.template.md`

**역할**:
- 보고서 출력 형식 정의
- 변수 치환 패턴 제공
- Confluence 호환 마크다운

**템플릿 구조**:
```markdown
# {{report_type}} 주간 업무 보고서

**기간**: {{period_start}} ~ {{period_end}}
**작성일**: {{created_date}}
**대상 프로젝트**: {{projects}}

---

## 팀원별 업무 현황 및 성과

{{#each members}}
### {{name}} ({{role}})

**이번 주 집중 영역:** {{focus_area}}

**주요 성과 (완료 {{completed_count}}건):**
{{#each completed_issues}}
* **{{key}}: {{summary}}** ({{resolution_date}} 완료)
  - {{description}}
{{/each}}

**진행 중인 작업:**
{{#each in_progress_issues}}
* **{{key}}: {{summary}}** - {{status}}
{{/each}}

**다음 주 예정 작업:**
{{#each planned_issues}}
* **{{key}}: {{summary}}** (기한: {{due_date}})
{{/each}}

**칭찬 포인트:**
{{praise_point}}

---
{{/each}}

## 이번 주 전체 주요 진행 사항

### 개발 (Backend)
{{backend_summary}}

### 개발 (Frontend)
{{frontend_summary}}

### QA & UX/UI
{{qa_ux_summary}}

### 기획 & 콘텐츠
{{planning_summary}}

### 비즈니스 & 마케팅
{{business_summary}}

---

## 잘한 점
{{#each good_points}}
{{index}}. {{content}}
{{/each}}

## 아쉬운 점
{{#each improvement_points}}
{{index}}. {{content}}
{{/each}}

---

## 다음 주 ({{next_period}}) 예상 작업

{{#each projects_next_week}}
### {{project_name}} ({{project_key}})
{{#each members_in_project}}
#### {{member_name}} ({{issue_count}}건)
{{#each issues}}
* {{key}}: {{summary}}
{{/each}}
{{/each}}
{{/each}}

---

## 논의 필요 사항

{{#each discussion_items}}
### {{index}}. {{title}}
* **현황**: {{status}}
* **문제점**: {{problem}}
* **제안**: {{suggestion}}
{{/each}}

---

*이 보고서는 Jira {{projects}} 프로젝트의 이슈를 기반으로 {{period_start}} ~ {{period_end}} 기간의 실제 작업을 반영하여 작성되었습니다.*
```

---

## 3. Date Calculation Logic

### 3.1 기간 계산 규칙

```
주간 회의: 매주 월요일
├─ 예시: 2026년 2월 2일 (월) 주간회의
│
├─ 지난주 한 일 (보고 대상 기간)
│   └─ 2026-01-26 (월) 00:00:00 ~ 2026-02-01 (일) 23:59:59
│
└─ 이번 주 할 일 (예정 작업 기간)
    └─ 2026-02-02 (월) 00:00:00 ~ 2026-02-08 (일) 23:59:59
```

### 3.2 날짜 계산 알고리즘

```javascript
function calculateReportPeriod(meetingDate) {
  // meetingDate: 주간회의 날짜 (월요일)

  // 지난주 (보고 대상)
  const lastWeekStart = subtractDays(meetingDate, 7);  // 이전 월요일
  const lastWeekEnd = subtractDays(meetingDate, 1);    // 직전 일요일

  // 이번 주 (예정 작업)
  const thisWeekStart = meetingDate;                   // 회의 당일 월요일
  const thisWeekEnd = addDays(meetingDate, 6);         // 이번 주 일요일

  // Confluence 폴더명 (YYMMDD)
  const folderName = formatDate(meetingDate, 'YYMMDD');

  return {
    lastWeek: { start: lastWeekStart, end: lastWeekEnd },
    thisWeek: { start: thisWeekStart, end: thisWeekEnd },
    folderName: folderName
  };
}
```

### 3.3 날짜 입력 방식

| 입력 방식 | 설명 | 예시 |
|----------|------|------|
| 자동 계산 | 오늘 기준 가장 가까운 월요일 | `/weekly-report` |
| 명시적 지정 | 특정 회의 날짜 지정 | `/weekly-report --date 2026-02-02` |
| 상대 지정 | 지난주/이번주 | `/weekly-report --last-week` |

---

## 4. Data Flow Design

### 4.1 전체 데이터 흐름

```
┌──────────────────────────────────────────────────────────────────┐
│                         User Request                              │
│                  /weekly-report [project] [mode]                  │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             v
┌──────────────────────────────────────────────────────────────────┐
│                    Skill: weekly-report.md                        │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ 1. Parse parameters                                         │  │
│  │ 2. Calculate date period                                    │  │
│  │ 3. Load agent configuration                                 │  │
│  └────────────────────────────────────────────────────────────┘  │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             v
┌──────────────────────────────────────────────────────────────────┐
│                    Agent: jira-collector.md                       │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ For each team member:                                       │  │
│  │   - Query PS, BK, BKIT, BKAM projects                      │  │
│  │   - Collect updated/completed/in-progress/planned issues   │  │
│  │   - Include all issue types (Epic, Story, Task, Sub-task)  │  │
│  └────────────────────────────────────────────────────────────┘  │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             v
┌──────────────────────────────────────────────────────────────────┐
│                   Collected Data (JSON)                           │
│  {                                                                │
│    "period": { "start": "...", "end": "..." },                   │
│    "members": [                                                   │
│      { "name": "...", "completed": [...], "in_progress": [...] } │
│    ]                                                              │
│  }                                                                │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             v
┌──────────────────────────────────────────────────────────────────┐
│               Template: weekly-report.template.md                 │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Apply template with collected data                          │  │
│  │ Generate markdown report                                    │  │
│  └────────────────────────────────────────────────────────────┘  │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             v
┌──────────────────────────────────────────────────────────────────┐
│                    Output Options                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐   │
│  │   Confluence    │  │   Local File    │  │    Console      │   │
│  │   (Default)     │  │   (--local)     │  │   (--preview)   │   │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

### 4.2 JSON 데이터 스키마

```json
{
  "$schema": "weekly-report-data",
  "version": "2.0.0",
  "metadata": {
    "generated_at": "2026-02-01T21:00:00+09:00",
    "report_type": "team",
    "projects": ["PS", "BK", "BKIT", "BKAM"]
  },
  "period": {
    "last_week": {
      "start": "2026-01-26",
      "end": "2026-02-01"
    },
    "this_week": {
      "start": "2026-02-02",
      "end": "2026-02-08"
    },
    "meeting_date": "2026-02-02",
    "folder_name": "260202"
  },
  "members": [
    {
      "name": "김태형",
      "email": "taekim@popupstudio.ai",
      "role": "대표",
      "statistics": {
        "completed_count": 5,
        "in_progress_count": 3,
        "planned_count": 4
      },
      "completed_issues": [
        {
          "key": "BK-123",
          "summary": "API 엔드포인트 구현",
          "project": "BK",
          "type": "Story",
          "resolution_date": "2026-01-30",
          "description": "사용자 인증 API 구현 완료"
        }
      ],
      "in_progress_issues": [...],
      "planned_issues": [...],
      "reported_issues": [...]
    }
  ],
  "summary": {
    "total_completed": 45,
    "total_in_progress": 23,
    "total_planned": 38,
    "by_project": {
      "PS": { "completed": 10, "in_progress": 5 },
      "BK": { "completed": 20, "in_progress": 10 },
      "BKIT": { "completed": 8, "in_progress": 4 },
      "BKAM": { "completed": 7, "in_progress": 4 }
    }
  }
}
```

---

## 5. Implementation Tasks

### 5.1 Task Breakdown

| # | Task | Description | Priority | Dependency |
|---|------|-------------|----------|------------|
| 1 | Create folders | `.claude/agents/`, `.claude/templates/` 폴더 생성 | High | - |
| 2 | Create skill | `skills/weekly-report.md` 작성 | High | 1 |
| 3 | Create agent | `agents/jira-collector.md` 작성 | High | 1 |
| 4 | Create template | `templates/weekly-report.template.md` 작성 | High | 1 |
| 5 | Update script | `scripts/collect-jira-issues.py` BKIT 프로젝트 추가 | Medium | - |
| 6 | Deprecate command | `commands/weekly-report.md` 마이그레이션 안내 추가 | Low | 2,3,4 |
| 7 | Test & Validate | 전체 흐름 테스트 | High | 2,3,4,5 |

### 5.2 Implementation Order

```
Phase 1: Infrastructure (Day 1)
├─ Task 1: Create folders
└─ Task 5: Update Python script

Phase 2: Core Components (Day 1-2)
├─ Task 3: Create jira-collector agent
├─ Task 4: Create template
└─ Task 2: Create skill

Phase 3: Integration (Day 2)
├─ Task 6: Deprecate old command
└─ Task 7: Test & Validate
```

---

## 6. File Specifications

### 6.1 `.claude/skills/weekly-report.md` (Full Specification)

```markdown
---
name: weekly-report
description: |
  주간 업무 보고서를 생성합니다.
  Jira 이슈를 기반으로 팀 전체 또는 개인의 주간 업무 보고서를 작성하고 Confluence에 저장합니다.
version: 2.0.0
triggers:
  - weekly report
  - weekly-report
  - 주간 보고서
  - 주간 업무 보고서
agents:
  - jira-collector
templates:
  - weekly-report
parameters:
  - name: project
    type: string
    description: "Jira 프로젝트 키 (PS, BK, BKIT, BKAM). 없으면 전체"
    required: false
  - name: mode
    type: enum
    values: [team, me]
    default: team
    description: "보고서 유형"
  - name: date
    type: string
    description: "회의 날짜 (YYYY-MM-DD). 없으면 다음 월요일"
    required: false
---

# Weekly Report Skill

## 실행 절차

### Step 1: 기간 확인

회의 날짜를 기준으로 보고 기간을 계산합니다.

**계산 규칙:**
- 지난주 한 일: `{회의일 - 7일} 00:00` ~ `{회의일 - 1일} 23:59`
- 이번 주 할 일: `{회의일} 00:00` ~ `{회의일 + 6일} 23:59`
- 폴더명: `YYMMDD` 형식 (회의일 기준)

### Step 2: Confluence 폴더 확인

1. Space: `POPUPSTUDI`
2. Parent Folder ID: `7208961`
3. 날짜 폴더 검색 및 확인

### Step 3: Agent 호출

`jira-collector` Agent를 호출하여 데이터를 수집합니다.

**전달 파라미터:**
- `projects`: 대상 프로젝트 (기본: PS, BK, BKIT, BKAM)
- `period`: 계산된 기간 정보
- `mode`: team 또는 me

### Step 4: 보고서 생성

`weekly-report` Template을 적용하여 보고서를 생성합니다.

### Step 5: Confluence 저장

생성된 보고서를 Confluence에 저장합니다.
- Page Title: `{mode} 주간 업무 보고서 ({period_start} ~ {period_end})`
- Parent: 날짜 폴더
```

### 6.2 `.claude/agents/jira-collector.md` (Full Specification)

```markdown
---
name: jira-collector
description: Jira 프로젝트에서 주간 이슈 데이터를 수집하는 Agent
version: 1.0.0
type: data-collector
tools:
  - mcp__mcp-atlassian__jira_search
  - mcp__mcp-atlassian__jira_get_issue
config:
  projects:
    PS:
      name: POPUP-STUDIO
      description: 회사 공용 및 기타 업무
    BK:
      name: Bkend
      description: bkend.ai 프로덕트 개발
    BKIT:
      name: Bkit
      description: bkit.ai 프로덕트 개발
    BKAM:
      name: Bkamp
      description: bkamp.ai 프로덕트 개발
  team_members:
    - { name: "김태형", email: "taekim@popupstudio.ai", role: "대표" }
    - { name: "김명일", email: "reinhard@popupstudio.ai", role: "Backend Developer" }
    - { name: "김경호", email: "kay@popupstudio.ai", role: "Developer" }
    - { name: "김용운", email: "koyu@popupstudio.ai", role: "Developer" }
    - { name: "박선영", email: "sypark@popupstudio.ai", role: "Designer" }
    - { name: "이승준", email: "steve@popupstudio.ai", role: "Developer" }
    - { name: "최준호", email: "jack@popupstudio.ai", role: "Developer" }
    - { name: "김민수", email: "mskim@popupstudio.ai", role: "Developer" }
    - { name: "김현진", email: "jacob@popupstudio.ai", role: "Developer" }
    - { name: "이병일", email: "lion@popupstudio.ai", role: "Developer" }
    - { name: "노원대", email: "drwon@popupstudio.ai", role: "Developer" }
    - { name: "황인준", email: "injunh@popupstudio.ai", role: "Developer" }
  issue_types:
    - Epic
    - Story
    - Task
    - Sub-task
    - Bug
  fields:
    - summary
    - status
    - issuetype
    - priority
    - updated
    - resolutiondate
    - duedate
    - project
    - assignee
    - reporter
    - parent
    - description
---

# Jira Collector Agent

## 수집 방법

각 팀원에 대해 다음 JQL 쿼리를 순차적으로 실행합니다.

### Query 1: 이번 주 변경된 이슈

```jql
project in ({{projects}})
AND assignee = "{{email}}"
AND updated >= "{{period.start}}"
AND updated <= "{{period.end}}"
ORDER BY project ASC, updated DESC
```

### Query 2: 이번 주 완료된 이슈

```jql
project in ({{projects}})
AND assignee = "{{email}}"
AND status changed to Done during ("{{period.start}}", "{{period.end}}")
ORDER BY project ASC, resolutiondate DESC
```

### Query 3: 현재 진행 중인 이슈

```jql
project in ({{projects}})
AND assignee = "{{email}}"
AND status in ("In Progress", "진행 중")
ORDER BY project ASC, priority DESC
```

### Query 4: 다음 주 예정 작업

```jql
project in ({{projects}})
AND assignee = "{{email}}"
AND (
  status in ("To Do", "Backlog", "Open", "해야 할 일")
  OR (dueDate >= "{{next_period.start}}" AND dueDate <= "{{next_period.end}}")
)
ORDER BY project ASC, priority DESC, dueDate ASC
```

### Query 5: 본인이 생성한 이슈

```jql
project in ({{projects}})
AND reporter = "{{email}}"
AND updated >= "{{period.start}}"
AND updated <= "{{period.end}}"
AND assignee != "{{email}}"
ORDER BY project ASC, updated DESC
```

## 출력 형식

수집된 데이터는 JSON 형식으로 반환됩니다.
상세 스키마는 Design Document의 4.2 JSON Data Schema 참조.
```

---

## 7. Migration Plan

### 7.1 기존 Command Deprecation

`commands/weekly-report.md` 파일 상단에 다음 내용 추가:

```markdown
> **DEPRECATED**: 이 명령어는 v2.0.0에서 skill로 마이그레이션되었습니다.
> 새로운 사용법: `/weekly-report [project] [mode]`
>
> Migration Guide:
> - 기존: `/weekly-report team` → 새로운: `/weekly-report`
> - 기존: `/weekly-report me` → 새로운: `/weekly-report --mode me`
> - 새로운 기능: `/weekly-report BK` (특정 프로젝트만)
```

### 7.2 Python Script Update

`scripts/collect-jira-issues.py` 수정 사항:

```python
# Before
PROJECTS = ["PS", "BK", "BKAM"]

# After
PROJECTS = ["PS", "BK", "BKIT", "BKAM"]
```

---

## 8. Acceptance Criteria

### 8.1 Functional Requirements

- [ ] 4개 프로젝트 (PS, BK, BKIT, BKAM) 모두 조회 가능
- [ ] 기간이 월요일 기준으로 정확하게 계산됨
- [ ] 모든 이슈 타입 (Epic, Story, Task, Sub-task, Bug) 포함
- [ ] 팀원 추가/삭제가 Agent 설정만으로 가능
- [ ] 특정 프로젝트만 지정하여 보고서 생성 가능
- [ ] Confluence에 정상적으로 저장됨

### 8.2 Non-Functional Requirements

- [ ] Context 사용량 50% 이상 감소 (기존 대비)
- [ ] 응답 시간 2분 이내 (전체 팀 보고서 기준)
- [ ] 기존 보고서 양식과 동일한 출력

---

## 9. Appendix

### 9.1 Confluence Structure

- **Space Key**: POPUPSTUDI
- **Parent Folder ID**: 7208961
- **Folder URL**: https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/folder/7208961
- **Template Reference**: https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/pages/33062951

### 9.2 Related Documents

- 기존 Command: `.claude/commands/weekly-report.md`
- Jira Rules: `.claude/instructions/jira-rules.md`
- Python Script: `.claude/scripts/collect-jira-issues.py`
