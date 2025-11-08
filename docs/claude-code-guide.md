# Claude Code 사용 가이드

## Claude Code란?

**쉽게 말하면**: Claude Code는 AI 비서입니다. 채팅하듯이 대화하면서 업무를 처리할 수 있습니다.

- 업무 관리 (Jira 이슈 확인, 할당, 처리)
- 문서 작성 및 정리 (Confluence)
- 반복 작업 자동화
- 정보 검색 및 분석

**누가 사용하나요?**
- 개발자: 코드 작성, 버그 수정, 기술 문서 작성
- 기획자: 프로젝트 관리, 요구사항 정리, 보고서 작성
- 디자이너: HTML, CSS, Javascrtipt, JSON(목업 데이터)으로 목업 페이지 디자인 작업, 이슈 트래킹
- 운영팀: 업무 현황 파악, 문서 정리, 정보 통합

## 시작하기

### 1. 처음 사용할 때

회사에서 제공하는 `setup.sh` 스크립트를 실행하면 모든 설정이 자동으로 완료됩니다.

```bash
# 터미널에서 실행
cd AI-driven-work
./scripts/setup.sh
```

설정이 완료되면:
```bash
# Claude Code 실행
claude
```

### 2. 첫 대화 시작하기

Claude Code를 실행하면 대화창이 나타납니다. 평소 말하듯이 요청하면 됩니다:

**예시 1 - 오늘 할 일 확인**
```
나: 오늘 할 일을 알려줘 or /daily-standup 실행
Claude: /daily-standup 명령으로 확인하시겠어요?
```

**예시 2 - 문서 작성 도움**
```
나: 이번 프로젝트 회의록을 Confluence에 작성해줘
Claude: 회의 내용을 알려주시면 구조화해서 Confluence 페이지로 만들어드릴게요.
```

**예시 3 - Jira 이슈 처리**
```
나: PROJ-123 이슈를 나한테 할당해줘 or /assign-me PROJ-123 실행
Claude: /assign-me PROJ-123을 실행할까요?
```

### 3. 일상적인 사용법

매일 아침 출근하면:
1. `claude` 실행
2. `/daily-standup` 입력하여 오늘 할 일 확인
3. 처리할 이슈 선택하여 할당

업무 중:
- 막히는 부분이 있으면 Claude에게 질문
- 문서 작성이 필요하면 Claude에게 요청
- Slack의 중요한 대화는 `/save-slack-thread`로 저장

주말 전 금요일:
1. `/weekly-report` 실행
2. 이번 주 완료한 일 자동 정리
3. Confluence에 저장

## 비개발자를 위한 핵심 기능

### 업무 관리 자동화

**상황**: "오늘 뭐 해야 하지?"
```
/daily-standup
```

Claude가 자동으로:
- 나에게 할당된 일감 보여주기
- 아직 담당자가 없는 일감 보여주기
- 급한 일 먼저 알려주기

### 문서 작성 도움

**상황**: "Confluence에 회의록 써야 하는데 귀찮아..."

```
나: 오늘 오전 10시에 마케팅 전략 회의 했어. 참석자는 홍길동, 김철수, 이영희였고,
    새 캠페인을 11월 15일에 시작하기로 결정했어. 예산은 500만원이고 타겟은 20-30대.
    홍길동님이 기획안 작성, 김철수님이 예산 확정, 이영희님이 디자인 준비하기로 했어.

Claude: 회의록을 Confluence 페이지로 작성했습니다.
        [링크] 에서 확인하시고 필요하면 수정하세요.
```

### Slack 대화 정리

**상황**: "Slack에서 중요한 얘기가 오갔는데 나중에 못 찾겠어..."

```
/save-slack-thread
```

1. Slack 대화 복사해서 붙여넣기
2. Claude가 자동으로 정리
3. Confluence에 페이지로 저장
4. 언제든 검색해서 찾을 수 있음

### 주간 보고서 자동 작성

**상황**: "주간 보고 써야 하는데 이번 주에 뭐 했더라..."

