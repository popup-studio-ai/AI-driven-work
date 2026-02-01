---
name: jira-collector
description: Jira 단일 프로젝트에서 주간 이슈 데이터를 수집하는 Agent (병렬 실행 지원)
version: 2.0.0
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
  - mcp__mcp-atlassian__jira_search
  - mcp__mcp-atlassian__jira_get_issue
  - mcp__mcp-atlassian__jira_get_project_issues
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

## 역할

- MCP를 통한 Jira 데이터 수집 (단일 프로젝트)
- 팀원별 이슈 분류
- 구조화된 JSON 데이터 반환

---

## 수집 방법

**prompt에서 전달받은 단일 프로젝트({project})에 대해** 각 팀원의 JQL 쿼리를 실행합니다.

### Query 1: 이번 주 변경된 이슈 (담당자 기준)

```jql
project = "{project}"
AND assignee = "{email}"
AND updated >= "{period.last_week.start}"
AND updated < "{period.last_week.end_exclusive}"
ORDER BY updated DESC
```

> **JQL 날짜 조건 주의:**
> - `<= "2026-02-01"` → 2026-02-01 **00:00:00**까지만 포함 (오후 이슈 누락!)
> - `< "2026-02-02"` → 2026-02-01 **23:59:59**까지 포함 (올바름)
> - `period.last_week.end_exclusive` = last_week.end + 1일

**목적**: 해당 기간에 활동한 모든 이슈 파악 (상태/내용 변경 포함)

### Query 2: 이번 주 완료된 이슈

```jql
project = "{project}"
AND assignee = "{email}"
AND status changed to Done during ("{period.last_week.start}", "{period.last_week.end}")
ORDER BY resolutiondate DESC
```

**목적**: 이번 주 Done으로 전환된 이슈만 추출

### Query 3: 현재 진행 중인 이슈

```jql
project = "{project}"
AND assignee = "{email}"
AND status in ("In Progress", "진행 중")
ORDER BY priority DESC, updated DESC
```

**목적**: 아직 완료되지 않은 진행 중 작업

### Query 4: 다음 주 예정 작업

```jql
project = "{project}"
AND assignee = "{email}"
AND (
  status in ("To Do", "Backlog", "Open", "해야 할 일")
  OR (dueDate >= "{period.this_week.start}" AND dueDate <= "{period.this_week.end}")
)
ORDER BY priority DESC, dueDate ASC
```

**목적**: To Do 상태이거나 다음 주 기한인 이슈

### Query 5: 본인이 생성한 이슈 (reporter)

```jql
project = "{project}"
AND reporter = "{email}"
AND updated >= "{period.last_week.start}"
AND updated < "{period.last_week.end_exclusive}"
AND assignee != "{email}"
ORDER BY updated DESC
```

**목적**: 다른 사람에게 할당했지만 본인이 생성한 이슈

---

## MCP 호출 설정

### jira_search 호출 시 필수 설정

```json
{
  "jql": "{위 JQL 쿼리}",
  "limit": 50,
  "fields": "summary,status,issuetype,priority,updated,resolutiondate,duedate,project,assignee,reporter,parent,description"
}
```

### 이슈 상세 조회 (필요시)

```json
{
  "issue_key": "{이슈키}",
  "fields": "summary,status,priority,assignee,reporter,created,updated,resolutiondate,duedate,description,issuetype,parent",
  "expand": "changelog"
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
    "last_week": {
      "start": "2026-01-26",
      "end": "2026-02-01",
      "end_exclusive": "2026-02-02"
    },
    "this_week": {
      "start": "2026-02-02",
      "end": "2026-02-08",
      "end_exclusive": "2026-02-09"
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

1. **limit: 50**: 모든 이슈를 포착하기 위해 충분한 limit 설정
2. **단일 프로젝트 처리**: prompt에서 전달받은 project만 조회
3. **병렬 실행**: Skill에서 4개 Agent를 병렬로 호출하여 속도 향상
4. **updated 필드 중심**: dueDate가 없어도 updated로 이슈 포착
5. **상태 변경 확인**: changelog로 상태 전환 이력 파악
6. **실제 데이터만**: Jira에 없는 내용은 추정하지 않음
