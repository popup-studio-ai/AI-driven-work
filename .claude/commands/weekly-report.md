# Weekly Report Command

주간 보고서를 생성합니다. Jira 이슈를 기반으로 팀 전체 또는 개인의 주간 업무 보고서를 작성하고 Confluence에 저장합니다.

## 파라미터

- `$ARGUMENTS`: 보고서 유형
  - `team` 또는 빈 값: 팀 전체 주간 업무 보고서
  - `me` 또는 `개인`: 개인 주간 업무 보고서

---

## 회사 인원 목록 (12명)

| 이름 | 이메일 |
|------|--------|
| 김태형 | taekim@popupstudio.ai |
| 김명일 | reinhard@popupstudio.ai |
| 김경호 | kay@popupstudio.ai |
| 김용운 | koyu@popupstudio.ai |
| 박선영 | sypark@popupstudio.ai |
| 이승준 | steve@popupstudio.ai |
| 최준호 | jack@popupstudio.ai |
| 김민수 | mskim@popupstudio.ai |
| 김현진 | jacob@popupstudio.ai |
| 이병일 | lion@popupstudio.ai |
| 노원대 | drwon@popupstudio.ai |
| 황인준 | injunh@popupstudio.ai |

**⚠️ 중요**: 한 사람이 여러 프로젝트에서 작업 가능 → PS, BK, BKAM 모두 조회 필수

---

## 우리 회사 Jira 규칙

1. **스토리(Story) 중심** 작업 관리
2. **기한(dueDate) 필수** - 하지만 모든 사람이 제대로 안 할 수 있음
3. **주간 업무 보고 기간**: 월요일 ~ 일요일
4. **Jira 업데이트 마감**: 매주 일요일 21시 (한국 시간)

### 주간 업무 보고 시 확인 사항

- 이번 주 진행한 일의 **상태 변경** 확인
- 이번 주 진행한 일의 **기한 확인**
- 차주 할 일 **이슈 생성** 및 **기한 지정**

---

## 실행 절차

### 1단계: 기간 확인

사용자에게 보고 기간 확인:
- **지난주**: 월요일 00:00 ~ 일요일 23:59
- **차주 예정**: 다음 주 월요일 ~ 일요일
- **회의 날짜**: 다음 월요일 (폴더 명명용)

예시:
- 보고 기간: 2026-01-05 (월) ~ 2026-01-11 (일)
- 차주 예정: 2026-01-12 (월) ~ 2026-01-18 (일)
- 회의 날짜: 2026-01-12 → 폴더명 `260112`

---

### 2단계: Confluence 폴더 확인/생성

1. **상위 폴더**: Space `POPUPSTUDI`, Folder ID `7208961`
2. **날짜 폴더 검색**:
   ```
   confluence_search: space = "POPUPSTUDI" AND title = "260112"
   ```
3. **폴더 확인**:
   - 검색 결과의 `type`이 `folder`인지 확인
   - `type: page`이면 폴더가 아님 - 사용자에게 알림 필요
4. **폴더가 없으면**:
   - ⚠️ **Confluence API로는 폴더(folder) 생성 불가**
   - 사용자에게 Confluence UI에서 폴더 생성 요청
   - 폴더 생성 방법: Confluence > Space > + 버튼 > "폴더" 선택
5. **폴더가 있으면**:
   - 해당 폴더 ID를 parent_id로 사용하여 보고서 페이지 생성

---

### 3단계: Python 스크립트로 Jira 데이터 수집

⚠️ **MCP API 결과가 context 제한을 초과할 수 있으므로 Python 스크립트로 먼저 수집합니다.**

```bash
python3 .claude/scripts/collect-jira-issues.py \
  --start 2026-01-05 \
  --end 2026-01-11 \
  --next-start 2026-01-12 \
  --next-end 2026-01-18
```

**출력 파일**: `/tmp/weekly-report/jira-issues-YYYYMMDD.json`

**스크립트 기능**:
- 12명 팀원별로 Jira 이슈 수집
- 이번 주 변경/완료/진행중/다음주 예정 이슈 분류
- 요약된 JSON 형태로 저장 (context 절약)