```
/weekly-report
```

Claude가 Jira에서 자동으로:
- 내가 이번 주에 완료한 일 찾기
- 진행 중인 일 정리
- 보고서 형식으로 작성
- Confluence에 저장

## 편리한 기능들

### Slash Commands (간편 명령어)

슬래시(/)로 시작하는 명령어로 자주 하는 일을 빠르게 처리할 수 있습니다.

| 명령어 | 무엇을 하나요? | 언제 사용하나요? |
|--------|---------------|-----------------|
| `/daily-standup` | 오늘 할 일 확인 | 매일 아침 출근해서 |
| `/weekly-report` | 주간 보고서 작성 | 매주 금요일 또는 회의 전 |
| `/assign-me PROJ-123` | 이슈를 나에게 할당 | 새 일감을 맡을 때 |
| `/save-slack-thread` | Slack 대화 정리 | 중요한 대화를 저장할 때 |

### 자연어로 말하기

Slash Commands를 외우기 어렵다면, 그냥 평소 말하듯이 요청하세요:

```
명령어 방식: /daily-standup
자연어 방식: 오늘 내가 할 일 보여줘
```

둘 다 똑같이 작동합니다!

## 실제 업무 시나리오

### 시나리오 1: 기획자의 하루

**오전 9시 - 출근**
```
기획자: 오늘 할 일 보여줘
Claude: /daily-standup

결과:
- [PROJ-100] 신규 기능 요구사항 작성 (나에게 할당됨, In Progress)
- [PROJ-105] 사용자 설문조사 결과 분석 (미할당)
- [PROJ-110] Q4 로드맵 검토 (나에게 할당됨, To Do)
```

**오전 10시 - 회의 후**
```
기획자: Slack의 이 회의 내용을 Confluence에 정리해줘
        [Slack 대화 붙여넣기]

Claude: Confluence 페이지로 작성했습니다.
        - 회의 참석자
        - 주요 논의 사항
        - 결정 사항
        - 다음 액션 아이템
        모두 정리되어 있습니다.
```

**오후 3시 - 새 일감 발견**
```
기획자: PROJ-105를 나한테 할당해줘
Claude: ✅ PROJ-105가 당신에게 할당되었고, 상태가 "In Progress"로 변경되었습니다.
```

**금요일 오후 5시 - 주간 보고**
```
기획자: 이번 주 보고서 작성해줘
Claude: /weekly-report

이번 주 완료 사항:
- PROJ-100: 신규 기능 요구사항 작성 완료
- PROJ-102: 사용자 테스트 시나리오 3건 작성

진행 중:
- PROJ-105: 설문조사 결과 분석 (60% 완료)

다음 주 계획:
- PROJ-110: Q4 로드맵 최종 검토
```

### 시나리오 2: 마케터의 문서 작성

**상황**: 캠페인 결과 보고서 작성
```
마케터: 11월 캠페인 결과 보고서를 Confluence에 작성해줘.
        인스타그램 광고 클릭 3,200회, 전환 128건, 전환율 4%,
        광고비 300만원, CPA 23,400원이야.

Claude: Confluence에 보고서를 작성했습니다.

        # 11월 캠페인 성과 보고서

        ## 주요 지표
        - 광고 클릭: 3,200회
        - 전환: 128건
        - 전환율: 4.0%
        - 광고비: 3,000,000원
        - CPA: 23,400원

        ## 분석
        - 전환율 4%는 업계 평균(2.5%) 대비 우수
        - CPA가 목표(25,000원)보다 낮아 효율적

        [Confluence 링크]
```

### 시나리오 3: 디자이너의 이슈 추적

**상황**: 디자인 피드백 이슈 처리
```
디자이너: 나한테 할당된 디자인 이슈 중에 우선순위 높은 것만 보여줘

Claude: 우선순위 높은 이슈 2건:
        - [DESIGN-45] 메인 페이지 배너 수정 (Highest)
        - [DESIGN-47] 아이콘 일관성 개선 (High)

디자이너: DESIGN-45 처리 완료했어. Done으로 바꿔줘

Claude: ✅ DESIGN-45를 "Done" 상태로 변경했습니다.
```

