---
name: weekly-report
description: |
  주간 업무 보고서를 생성합니다.
  Jira 이슈를 기반으로 팀 전체 또는 개인의 주간 업무 보고서를 작성하고 Confluence에 저장합니다.
version: 2.2.0
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
    description: "회의 날짜 (YYYY-MM-DD). 없으면 이번/다음 금요일"
    required: false
---

# Weekly Report Skill v2.2.0

주간 업무 보고서를 생성하는 스킬입니다. Jira 이슈를 기반으로 팀 전체 또는 개인의 주간 업무 보고서를 작성합니다.

## 파라미터

| 파라미터 | 설명 | 기본값 |
|---------|------|--------|
| `$ARGUMENTS` | 프로젝트 키 또는 모드 | 전체 프로젝트, team 모드 |

**사용 예시:**
- `/weekly-report` - 전체 프로젝트 팀 보고서
- `/weekly-report BK` - BK 프로젝트만
- `/weekly-report me` - 개인 보고서
- `/weekly-report BK me` - BK 프로젝트 개인 보고서

---

## 실행 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│  Skill: /weekly-report                                       │
│  (Orchestrator - 전체 흐름 제어)                              │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 1-2: 기간 계산 & Confluence 폴더 확인                  │
│  (Skill에서 직접 처리)                                       │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  PS Agent   │     │  BK Agent   │     │ BKIT Agent  │  ... (병렬)
│  (Task 1)   │     │  (Task 2)   │     │  (Task 3)   │
└─────────────┘     └─────────────┘     └─────────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 3.5: 결과 병합 (프로젝트별 → 팀원별)                   │
│  (Skill에서 직접 처리)                                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 4-5: Template 적용 & Confluence 저장                   │
│  (Skill에서 직접 처리)                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 실행 절차

### Step 1: 기간 계산

회의 날짜를 기준으로 보고 기간을 계산합니다.

**계산 규칙 (금요일 기준):**

```
주간 회의: 매주 금요일
├─ 이번주 한 일 (보고 대상 기간)
│   └─ {회의주 월요일} (월) 00:00:00 ~ {회의일} (금) 23:59:59
│
└─ 차주 할 일 (예정 작업 기간)
    └─ {회의일 + 3일} (월) 00:00:00 ~ {회의일 + 7일} (금) 23:59:59
```

**예시 (2026년 4월 10일 금요일 회의):**
- 이번주 한 일: 2026-04-06 (월) ~ 2026-04-10 (금)
- 차주 할 일: 2026-04-13 (월) ~ 2026-04-17 (금)
- Confluence 폴더명: `260410`

### Step 2: Confluence 폴더 확인

1. **Space**: `POPUPSTUDI`
2. **Parent Folder ID**: `7208961`
3. **폴더 URL**: https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/folder/7208961

날짜 폴더 검색:
```
confluence_search: space = "POPUPSTUDI" AND title = "{YYMMDD}"
```

- 폴더가 있으면: 해당 폴더 ID를 parent_id로 사용
- 폴더가 없으면: 사용자에게 Confluence UI에서 폴더 생성 요청

### Step 3: Jira 데이터 수집 (병렬 Agent 호출)

**IMPORTANT: Agent tool을 사용하여 프로젝트별로 병렬 호출합니다.**

> **🚨 subagent_type을 사용하지 마세요.** MCP 도구(claude.ai Atlassian)는 deferred tool이라
> ToolSearch로 먼저 스키마를 로드해야 합니다. subagent_type: "jira-collector"는 ToolSearch가 없어서
> MCP 도구를 실행할 수 없습니다. 반드시 general-purpose Agent(subagent_type 생략)를 사용하세요.

#### 병렬 호출 방식

**하나의 메시지에서 Agent tool을 동시에 호출합니다:**

```
# 전체 프로젝트 조회 시 (파라미터 없음)
Agent 호출 1: { description: "Jira PS 이슈 수집", prompt: "..." }
Agent 호출 2: { description: "Jira BK 이슈 수집", prompt: "..." }
Agent 호출 3: { description: "Jira BKIT 이슈 수집", prompt: "..." }
Agent 호출 4: { description: "Jira BKAM 이슈 수집", prompt: "..." }

# 특정 프로젝트만 조회 시 (예: /weekly-report BK)
Agent 호출 1: { description: "Jira BK 이슈 수집", prompt: "..." }
```

#### 각 Agent 호출 형식 (prompt 내용)

