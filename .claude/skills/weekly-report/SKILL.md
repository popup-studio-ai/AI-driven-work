---
name: weekly-report
description: |
  주간 업무 보고서를 생성합니다.
  Jira 이슈를 기반으로 팀 전체 또는 개인의 주간 업무 보고서를 작성하고 Confluence에 저장합니다.
version: 2.1.0
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

# Weekly Report Skill v2.1.0

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

**계산 규칙 (월요일 기준):**

```
주간 회의: 매주 월요일
├─ 지난주 한 일 (보고 대상 기간)
│   └─ {회의일 - 7일} (월) 00:00:00 ~ {회의일 - 1일} (일) 23:59:59
│
└─ 이번 주 할 일 (예정 작업 기간)
    └─ {회의일} (월) 00:00:00 ~ {회의일 + 6일} (일) 23:59:59
```

**예시 (2026년 2월 2일 월요일 회의):**
- 지난주 한 일: 2026-01-26 (월) ~ 2026-02-01 (일)
- 이번 주 할 일: 2026-02-02 (월) ~ 2026-02-08 (일)
- Confluence 폴더명: `260202`

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

**IMPORTANT: Task tool을 사용하여 프로젝트별로 jira-collector Agent를 병렬 호출합니다.**

#### 병렬 호출 방식

**하나의 메시지에서 4개의 Task tool을 동시에 호출합니다:**

```
# 전체 프로젝트 조회 시 (파라미터 없음)
Task tool 호출 1: { subagent_type: "jira-collector", project: "PS", ... }
Task tool 호출 2: { subagent_type: "jira-collector", project: "BK", ... }
Task tool 호출 3: { subagent_type: "jira-collector", project: "BKIT", ... }
Task tool 호출 4: { subagent_type: "jira-collector", project: "BKAM", ... }

# 특정 프로젝트만 조회 시 (예: /weekly-report BK)
Task tool 호출 1: { subagent_type: "jira-collector", project: "BK", ... }
```

#### 각 Agent 호출 형식

```
Task tool 호출:
  subagent_type: "jira-collector"
  description: "Jira {project} 프로젝트 이슈 수집"
  prompt: |
    주간 보고서를 위한 Jira 이슈를 수집해주세요.

    ## 수집 조건
    - 프로젝트: {project} (단일 프로젝트)
    - 지난주 기간: {last_week_start} ~ {last_week_end}
    - 이번주 기간: {this_week_start} ~ {this_week_end}

    ## 수집 항목
    1. 지난주 완료된 이슈 (status = 완료)
    2. 지난주 업데이트된 이슈 (updated 기준)
    3. 현재 진행 중인 이슈
    4. 다음 주 예정 작업 (To Do, 해야 할 일)

    ## 출력 형식
    JSON 형식으로 팀원별 이슈 데이터를 반환해주세요.
```

**Agent 정의**: `.claude/agents/jira-collector.md`

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