## 기본 개념 (알아두면 좋아요)

### Rules (규칙)
**쉬운 설명**: Claude가 모든 작업을 할 때 따라야 하는 기본 규칙
**예시**: "항상 존댓말 사용", "문서는 Confluence에 저장"

### Instructions (지침)
**쉬운 설명**: 특정 프로젝트에서만 적용되는 규칙
**예시**: "이 프로젝트의 Jira 키는 PROJ", "보고서는 매주 금요일"

### Slash Commands (명령어)
**쉬운 설명**: 자주 하는 일을 한 줄로 실행하는 단축키
**예시**: `/daily-standup`, `/weekly-report`

### Skills (기능)
**쉬운 설명**: 복잡한 작업을 패키지로 만든 것
**예시**: PDF 생성, 데이터 분석 등

## 자주 묻는 질문 (FAQ)

### Q1. Claude Code를 어떻게 시작하나요?
**A**: 터미널(또는 명령 프롬프트)에서 `claude`를 입력하면 됩니다.
- Mac: Spotlight(⌘+Space)에서 "Terminal" 검색 → `claude` 입력
- Windows: 시작 메뉴에서 "cmd" 검색 → `claude` 입력

### Q2. 명령어를 외워야 하나요?
**A**: 아니요! 평소 말하듯이 대화하면 됩니다.
```
❌ 어렵게: /assign-me PROJ-123
✅ 쉽게: PROJ-123 이슈를 나한테 할당해줘
```

### Q3. Jira나 Confluence를 몰라도 되나요?
**A**: 네! Claude에게 물어보면서 배울 수 있습니다.
```
나: Jira에서 이슈를 어떻게 만들어?
Claude: [단계별 설명]

나: 그럼 이슈 하나 만들어줘
Claude: [자동으로 생성]
```

### Q4. 실수로 잘못된 명령을 내리면 어떻게 하나요?
**A**: Claude가 실행 전에 확인을 요청하거나, 실수를 알려줍니다.
```
나: PROJ-999 삭제해줘
Claude: ⚠️ 이슈 PROJ-999를 찾을 수 없습니다.
        이슈 번호를 다시 확인해주세요.
```

### Q5. Claude Code는 무료인가요?
**A**: 회사에서 설정해준 계정으로 사용하면 됩니다. 개인적으로는 유료입니다.

### Q6. 개인 정보나 회사 기밀이 유출되나요?
**A**:
- Jira/Confluence 데이터는 회사 서버에만 저장됩니다
- Claude는 요청한 작업만 처리합니다
- 민감한 정보는 절대 외부에 공유하지 마세요

### Q7. 인터넷이 끊기면 사용할 수 없나요?
**A**: 네, Claude Code는 인터넷 연결이 필요합니다.

### Q8. 모바일에서도 사용할 수 있나요?
**A**: 현재는 PC/Mac에서만 사용 가능합니다.

### Q9. 여러 명이 동시에 사용하면 어떻게 되나요?
**A**: 문제없습니다! 각자의 계정으로 독립적으로 작동합니다.

### Q10. Claude가 이해하지 못할 때는?
**A**: 더 구체적으로 설명하거나, 다르게 표현해보세요.
```
❌ 애매한 요청: 저거 좀 해줘
✅ 구체적 요청: PROJ-100 이슈의 상태를 Done으로 바꿔줘
```

## 다른 프로젝트에서 Jira 기능 사용하기

### 다른 프로젝트에도 Jira 기능 추가하기

AI-driven-work 프로젝트가 아닌 **다른 프로젝트** (예: 실제 개발 프로젝트, 디자인 프로젝트 등)에서도 Jira 관련 기능을 사용하고 싶다면, 간단한 스크립트로 추가할 수 있습니다.

### 왜 필요한가요?