```
Agent tool 호출:
  description: "Jira {project} 프로젝트 이슈 수집"
  run_in_background: true
  prompt: |
    주간 보고서를 위한 Jira 이슈를 수집해주세요.

    ## Step 0: MCP 도구 로드 (필수!)
    먼저 ToolSearch를 사용하여 MCP 도구 스키마를 로드하세요:
    ToolSearch({ query: "select:mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql", max_results: 1 })

    ## Step 1: JQL 쿼리 실행
    로드된 mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql 도구를 사용하여 아래 쿼리를 실행하세요.
    - cloudId: "popupstudio.atlassian.net"
    - maxResults: 50
    - fields: ["summary", "status", "issuetype", "priority", "updated", "resolutiondate", "duedate", "project", "assignee", "reporter", "parent", "description"]

    ## 수집 조건
    - 프로젝트: {project} (단일 프로젝트)
    - 이번주 기간: {this_week_start} ~ {this_week_end} (end_exclusive: {this_week_end + 1일})
    - 차주 기간: {next_week_start} ~ {next_week_end}

    ## JQL 쿼리 (3개 실행)
    1. 이번주 업데이트: project = "{project}" AND updated >= "{this_week_start}" AND updated < "{this_week_end_exclusive}" ORDER BY updated DESC
    2. 진행 중: project = "{project}" AND status in ("In Progress", "진행 중") ORDER BY priority DESC
    3. 차주 예정: project = "{project}" AND (status in ("To Do", "Backlog", "Open", "해야 할 일") OR (dueDate >= "{next_week_start}" AND dueDate <= "{next_week_end}")) ORDER BY priority DESC

    ## 출력 형식
    팀원별로 분류하여 key, summary, status, assignee, issuetype, priority, updated를 포함한 JSON으로 반환하세요.
    🚨 절대로 데이터를 추정하거나 생성하지 마세요. MCP 도구 호출 결과만 사용하세요.
```

**참고 문서**: `.claude/agents/jira-collector.md` (JQL 쿼리 상세, 출력 스키마)

> **JQL 날짜 조건 주의사항:**
> - `<= "2026-02-01"` → 2026-02-01 00:00:00까지만 포함 (오후 이슈 누락!)
> - `< "2026-02-02"` → 2026-02-01 23:59:59까지 포함 (올바름)

### Step 3.5: 결과 병합

각 프로젝트별 Agent 결과를 팀원 중심으로 병합합니다.

**병합 규칙:**
1. 동일 팀원의 이슈를 모든 프로젝트에서 수집
2. 프로젝트별 통계 집계
3. 중복 이슈 제거 (같은 이슈가 여러 쿼리에서 반환될 수 있음)

```json
{
  "members": [
    {
      "name": "김태형",
      "projects": {
        "PS": { "completed": [...], "in_progress": [...] },
        "BK": { "completed": [...], "in_progress": [...] },
        "BKIT": { "completed": [...], "in_progress": [...] },
        "BKAM": { "completed": [...], "in_progress": [...] }
      }
    }
  ]
}
```

### Step 4: 보고서 생성

`weekly-report` Template을 적용하여 보고서를 생성합니다.

**Template 참조**: `.claude/templates/weekly-report.template.md`

### Step 5: Confluence 저장

생성된 보고서를 Confluence에 저장합니다.

```
confluence_create_page:
  space_key: "POPUPSTUDI"
  title: "{mode} 주간 업무 보고서 ({period_start} ~ {period_end})"
  parent_id: "{날짜폴더 page_id}"
  content: {작성한 보고서}
  content_format: "markdown"
```

---

## 프로젝트 정보

| 프로젝트 키 | 프로젝트명 | 설명 |
|------------|-----------|------|
| PS | POPUP-STUDIO | 회사 공용 및 기타 업무 |
| BK | Bkend | bkend.ai 프로덕트 개발 |
| BKIT | Bkit | bkit.ai 프로덕트 개발 |
| BKAM | Bkamp | bkamp.ai 프로덕트 개발 |

---

## 팀원 정보

| 이름 | 이메일 | 역할 |
|------|--------|------|
| 김태형 | taekim@popupstudio.ai | 대표 |
| 이승준 | steve@popupstudio.ai | CSO |
| 김명일 | reinhard@popupstudio.ai | CTO |
| 김경호 | kay@popupstudio.ai | CIO |
| 김용운 | koyu@popupstudio.ai | bkamp PO |
| 박선영 | sypark@popupstudio.ai | bkend PO |
| 최준호 | jack@popupstudio.ai | Contents |
| 김민수 | mskim@popupstudio.ai | Operator |
| 김현진 | jacob@popupstudio.ai | Developer |
| 이병일 | lion@popupstudio.ai | Operator |
| 노원대 | drwon@popupstudio.ai | 공동대표 |
| 황인준 | injunh@popupstudio.ai | Developer |

---

## 주의사항

1. **모든 프로젝트 조회**: 파라미터가 없으면 PS, BK, BKIT, BKAM 4개 프로젝트 모두 조회
2. **모든 이슈 타입 포함**: Epic, Story, Task, Sub-task, Bug 모두 포함
3. **updated 필드 중심**: dueDate가 없어도 updated로 이슈 포착
4. **실제 데이터만**: Jira에 없는 내용은 추정하지 않음
5. **한 사람 여러 프로젝트**: 팀원이 여러 프로젝트에서 작업할 수 있음
