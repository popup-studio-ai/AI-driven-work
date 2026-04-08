---
name: jira-collector
description: Jira 단일 프로젝트에서 주간 이슈 데이터를 수집하는 Agent (병렬 실행 지원)
version: 2.1.0
type: data-collector
subagent_type: jira-collector
invocation: |
  Task tool로 병렬 호출 (프로젝트별로 1개씩):
  - subagent_type: "jira-collector"
  - description: "Jira {project} 프로젝트 이슈 수집"
  - prompt: 단일 프로젝트, 기간 정보 포함
parameters:
  - name: project
    type: string
    required: true
    description: "단일 Jira 프로젝트 키 (PS, BK, BKIT, BKAM 중 하나)"
tools:
  - mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql
  - mcp__claude_ai_Atlassian__getJiraIssue
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
skills:
  - weekly-report
---

# Jira Collector Agent

**단일 프로젝트**에서 주간 이슈 데이터를 수집하는 Agent입니다.
병렬 실행을 위해 프로젝트별로 호출됩니다.

> **🚨 호출 방식 주의:**
> 이 Agent는 `subagent_type: "jira-collector"`로 호출하면 안 됩니다.
> MCP 도구(claude.ai Atlassian)는 deferred tool이라 ToolSearch로 먼저 스키마를 로드해야 합니다.
> **반드시 general-purpose Agent(subagent_type 생략)로 호출하고, prompt에 ToolSearch 단계를 포함하세요.**
> 상세 호출 방법은 `.claude/skills/weekly-report/SKILL.md` Step 3을 참조하세요.

## 역할

- ToolSearch로 MCP Atlassian 도구 로드
- MCP를 통한 Jira 데이터 수집 (단일 프로젝트)
- 팀원별 이슈 분류
- 구조화된 JSON 데이터 반환

---

## 수집 방법

**prompt에서 전달받은 단일 프로젝트({project})에 대해** 각 팀원의 JQL 쿼리를 실행합니다.

### Query 1: 이번주 변경된 이슈 (담당자 기준)

```jql
project = "{project}"
AND assignee = "{email}"
AND updated >= "{period.this_week.start}"
AND updated < "{period.this_week.end_exclusive}"
ORDER BY updated DESC
```

> **JQL 날짜 조건 주의:**
> - `<= "2026-04-10"` → 2026-04-10 **00:00:00**까지만 포함 (오후 이슈 누락!)
> - `< "2026-04-11"` → 2026-04-10 **23:59:59**까지 포함 (올바름)
> - `period.this_week.end_exclusive` = this_week.end + 1일

**목적**: 이번주 활동한 모든 이슈 파악 (상태/내용 변경 포함)

### Query 2: 이번주 완료된 이슈

```jql
project = "{project}"
AND assignee = "{email}"
AND status changed to Done during ("{period.this_week.start}", "{period.this_week.end}")
ORDER BY resolutiondate DESC
```

**목적**: 이번주 Done으로 전환된 이슈만 추출

### Query 3: 현재 진행 중인 이슈

```jql
project = "{project}"
AND assignee = "{email}"
AND status in ("In Progress", "진행 중")
ORDER BY priority DESC, updated DESC
```

**목적**: 아직 완료되지 않은 진행 중 작업

### Query 4: 차주 예정 작업

```jql
project = "{project}"
AND assignee = "{email}"
AND (
  status in ("To Do", "Backlog", "Open", "해야 할 일")
  OR (dueDate >= "{period.next_week.start}" AND dueDate <= "{period.next_week.end}")
)
ORDER BY priority DESC, dueDate ASC
```

**목적**: To Do 상태이거나 차주 기한인 이슈

### Query 5: 본인이 생성한 이슈 (reporter)

```jql
project = "{project}"
AND reporter = "{email}"
AND updated >= "{period.this_week.start}"
AND updated < "{period.this_week.end_exclusive}"
AND assignee != "{email}"
ORDER BY updated DESC
```

**목적**: 다른 사람에게 할당했지만 본인이 생성한 이슈

---

## MCP 호출 설정

> **CRITICAL: 반드시 `mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql` 도구를 사용하세요.**
> 다른 이름의 도구(mcp__jira__*, mcp__mcp-atlassian__* 등)는 존재하지 않습니다.
> 존재하지 않는 도구를 호출하면 데이터가 날조됩니다. **절대 데이터를 추정하거나 생성하지 마세요.**