현재는 AI-driven-work 프로젝트에서만 Jira slash commands (`/daily-standup`, `/weekly-report` 등)와 AI 지침이 있습니다. 다른 프로젝트에서 Claude Code를 실행하면 이런 기능들을 사용할 수 없습니다.

**예시**:
```
# AI-driven-work에서 실행
cd ~/Documents/GitHub/popup/AI-driven-work
claude
> /daily-standup  ✅ 작동함!

# 다른 프로젝트에서 실행
cd ~/projects/my-web-app
claude
> /daily-standup  ❌ 명령어를 찾을 수 없습니다
```

### 해결 방법

`jira-rules-setup.sh` 스크립트를 사용하면 다른 프로젝트에도 Jira 기능을 추가할 수 있습니다.

#### 1단계: AI-driven-work로 이동

```bash
cd ~/Documents/GitHub/popup/AI-driven-work
```

#### 2단계: 스크립트 실행

```bash
# 기본 사용법
./scripts/jira-rules-setup.sh <다른_프로젝트_경로>

# 예시
./scripts/jira-rules-setup.sh ~/projects/my-web-app
./scripts/jira-rules-setup.sh ~/work/design-project
```

#### 3단계: 미리보기 (선택사항)

실제 변경하기 전에 어떤 작업이 수행될지 확인하고 싶다면:

```bash
./scripts/jira-rules-setup.sh ~/projects/my-web-app --dry-run
```

### 스크립트가 하는 일

**[1/4] Slash Commands 복사**
- `/daily-standup` - 오늘 할 일 확인
- `/weekly-report` - 주간 보고서 생성
- `/assign-me` - 이슈 할당
- `/save-slack-thread` - Slack 대화 저장

**파일 충돌 시**:
```
⚠️  daily-standup.md 이미 존재합니다.
   (o)덮어쓰기 / (s)건너뛰기 / (r)이름변경 / (d)차이점 보기
   선택:
```

**[2/4] Jira 지침 복사**
- `jira-rules.md` 복사
- Claude Code가 Jira 작업을 자동으로 처리할 수 있게 해주는 AI 지침

**[3/4] 기존 지침과 통합**
- 다른 프로젝트에 이미 있는 instructions 파일 자동 감지
- 기존 파일에 `jira-rules.md` 참조 추가

예를 들어, `typescript-style.md`가 있다면:
```markdown
---

> 📋 Additional Instructions: This project also follows Jira workflow rules.
> See: `.claude/instructions/jira-rules.md`

---

(기존 TypeScript 스타일 가이드 내용...)
```

**[4/4] 자동 백업**
- 덮어쓰기 전 자동으로 백업 생성
- 백업 위치: `.claude/.backup-YYYYMMDD-HHMMSS/`

### 적용 후 사용

다른 프로젝트로 이동해서 Claude Code를 실행하면 Jira 기능을 바로 사용할 수 있습니다:

```bash
# 타겟 프로젝트로 이동
cd ~/projects/my-web-app

# Claude Code 실행
claude

# Jira 기능 테스트
> /daily-standup
> Jira에서 PROJ 프로젝트의 미할당 이슈 보여줘
> /assign-me PROJ-123
```

### 주의사항

**MCP Server 설정 필요**: `jira-rules-setup.sh`는 slash commands와 지침만 복사합니다.
- MCP Server 설정은 `setup.sh`로 미리 완료되어 있어야 합니다.
- MCP Server는 **전역 설정**이므로 한 번만 설정하면 모든 프로젝트에서 사용 가능합니다.

**프로젝트별 독립 실행**:
- 각 프로젝트에서 Claude Code를 실행하면 해당 프로젝트의 지침이 적용됩니다.
- 예: `my-web-app`에서는 TypeScript 지침 + Jira 지침이 함께 적용됩니다.

### 실전 예시

**시나리오**: 프론트엔드 프로젝트에서도 Jira 기능 사용하고 싶음

