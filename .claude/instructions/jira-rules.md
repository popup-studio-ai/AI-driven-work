# Claude Code - Jira 작업 규칙

이 문서는 **Claude Code (AI Agent)**가 Jira 관련 작업을 처리할 때 따라야 할 핵심 규칙입니다.

---

## 핵심 원칙

### 1. Story 중심 작업 관리

**Story**가 가장 중요한 작업 단위입니다:
- Story는 사용자에게 가치를 제공하는 독립적인 기능 단위
- Story 하위에 **Sub-Task**를 생성하여 실제 작업을 관리
- Story는 책임자/리드 지정 (선택사항)
- **Sub-Task에 실행 담당자 지정 (필수)**

---

## 이슈 타입 정의

### Epic 🏗️
- **완료 기간**: 몇 주 ~ 몇 달
- **용도**: 여러 Story를 포함하는 큰 프로젝트
- **담당자**: 책임자/리드 (선택사항)
- **예시**: "신규 회원가입 시스템 구축", "브랜드 리뉴얼 프로젝트"

### Story 🏠 (가장 중요)
- **완료 기간**: 며칠 ~ 1주
- **용도**: 사용자에게 가치를 제공하는 독립적인 기능 단위
- **담당자**: 책임자/리드 (선택사항) - 실제 작업은 Sub-Task에 할당
- **제목 형식**: "[주체]가 [행동]할 수 있다"
- **예시**: "사용자가 소셜 로그인으로 회원가입할 수 있다"

### Task 🔨
- **완료 기간**: 반나절 ~ 며칠
- **용도**: 기술적/운영적 독립 작업 (사용자가 직접 체감하지 않음)
- **담당자**: 실행 담당자 (필수)
- **제목 형식**: "[대상]을/를 [행동]한다"
- **예시**: "서버 로그 모니터링 설정", "코드 리팩토링"

### Sub-Task 🔩 (Story 하위 작업)
- **완료 기간**: 몇 시간 ~ 하루
- **용도**: Story나 Task를 완료하기 위한 작은 단계
- **담당자**: 실행 담당자 (필수)
- **제목 형식**: 구체적이고 실행 가능한 단계
- **예시**: "회원가입 UI 개발", "API 엔드포인트 개발"

---

## 이슈 타입 결정 플로우

```
1. 여러 달 걸리는 큰 프로젝트인가?
   YES → Epic 생성 → Story들로 나누기
   NO  → 다음 질문

2. 사용자에게 가치를 제공하나? (사용자가 체감하나?)
   YES → Story 생성 → Sub-Task로 나누기
   NO  → Task 생성

3. 작업이 복잡하거나 여러 단계로 나눠야 하나?
   YES → Sub-Task로 나누기
   NO  → 이슈 생성 완료
```

---

## 담당자 지정 규칙

### Epic/Story
- 📋 **책임자/리드** 지정 (선택사항)
- 전체를 관리하고 조율하는 사람
- **실제 작업은 Sub-Task에 담당자 지정**

### Task/Sub-Task
- 👤 **실행 담당자** 지정 (필수)
- 실제로 손으로 일하는 사람
- **반드시 한 명만 지정**
- 매일 아침 미할당 Task/Sub-Task를 확인하고 스스로 선택

### Claude Code 규칙

1. **Epic/Story에 담당자 지정 시도 시 경고**:
   ```
   "[PROJ-123]는 Story입니다.
   Story는 책임자 지정이 선택사항이며, 실제 작업은 Sub-Task에 할당해야 합니다.
   이 Story의 Sub-Task 목록을 보시겠습니까?"
   ```

2. **`/daily-standup` 명령 시 Task/Sub-Task만 표시**
   - Epic/Story는 미할당 목록에 표시하지 않음

3. **`/assign-me` 명령 시**
   - Task/Sub-Task만 허용
   - Epic/Story는 경고 메시지 표시

---

## 이슈 생성 규칙

### 필수 확인 사항

1. **올바른 이슈 타입 선택**
2. **제목 형식 확인**
   - Story: "[주체]가 [행동]할 수 있다"
   - Task: "[대상]을/를 [행동]한다"
3. **담당자 지정 규칙 준수**
4. **중복 이슈 확인**
5. **Epic 연결 확인** (Story 생성 시)

### 이슈 설명 구조

```markdown
**목적**: 왜 이 작업이 필요한가?

**요구사항**: 무엇을 만들어야 하는가?
- 구체적인 요구사항 나열
- 기술적 제약사항

**수용 기준**: 어떻게 되어야 완료인가?
- 완료 조건 명확히 정의
- 테스트 가능한 기준

**관련 정보**:
- 참고 문서 링크
- 연관된 이슈
```

---

## 상태 전환 규칙

### 기본 규칙

1. **To Do → In Progress**
   - 담당자가 지정되어 있는지 확인
   - 담당자 없으면 먼저 지정 요청

2. **In Progress → Done**
   - Sub-Task가 있는 경우 모든 Sub-Task 완료 확인
   - 완료 코멘트 추가 제안

3. **Done → Reopened**
   - 재오픈 사유 코멘트 입력 제안

### 자동 상태 관리

- Epic 내 모든 Story가 Done → Epic도 Done으로 제안
- Story 내 모든 Sub-Task가 Done → Story도 Done으로 제안
- Epic/Story에 새 Sub-Task 추가 시 → In Progress로 변경 제안

---

## 자동화 작업

### `/daily-standup`
- **Task/Sub-Task만** 표시 (Epic/Story 제외)
- 우선순위 기반 정렬 (High → Medium → Low)
- 내 할당 이슈와 미할당 이슈 구분 표시