---

### 4단계: JSON 데이터 분석 및 보고서 작성

수집된 JSON 파일에서 팀원별 데이터를 읽어 분석합니다.

```bash
# 전체 요약 확인
cat /tmp/weekly-report/jira-issues-YYYYMMDD.json | jq '{
  period: .period,
  total_completed: [.members[].completed_this_week | length] | add,
  total_in_progress: [.members[].in_progress | length] | add
}'

# 팀원별 완료 이슈 수
cat /tmp/weekly-report/jira-issues-YYYYMMDD.json | jq '.members[] | {name, completed: (.completed_this_week | length)}'
```

---

### (참고) 기존 MCP 직접 조회 방식

대용량 데이터 문제로 **Python 스크립트 방식을 권장**합니다. 아래는 참고용입니다.

#### 팀원별 Jira 이슈 조회 (한 사람씩 순차)

⚠️ **필수 조회 설정**:
- `limit`: **50** (모든 이슈 포착)
- `fields`: `summary,status,issuetype,priority,updated,resolutiondate,duedate,project,assignee,reporter,parent,description`
- 세 프로젝트 **PS, BK, BKAM 모두** 조회 (한 사람이 여러 프로젝트에서 작업 가능)

각 팀원(12명)에 대해 다음 JQL로 이슈 조회:

#### 3-1. 이번 주 변경된 모든 이슈 (담당자 기준)

```jql
project in (PS, BK, BKAM)
AND assignee = "[이메일]"
AND updated >= "2026-01-05" AND updated <= "2026-01-11"
ORDER BY project ASC, updated DESC
```

**목적**: 해당 기간에 활동한 모든 이슈 파악 (상태/내용 변경 포함)
**주의**: 한 사람이 PS, BK, BKAM 모든 프로젝트에서 이슈를 가질 수 있음

#### 3-2. 이번 주 완료된 이슈

```jql
project in (PS, BK, BKAM)
AND assignee = "[이메일]"
AND status changed to Done during ("2026-01-05", "2026-01-11")
ORDER BY project ASC, resolutiondate DESC
```

**목적**: 이번 주 Done으로 전환된 이슈만 추출
**참고**: "완료", "Done", "Check/Review" 등 완료 카테고리 상태 모두 포함

#### 3-3. 현재 진행 중인 이슈

```jql
project in (PS, BK, BKAM)
AND assignee = "[이메일]"
AND status in ("In Progress", "진행 중")
ORDER BY project ASC, priority DESC, updated DESC
```

**목적**: 아직 완료되지 않은 진행 중 작업

#### 3-4. 다음 주 예정 작업

```jql
project in (PS, BK, BKAM)
AND assignee = "[이메일]"
AND (
  status in ("To Do", "Backlog", "Open", "해야 할 일")
  OR (dueDate >= "2026-01-12" AND dueDate <= "2026-01-18")
)
ORDER BY project ASC, priority DESC, dueDate ASC
```

**목적**: To Do 상태이거나 다음 주 기한인 이슈

#### 3-5. 본인이 생성한 이슈 (reporter)

```jql
project in (PS, BK, BKAM)
AND reporter = "[이메일]"
AND updated >= "2026-01-05" AND updated <= "2026-01-11"
AND assignee != "[이메일]"
ORDER BY project ASC, updated DESC
```

**목적**: 다른 사람에게 할당했지만 본인이 생성한 이슈

---

### 4단계: 이슈 상세 조회

각 이슈에 대해 상세 정보 확인:

```
jira_get_issue:
  issue_key: "PS-123"
  fields: "summary,status,priority,assignee,reporter,created,updated,resolutiondate,duedate,description,issuetype,parent"
  expand: "changelog"
```

확인할 필드:
- `summary`: 제목
- `status`: 상태 (To Do / In Progress / Done)
- `issuetype`: 유형 (Epic/Story/Task/Sub-task/Bug)
- `priority`: 우선순위
- `updated`: 최종 수정일
- `resolutiondate`: 완료일
- `duedate`: 기한
- `description`: 작업 내용 상세
- `parent`: 상위 이슈 (Sub-task인 경우)
- `changelog`: 상태 변경 이력