```bash
# 1. AI-driven-work에서 스크립트 실행
cd ~/Documents/GitHub/popup/AI-driven-work
./scripts/jira-rules-setup.sh ~/projects/frontend-app

# 출력:
# ==========================================
# 🎯 Jira Rules Setup
# ==========================================
#
# [1/4] Slash Commands 복사
#   ✅ daily-standup.md 복사 완료
#   ✅ weekly-report.md 복사 완료
#   ✅ assign-me.md 복사 완료
#   ✅ save-slack-thread.md 복사 완료
#
# [2/4] Jira 지침 복사
#   ✅ jira-rules.md 복사 완료
#
# [3/4] 기존 Instructions 파일 확인
#   📄 react-guidelines.md
#   ✅ react-guidelines.md: jira-rules.md 참조 추가 완료
#
# [4/4] 설정 완료!

# 2. 프론트엔드 프로젝트로 이동
cd ~/projects/frontend-app

# 3. Claude Code 실행 및 Jira 기능 사용
claude
> /daily-standup
# → 미할당 Task/Sub-Task 표시됨!
```

이제 어떤 프로젝트에서든 Jira 기능을 편리하게 사용할 수 있습니다! 🎉

---

## 다른 프로젝트에 GitHub 워크플로우 추가하기

### GitHub 워크플로우란?

**쉽게 말하면**: 여러 명이 함께 코드를 작성할 때 따라야 할 규칙입니다.

- 브랜치 만들기 규칙 (feature/버그명, bugfix/문제명 등)
- 코드 리뷰 받는 방법
- 변경사항 머지하는 방법
- 이슈 템플릿

### 왜 필요한가요?

팀 프로젝트에서 일관된 Git 워크플로우를 사용하면:
- 혼란 없이 협업 가능
- 코드 품질 향상 (리뷰 필수)
- 변경 이력 추적 용이
- 신입 직원 온보딩 간소화

### 사용 방법

#### 1단계: AI-driven-work로 이동

```bash
cd ~/Documents/GitHub/popup/AI-driven-work
```

#### 2단계: 스크립트 실행

```bash
# 기본 사용법
./scripts/github-workflow-setup.sh <다른_프로젝트_경로>

# 예시
./scripts/github-workflow-setup.sh ~/projects/my-web-app
./scripts/github-workflow-setup.sh ~/work/design-project
```

#### 3단계: GitHub username 입력

스크립트 실행 중 GitHub username을 물어봅니다:

```
GitHub Username (예: popup-kay): your-github-id
```

이 정보는 CODEOWNERS 파일과 Issue 템플릿에 사용됩니다.

#### 4단계: 미리보기 (선택사항)

실제 변경하기 전에 어떤 작업이 수행될지 확인하고 싶다면:

```bash
./scripts/github-workflow-setup.sh ~/projects/my-web-app --dry-run
```

### 스크립트가 하는 일

**[1/4] GitHub Workflow 지침 복사**
- `.claude/instructions/github-workflow.md` 복사
- 브랜치 전략 (main/develop/feature/bugfix)
- 머지 전략 (Squash and merge vs Merge commit)
- PR 생성 및 리뷰 가이드
- 커밋 메시지 규칙

**[2/4] GitHub 설정 파일 생성**

`.github/CODEOWNERS` 생성:
```
# CODEOWNERS
* @your-github-id
```

Issue 템플릿 생성:
- `bug_report.md` - 버그 리포트 템플릿
- `feature_request.md` - 기능 제안 템플릿

**파일 충돌 시**:
```
⚠️  CODEOWNERS 파일이 이미 존재합니다.
   (o)덮어쓰기 / (s)건너뛰기 / (a)소유자 추가
   선택:
```

**[3/4] 기존 지침과 통합**
- 다른 프로젝트에 이미 있는 instructions 파일 자동 감지
- 기존 파일에 `github-workflow.md` 참조 추가

예를 들어, `coding-style.md`가 있다면:
```markdown
---

> 🔀 GitHub Workflow: This project follows standardized branch and PR workflows.
> See: `.claude/instructions/github-workflow.md`

---

(기존 코딩 스타일 가이드 내용...)
```