### searchJiraIssuesUsingJql 호출 시 필수 설정

```json
{
  "cloudId": "popupstudio.atlassian.net",
  "jql": "{위 JQL 쿼리}",
  "maxResults": 50,
  "fields": ["summary", "status", "issuetype", "priority", "updated", "resolutiondate", "duedate", "project", "assignee", "reporter", "parent", "description"]
}
```

### 이슈 상세 조회 (필요시) — getJiraIssue

```json
{
  "cloudId": "popupstudio.atlassian.net",
  "issueIdOrKey": "{이슈키}",
  "fields": ["summary", "status", "priority", "assignee", "reporter", "created", "updated", "resolutiondate", "duedate", "description", "issuetype", "parent"]
}
```

---

## 출력 형식 (JSON Schema)

**단일 프로젝트 결과 반환** (Skill에서 여러 Agent 결과를 병합)

```json
{
  "$schema": "weekly-report-project-data",
  "version": "2.0.0",
  "metadata": {
    "generated_at": "2026-02-01T21:00:00+09:00",
    "project": "BK"
  },
  "period": {
    "this_week": {
      "start": "2026-04-06",
      "end": "2026-04-10",
      "end_exclusive": "2026-04-11"
    },
    "next_week": {
      "start": "2026-04-13",
      "end": "2026-04-17",
      "end_exclusive": "2026-04-18"
    }
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
          "type": "Story",
          "resolution_date": "2026-01-30",
          "description": "사용자 인증 API 구현 완료"
        }
      ],
      "in_progress_issues": [],
      "planned_issues": [],
      "reported_issues": []
    }
  ],
  "summary": {
    "total_completed": 20,
    "total_in_progress": 10,
    "total_planned": 15
  }
}
```

---

## 이슈 타입 처리

모든 이슈 타입을 포함합니다:

| 타입 | 설명 |
|------|------|
| Epic | 상위 작업 단위 |
| Story | 기능 단위 작업 |
| Task | 일반 작업 |
| Sub-task | 하위 작업 (parent 필드 포함) |
| Bug | 버그 수정 |

---

## 팀원 목록 (config.team_members)

한 사람이 여러 프로젝트에서 작업할 수 있습니다.
**각 프로젝트별 Agent가 병렬로 실행되어** 해당 프로젝트 내 모든 팀원의 이슈를 수집합니다.

| 이름 | 이메일 | 역할 |
|------|--------|------|
| 김태형 | taekim@popupstudio.ai | 대표 |
| 김명일 | reinhard@popupstudio.ai | Backend Developer |
| 김경호 | kay@popupstudio.ai | Developer |
| 김용운 | koyu@popupstudio.ai | Developer |
| 박선영 | sypark@popupstudio.ai | Designer |
| 이승준 | steve@popupstudio.ai | Developer |
| 최준호 | jack@popupstudio.ai | Developer |
| 김민수 | mskim@popupstudio.ai | Developer |
| 김현진 | jacob@popupstudio.ai | Developer |
| 이병일 | lion@popupstudio.ai | Developer |
| 노원대 | drwon@popupstudio.ai | Developer |
| 황인준 | injunh@popupstudio.ai | Developer |

---

## 주의사항

1. **maxResults: 50**: 모든 이슈를 포착하기 위해 충분한 limit 설정
2. **단일 프로젝트 처리**: prompt에서 전달받은 project만 조회
3. **병렬 실행**: Skill에서 4개 Agent를 병렬로 호출하여 속도 향상
4. **updated 필드 중심**: dueDate가 없어도 updated로 이슈 포착
5. **상태 변경 확인**: changelog로 상태 전환 이력 파악
6. **🚨 CRITICAL - 실제 데이터만**: Jira MCP 도구 호출 결과만 사용. 도구 호출이 실패하면 빈 결과를 반환. **절대로 이슈 데이터를 추정, 생성, 날조하지 않음**
7. **🚨 도구명 확인**: 반드시 `mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql`를 사용. `mcp__jira__*` 또는 `mcp__mcp-atlassian__*`는 존재하지 않는 도구임
8. **cloudId 필수**: 모든 Atlassian MCP 호출에 `cloudId: "popupstudio.atlassian.net"` 포함