---

### 5단계: 팀원별 요약 작성

각 팀원에 대해 다음 정보 정리:

```markdown
### [팀원명] ([역할])

**이번 주 집중 영역:** [주요 작업 분야 요약]

**주요 성과 (완료 [N]건):**

* **[이슈키]: [제목]** ([완료일] 완료)
  - [작업 내용 상세 - description 기반]
* ...

**진행 중인 작업:**
* **[이슈키]: [제목]** - [현재 상태/진행률]

**다음 주 예정 작업:**
* **[이슈키]: [제목]** (기한: [dueDate])

**칭찬 포인트:**
[정량적 성과 + 정성적 평가]
```

---

### 6단계: 전체 보고서 작성

#### 보고서 양식

```markdown
# 팀 주간 업무 보고서

**기간**: 2026-01-05 ~ 2026-01-11
**작성일**: 2026-01-11
**대상 프로젝트**: BK, PS, BKAM

---

## 팀원별 업무 현황 및 성과

### 김태형 (대표)

**이번 주 집중 영역:** [영역]

**주요 성과:**
* **PS-XXX: [제목]** ([완료일] 완료) - [내용]

**칭찬 포인트:**
[칭찬 내용]

---

### 김명일 (Backend Developer)
...

---

## 이번 주 전체 주요 진행 사항

### 개발 (Backend)
- [주요 내용]

### 개발 (Frontend)
- [주요 내용]

### QA & UX/UI
- [주요 내용]

### 기획 & 콘텐츠
- [주요 내용]

### 비즈니스 & 마케팅
- [주요 내용]

---

## 잘한 점
1. [팀 전체 잘한 점]
2. ...

## 아쉬운 점
1. [개선 필요 사항]
2. ...

---

## 이번 주 (2026-01-12 ~ 2026-01-18) 예상 작업

### Bkend (BK)
#### 김명일 ([N]건)
* [예정 작업]

### Bkamp (BKAM)
#### 김경호 ([N]건)
* [예정 작업]

### POPUP-STUDIO (PS)
#### 이승준 ([N]건)
* [예정 작업]

---

## 논의 필요 사항

### 1. [주제]
* **현황**: [설명]
* **문제점**: [이슈]
* **제안**: [해결 방안]

---

*이 보고서는 Jira BK/PS/BKAM 프로젝트의 이슈를 기반으로 2026-01-05 ~ 2026-01-11 기간의 실제 작업을 반영하여 작성되었습니다.*
```

---

### 7단계: Confluence 저장

1. 날짜 폴더 page_id 확인
2. 보고서 페이지 생성:
   ```
   confluence_create_page:
     space_key: "POPUPSTUDI"
     title: "팀 주간 업무 보고서 (2026-01-05 ~ 2026-01-11)"
     parent_id: "[날짜폴더 page_id]"
     content: [작성한 보고서]
     content_format: "markdown"
   ```
3. 생성된 URL 안내

---

## 개인 보고서 모드 (`me`)

개인 보고서는 현재 사용자의 이슈만 조회:

```jql
assignee = currentUser() AND updated >= "[시작일]"
reporter = currentUser() AND updated >= "[시작일]"
```

개인 보고서 양식은 팀 보고서의 개인 섹션과 동일하되, 본인 정보만 포함.

---

## 주의사항

1. **모든 프로젝트 조회**: PS, BK, BKAM 세 프로젝트 모두 확인
2. **모든 이슈 타입 포함**: Epic, Story, Task, Sub-task, Bug 모두
3. **updated 필드 중심**: startDate, dueDate가 없어도 updated로 포착
4. **상태 변경 확인**: changelog로 상태 전환 이력 파악
5. **이슈 상세 필수**: description, comments 확인
6. **실제 데이터만**: Jira에 없는 내용은 추정하지 않음

---

## Confluence 구조

- **Space Key**: POPUPSTUDI
- **상위 폴더 ID**: 7208961
- **폴더 URL**: https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/folder/7208961
- **양식 참고**: https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/pages/33062951