**[4/4] 자동 백업**
- 덮어쓰기 전 자동으로 백업 생성
- 백업 위치: `.claude/.backup-YYYYMMDD-HHMMSS/`

### 적용 후 설정

스크립트 실행이 완료되면, GitHub 저장소에서 추가 설정이 필요합니다:

#### 1. Branch Protection Rules 설정

**GitHub 저장소로 이동**:
```
https://github.com/<your-org>/<your-repo>/settings/branches
```

**main 브랜치 보호**:
1. "Add rule" 클릭
2. Branch name pattern: `main`
3. 설정:
   - ✅ Require a pull request before merging
   - ✅ Require approvals: 1
   - ✅ Require review from Code Owners
   - ✅ Require conversation resolution before merging

**develop 브랜치 보호**:
1. "Add rule" 클릭
2. Branch name pattern: `develop`
3. 설정:
   - ✅ Require a pull request before merging
   - ✅ Require approvals: 1
   - ✅ Require review from Code Owners

#### 2. 생성된 파일 커밋

```bash
cd ~/projects/my-web-app

# CODEOWNERS 커밋
git add .github/CODEOWNERS
git commit -m "chore: Add CODEOWNERS file"

# Issue 템플릿 커밋
git add .github/ISSUE_TEMPLATE/
git commit -m "chore: Add issue templates"

# GitHub Workflow 지침 커밋
git add .claude/instructions/github-workflow.md
git commit -m "docs: Add GitHub workflow guidelines"

# 푸시
git push origin develop
```

### 적용 후 사용

다른 프로젝트에서 Claude Code를 실행하면 GitHub 워크플로우 지침을 확인할 수 있습니다:

```bash
# 타겟 프로젝트로 이동
cd ~/projects/my-web-app

# Claude Code 실행
claude

# GitHub 워크플로우 확인
> GitHub 브랜치 전략 알려줘
> PR 만들 때 주의사항 뭐야?
> 커밋 메시지 규칙 알려줘
```

### 실전 예시

**시나리오**: 프론트엔드 프로젝트에 GitHub 워크플로우 적용

```bash
# 1. AI-driven-work에서 스크립트 실행
cd ~/Documents/GitHub/popup/AI-driven-work
./scripts/github-workflow-setup.sh ~/projects/frontend-app

# 출력:
# ==========================================
# 🔀 GitHub Workflow Setup
# ==========================================
#
# GitHub Username (예: popup-kay): john-doe
#
# [1/4] GitHub Workflow 지침 복사
#   ✅ github-workflow.md 복사 완료
#
# [2/4] GitHub 설정 파일 생성
#   ✅ CODEOWNERS 생성 완료
#   ✅ bug_report.md 생성 완료
#   ✅ feature_request.md 생성 완료
#
# [3/4] 기존 Instructions 파일 확인
#   📄 react-guidelines.md
#   ✅ react-guidelines.md: github-workflow.md 참조 추가 완료
#
# [4/4] 설정 완료!

# 2. 프론트엔드 프로젝트로 이동
cd ~/projects/frontend-app

# 3. GitHub 설정 파일 커밋
git add .github/ .claude/
git commit -m "chore: Add GitHub workflow configuration"
git push origin develop

# 4. GitHub에서 Branch Protection Rules 설정

# 5. Claude Code로 확인
claude
> GitHub 워크플로우 규칙 알려줘
# → 브랜치 전략, 머지 전략 등 상세 안내!
```

### 주의사항

**권한 필요**: GitHub 저장소에서 Branch Protection Rules를 설정하려면 관리자 권한이 필요합니다.

**팀 공유**: 생성된 CODEOWNERS와 Issue 템플릿은 팀원들과 공유해야 합니다 (git push).

**프로젝트별 독립**: 각 프로젝트마다 별도의 GitHub 워크플로우 설정을 가질 수 있습니다.

이제 어떤 프로젝트에서든 표준화된 Git 협업이 가능합니다! 🎉

---

## 유용한 팁

### 💡 효율적으로 사용하는 법