### `/weekly-report`

**주간 업무 보고서 생성 절차**:

1. **보고 기간**: 월요일 ~ 일요일
2. **Jira 업데이트 마감**: 매주 일요일 21시 (한국 시간)

**조회 조건** (팀원 12명 각각에 대해):
```jql
-- 이번 주 변경된 모든 이슈
project in (PS, BK, BKAM) AND assignee = "[이메일]"
AND updated >= "[시작일]" AND updated <= "[종료일]"

-- 이번 주 완료된 이슈
project in (PS, BK, BKAM) AND assignee = "[이메일]"
AND status changed to Done during ("[시작일]", "[종료일]")

-- 진행 중인 이슈
project in (PS, BK, BKAM) AND assignee = "[이메일]"
AND status = "In Progress"

-- 다음 주 예정 작업
project in (PS, BK, BKAM) AND assignee = "[이메일]"
AND (status in ("To Do", "Backlog") OR dueDate >= "[다음주 시작일]")
```

**확인 필드**: summary, status, issuetype, priority, updated, resolutiondate, duedate, description, parent, changelog

**Confluence 저장**:
- Space: POPUPSTUDI
- 상위 폴더 ID: 7208961
- 폴더 명명: YYMMDD (회의 날짜 기준)

### `/assign-me`
- Task/Sub-Task만 할당 허용
- Epic/Story는 경고 메시지 표시 후 Sub-Task 목록 제안

---

## 커뮤니케이션 원칙

### 1. 명확하고 간결한 응답

**✅ 좋은 예**:
```
PROJ-123 이슈를 생성했습니다:
- 타입: Story
- 제목: 사용자가 소셜 로그인으로 회원가입할 수 있다
- 담당자: 미지정 (Story는 책임자 지정이 선택사항입니다)

Sub-Task를 생성하시겠습니까?
```

### 2. 컨텍스트 제공

```
[PROJ-123] 결제 API 연동 (Story)
├─ [PROJ-124] 토스페이먼츠 연동 (Sub-Task) - Done
├─ [PROJ-125] 결제 테스트 (Sub-Task) - In Progress ← 현재 작업 중
└─ [PROJ-126] 환불 기능 개발 (Sub-Task) - To Do
```

### 3. 자율성 존중

- 항상 선택권을 사용자에게 제공
- 강제로 할당하지 않음
- 제안 형태로 커뮤니케이션

---

## ⚠️ Sub-Task 생성 필수 규칙

### 반드시 준수해야 할 규칙

**1. Sub-Task는 상위 이슈 없이 생성 불가**
```
❌ 오류: Sub-Task는 상위 이슈 없이 생성할 수 없습니다.

💡 해결 방법:
1. 먼저 상위 Story 또는 Task를 생성하세요
2. 또는 기존 Story/Task에 Sub-Task로 추가하세요
```

**2. Sub-Task 생성 시 필수 형식**
```python
jira_create_issue(
    project_key="PS",
    summary="Sub-task 제목",
    issue_type="Sub-task",  # 반드시 "Sub-task" 또는 "Subtask"
    description="작업 설명",
    assignee="user@example.com",
    additional_fields={"parent": "PS-123"}  # parent 필드 필수
)
```

**3. Sub-Task 생성 전 체크리스트**
```
✅ 생성 전 확인사항:
- [ ] 상위 이슈(Story/Task)가 존재하는가?
- [ ] 상위 이슈 키가 정확한가?
- [ ] issue_type을 "Sub-task"로 지정했는가?
- [ ] additional_fields에 parent 키를 포함했는가?
- [ ] 담당자가 지정되어 있는가? (필수)
- [ ] 이미 동일한 Sub-task가 존재하지 않는가?

❌ 자주 하는 실수:
- issue_type을 "Task"로 설정
- parent 필드를 누락
- additional_fields를 문자열로 전달
- 존재하지 않는 상위 이슈 키 지정
```

**4. Task를 Sub-task로 변환하는 방법**

Jira REST API는 직접적인 이슈 타입 변환을 지원하지 않으므로:

**방법 1: Jira UI에서 수동 변환** (소수 이슈, 1~3개)
```
1. Jira 웹에서 해당 이슈 열기
2. 이슈 메뉴 > Actions > "Convert to Sub-task" 선택
3. 상위 이슈(Story/Task) 지정
4. 변환 완료
```

**방법 2: 재생성 방식** (대량 이슈, 4개 이상)
```
1. 기존 Task의 모든 정보 읽기
2. 새로운 Sub-task 생성 (parent 필드에 상위 이슈 지정)
3. 상태가 "완료"인 경우 새 Sub-task도 완료 처리
4. 기존 Task 삭제

⚠️ 주의: 이슈 키 변경, 생성일자 초기화, 히스토리 손실
💡 중요한 이슈는 변환 전 백업 또는 스크린샷 저장
```

---

## 우선순위

### 필수 규칙 (반드시 준수)
- ✅ Sub-Task는 상위 이슈 없이 생성 불가
- ✅ Task/Sub-Task는 담당자 필수
- ✅ Epic/Story는 담당자 선택사항

### 권장 규칙 (제안 형태)
- 이슈 제목 형식
- 이슈 설명 구조
- Epic 연결

### 최적화 규칙 (사용자 경험 향상)
- 중복 이슈 확인
- 우선순위 기반 추천
- 자동 상태 전환 제안

---

**자세한 내용은 `docs/jira-guidelines.md`를 참조하세요.**

**작성일**: 2025-11-06
**최종 수정일**: 2025-11-17
**작성자**: Claude Code
**기반 문서**: `docs/jira-guidelines.md`
**버전**: 2.0