1. **매일 루틴으로 만들기**
   - 아침: `/daily-standup`
   - 저녁: 진행 상황 업데이트
   - 금요일: `/weekly-report`

2. **대화 내용을 명확하게**
   ```
   ❌ "저거 좀"
   ✅ "PROJ-123 이슈를 나한테 할당해줘"
   ```

3. **단계별로 요청하기**
   ```
   복잡한 작업은 한 번에 하나씩:
   1. "먼저 이슈 목록 보여줘"
   2. "이 중에서 PROJ-100 할당해줘"
   3. "이제 문서 작성해줘"
   ```

4. **결과 확인하기**
   - Claude가 작업을 완료하면 항상 결과 확인
   - 잘못되었으면 바로 수정 요청

5. **피드백 주기**
   ```
   좋은 예: "고마워, 근데 제목을 좀 더 구체적으로 바꿔줘"
   ```

### ⚠️ 주의사항

1. **민감한 정보**
   - 개인정보, 비밀번호, API 키는 Claude에게 알려주지 마세요
   - 기밀 프로젝트는 승인 후 사용하세요

2. **중요한 결정**
   - 중요한 이슈 삭제나 변경은 신중하게
   - 확실하지 않으면 먼저 확인만 요청하세요

3. **정확성 확인**
   - AI가 만든 문서는 항상 검토하세요
   - 숫자나 날짜는 특히 주의 깊게 확인하세요

## 문제가 생겼을 때

### 연결 오류
```
증상: "MCP 서버에 연결할 수 없습니다"
해결:
1. 인터넷 연결 확인
2. Claude Code 재시작 (claude 종료 후 다시 실행)
3. 안 되면 IT 팀에 문의
```

### 명령어가 작동하지 않을 때
```
증상: "/daily-standup이 작동하지 않습니다"
해결:
1. 슬래시(/)를 제대로 입력했는지 확인
2. 또는 "오늘 할 일 보여줘"처럼 자연어로 요청
3. 여전히 안 되면 설정 확인 필요 → `config/README.md` 참고
```

### Jira 이슈를 찾을 수 없을 때
```
증상: "PROJ-123을 찾을 수 없습니다"
해결:
1. 이슈 번호가 정확한지 확인 (대소문자 구분)
2. Jira에서 직접 검색해서 존재하는지 확인
3. 프로젝트 키가 맞는지 확인 (PROJ, DESIGN 등)
```

### 권한 오류
```
증상: "이 작업을 수행할 권한이 없습니다"
해결:
1. Jira/Confluence에 로그인되어 있는지 확인
2. 해당 프로젝트에 접근 권한이 있는지 확인
3. API 토큰이 만료되었을 수 있음 → IT 팀 문의
```

## 도움 받기

### 사내 지원
- **IT 팀**: 설치 및 설정 문제
- **프로젝트 리더**: Jira/Confluence 권한 문제
- **동료**: 사용법 공유 및 팁

### 문서 참고
- `config/README.md`: 설정 방법
- `docs/jira-guidelines.md`: Jira 사용 규칙
- `docs/confluence-guidelines.md`: Confluence 사용 규칙
- `docs/workflow-examples.md`: 실제 업무 예시

### 공식 문서
- [Claude Code 공식 문서](https://docs.claude.com/claude-code)
- 단, 회사 설정과 다를 수 있으니 먼저 사내 문서를 참고하세요

## 시작이 반입니다!

처음에는 낯설 수 있지만, 일주일만 사용하면 익숙해집니다.

**첫 주 목표**:
- [ ] Day 1: Claude Code 실행해보기
- [ ] Day 2: `/daily-standup` 사용해보기
- [ ] Day 3: Jira 이슈 하나 할당받기
- [ ] Day 4: Claude에게 문서 작성 도움 받기
- [ ] Day 5: `/weekly-report` 생성해보기

**궁금한 점은 Claude에게 물어보세요!**
```
나: Claude Code를 처음 사용하는데 뭐부터 시작하면 좋을까?
Claude: [친절한 안내]
```

**화이팅! 🚀**
