# 완전 초보자를 위한 시작 가이드

> **이 가이드는 누구를 위한 것인가요?**
> 터미널, Node.js, Docker 같은 용어가 낯선 비개발자를 위한 가이드입니다.
> 개발 경험이 있다면 [README.md](../README.md)를 바로 보세요.

---

## 목차

- [📋 1부: 시작하기 전에 (5분)](#-1부-시작하기-전에-5분)
- [🎯 2부: 설치하기 (20분)](#-2부-설치하기-20분)
- [✅ 3부: 제대로 되었는지 확인 (5분)](#-3부-제대로-되었는지-확인-5분)
- [📚 4부: 첫날 해볼 것 (자유)](#-4부-첫날-해볼-것-자유)
- [🔍 5부: 용어 설명](#-5부-용어-설명)
- [🆘 6부: 문제 해결](#-6부-문제-해결)

---

## 📋 1부: 시작하기 전에 (5분)

### 이 프로젝트로 무엇을 할 수 있나요?

**간단히 말하면**: AI(Claude)가 Jira/Confluence 업무를 자동으로 도와줍니다.

**구체적으로**:
- 🤖 "오늘 할 일 뭐야?" → Claude가 Jira에서 자동으로 가져와서 보여줌
- 📊 "주간 보고서 만들어줘" → Claude가 완료한 일을 정리해서 Confluence에 자동 작성
- 💬 "이 Slack 대화 저장해줘" → 중요한 대화를 Confluence 문서로 변환
- ✅ "PROJ-123 나한테 할당해줘" → Jira에서 자동으로 담당자 지정

### 준비물 체크리스트

다음을 모두 갖고 있어야 합니다:

- ✅ **컴퓨터**: Mac 또는 Windows (Linux도 가능)
- ✅ **이메일**: 회사 이메일 주소
- ✅ **Jira 계정**: 이미 Jira를 사용하고 있어야 함
- ✅ **인터넷**: 설치 중 인터넷 연결 필요
- ✅ **관리자 권한**: 프로그램 설치 권한 (회사 컴퓨터라면 IT팀에 문의)

**모두 체크되었나요?** → 2부로 이동
**하나라도 없나요?** → 팀장/IT팀에 먼저 문의하세요

---

## 🎯 2부: 설치하기 (20분)

### 중요한 안내

⏱️ **소요 시간**: 20분 (처음이면 30분)
🔄 **실행 횟수**: 딱 1번만 (컴퓨터 바꿀 때만 다시)
⚠️ **주의사항**: 각 단계를 **순서대로** 따라하세요

---

### Mac 사용자

#### Step 1: 터미널 열기

터미널은 컴퓨터에게 명령을 내리는 "검은 화면"입니다.

1. 키보드에서 **⌘(Command) + Space** 누르기
2. "terminal" 입력
3. **Terminal.app** 클릭

![터미널 열기 - 스크린샷 필요](../assets/screenshots/mac-open-terminal.png)

**✅ 성공**: 검은색 또는 흰색 화면에 `$` 기호가 보임
**❌ 실패**: [문제 해결 섹션](#터미널을-찾을-수-없어요) 참고

---

#### Step 2: 프로젝트 다운로드

터미널에 다음 명령어를 **복사해서 붙여넣기**하세요:

```bash
git clone https://github.com/popup-studio-ai/AI-driven-work.git
cd AI-driven-work
```

**복사 방법**:
- 위 코드 블록에서 마우스로 드래그 → ⌘+C
- 터미널에서 ⌘+V

**✅ 성공**: `Cloning into 'AI-driven-work'...` 메시지 보임
**❌ 실패**: `git: command not found` 나오면 [Git 설치 필요](#git이-없다고-나와요)

---

#### Step 3: 자동 설치 스크립트 실행

터미널에 다음을 입력하세요:

```bash
./scripts/setup.sh
```

**질문이 나올 때마다**:

| 질문 | 답변 |
|------|------|
| "직군을 선택하세요 (1 또는 2)" | **2** 입력 (비개발자) |
| "Claude Code를 설치하시겠습니까?" | **y** 입력 |
| "MCP Server를 선택하세요 (1 또는 2)" | **1** 입력 (간편 설정) |
| "브라우저가 열립니다..." | 브라우저에서 **"Allow"** 클릭 |

![설치 진행 화면 - 스크린샷 필요](../assets/screenshots/mac-setup-progress.png)

**✅ 성공**: `✨ 설정 완료! ✨` 메시지가 보임
**❌ 실패**: 에러 메시지를 복사해서 [문제 해결](#설치-중-에러가-나요) 참고

---

### Windows 사용자

#### Step 1: PowerShell 열기 (관리자 권한)

PowerShell은 Windows의 명령 도구입니다.

1. **윈도우 키** 누르기
2. "PowerShell" 입력
3. **Windows PowerShell** 위에서 **우클릭**
4. **"관리자 권한으로 실행"** 선택

![PowerShell 관리자 권한 - 스크린샷 필요](../assets/screenshots/windows-open-powershell.png)

**✅ 성공**: 파란 배경에 `PS C:\>` 보임
**❌ 실패**: [문제 해결 섹션](#powershell을-찾을-수-없어요) 참고

---

#### Step 2: 실행 정책 설정 (최초 1회만)

PowerShell에서 스크립트 실행을 허용하는 설정입니다.

다음 명령어를 **복사해서 붙여넣기**:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

질문이 나오면 **Y** 입력하고 Enter

**✅ 성공**: 아무 메시지 없거나 "정책이 변경되었습니다"
**❌ 실패**: [문제 해결](#실행-정책을-변경할-수-없어요) 참고

---

#### Step 3: 프로젝트 다운로드

PowerShell에 다음 명령어를 입력:

```powershell
git clone https://github.com/popup-studio-ai/AI-driven-work.git
cd AI-driven-work
```

**✅ 성공**: `Cloning into 'AI-driven-work'...` 메시지
**❌ 실패**: `git: command not found` 나오면 [Git 설치](#git이-없다고-나와요) 필요

---

#### Step 4: 자동 설치 스크립트 실행

PowerShell에 다음을 입력:

```powershell
.\scripts\setup.ps1
```

**질문이 나올 때마다**:

| 질문 | 답변 |
|------|------|
| "직군을 선택하세요 (1 또는 2)" | **2** 입력 (비개발자) |
| "Claude Code를 설치하시겠습니까?" | **y** 입력 |
| "MCP Server를 선택하세요 (1 또는 2)" | **1** 입력 (Rovo - 간편) |
| "브라우저가 열립니다..." | 브라우저에서 **"Allow"** 클릭 |

![Windows 설치 진행 - 스크린샷 필요](../assets/screenshots/windows-setup-progress.png)

**✅ 성공**: `✨ 설정 완료! ✨`
**❌ 실패**: 에러 메시지 복사 → [문제 해결](#설치-중-에러가-나요)

---

## ✅ 3부: 제대로 되었는지 확인 (5분)

### 설치 확인 테스트

터미널(Mac) 또는 PowerShell(Windows)에서:

#### Step 1: Claude Code 실행

```bash
claude
```

**✅ 성공**: `>` 프롬프트가 나타남
**❌ 실패**: `claude: command not found` → [문제 해결](#claude-명령어를-찾을-수-없어요)

---

#### Step 2: 첫 명령어 실행

Claude 프롬프트(`>`)에서 입력:

```
/daily-standup
```

**✅ 성공**: Jira 프로젝트 목록과 할당된 이슈들이 보임
**❌ 실패**:
- "MCP 서버 연결 실패" → [MCP 연결 문제](#mcp-서버가-연결되지-않아요)
- "Jira 프로젝트를 찾을 수 없음" → [Jira 권한 문제](#jira-프로젝트가-안-보여요)

---

#### Step 3: 종료하기

Claude에서 나가려면:

```
exit
```

또는 `Ctrl + C` (Mac/Windows 공통)

---

## 📚 4부: 첫날 해볼 것 (자유)

### Claude 사용 시작하기

이제 언제든지 터미널/PowerShell에서 `claude` 입력하면 Claude와 대화할 수 있습니다.

---

### 기본 명령어 (자연어)

Claude와 **자연스럽게 대화**할 수 있습니다:

```
> 오늘 할 일 뭐야?
> 내가 완료한 작업 보여줘
> PROJ-123 이슈 상세 정보 알려줘
> 이번 주에 누가 뭐 했는지 정리해줘
```

---

### Slash Commands (단축키)

더 빠르게 실행하려면 slash commands 사용:

| 명령어 | 설명 | 예시 결과 |
|--------|------|----------|
| `/daily-standup` | 오늘 업무 현황 | 내 할일 + 미할당 이슈 목록 |
| `/weekly-report` | 주간 보고서 생성 | 완료 이슈 기반 보고서 자동 작성 |
| `/assign-me <이슈키>` | 이슈 담당자 지정 | PROJ-123을 나에게 할당 |
| `/save-slack-thread` | Slack 대화 저장 | Slack 링크를 Confluence로 변환 |

---

### 실전 예시

#### 예시 1: 아침 출근 시

```
> claude
> /daily-standup
```

**결과**:
```
📋 오늘의 할 일 (2025-11-08)

내게 할당된 이슈:
  ✅ PROJ-101: 회원가입 페이지 디자인 (In Progress)
  ⏳ PROJ-105: 로그인 화면 UI 개선 (To Do)

미할당 이슈 (팀 전체):
  🆕 PROJ-110: 비밀번호 찾기 기능 추가 (Unassigned)
  🆕 PROJ-111: 404 에러 페이지 디자인 (Unassigned)
```

---

#### 예시 2: 새 이슈 담당하기

```
> PROJ-110 나한테 할당해줘
```

**결과**:
```
✅ PROJ-110이 당신에게 할당되었습니다.

PROJ-110: 비밀번호 찾기 기능 추가
  담당자: 홍길동 (you)
  상태: To Do → In Progress로 변경됨
```

---

#### 예시 3: 금요일 오후 (주간 보고서)

```
> /weekly-report
```

**결과**:
```
📊 주간 보고서 생성 중...

완료된 이슈 (2025-11-04 ~ 2025-11-08):
  ✅ PROJ-101: 회원가입 페이지 디자인
  ✅ PROJ-105: 로그인 화면 UI 개선
  ✅ PROJ-107: 메인 페이지 레이아웃 수정

Confluence에 저장되었습니다:
https://your-company.atlassian.net/wiki/spaces/TEAM/pages/12345
```

---

## 🔍 5부: 용어 설명

### Claude Code가 뭐예요?

**간단 설명**: Jira/Confluence와 대화할 수 있는 AI 비서
**예시**: "Siri야, 내 할 일 뭐야?" 같은 느낌

**특징**:
- 💬 자연어로 대화 가능
- 🔗 Jira/Confluence에 자동 연결
- 🤖 반복 작업 자동화 (보고서 생성 등)

---

### Jira 이슈가 뭐예요?

**간단 설명**: 할 일 카드 (To-Do 리스트의 각 항목)

**종류**:
- **Epic**: 큰 프로젝트 (예: "신규 웹사이트 개발")
- **Story**: Epic의 작은 단위 (예: "회원가입 기능")
- **Task**: 구체적인 작업 (예: "로그인 버튼 디자인")
- **Sub-Task**: Task의 세부 단계 (예: "버튼 색상 결정")

**헷갈릴 때**: 그냥 "Task" 만들면 됨 (나중에 바꿀 수 있음)

---

### Epic vs Story vs Task 차이는?

**쉽게 비유**:
- 🏢 **Epic** = 빌딩 짓기 (몇 달 소요)
- 🏠 **Story** = 1층 완성하기 (1-2주 소요)
- 🧱 **Task** = 벽돌 쌓기 (1-3일 소요)
- 🔨 **Sub-Task** = 시멘트 바르기 (몇 시간)

**실무 팁**:
- 대부분 **Task** 만들면 됨
- Epic/Story는 팀장이 만들 거예요
- 궁금하면 Claude에게 물어보세요: "이거 Task로 만들까요, Story로 만들까요?"

---

### MCP가 뭐예요?

**간단 설명**: Claude와 Jira를 연결해주는 "다리"

**종류**:
1. **Rovo** (권장 - 비개발자용)
   - 설정: 2분
   - 방식: 브라우저에서 클릭 한 번
   - 무료 (베타)

2. **mcp-atlassian** (개발자용)
   - 설정: 15분
   - 방식: Docker, API 토큰 등
   - 무료 (영구)

**선택 팁**: 개발자 아니면 무조건 **Rovo** (setup.sh에서 선택지 1)

---

### API 토큰이 뭐예요?

**간단 설명**: 비밀번호 대신 쓰는 일회용 열쇠

**왜 필요한가요?**:
- Claude가 Jira에 접근하려면 "너 누구야?" 증명 필요
- 비밀번호 대신 토큰 사용 (더 안전)

**어디서 만드나요?**:
1. https://id.atlassian.com/manage-profile/security/api-tokens 방문
2. "Create API token" 클릭
3. 이름 입력 (예: "claude-code")
4. 생성된 토큰 복사 (다시 못 봄!)

**주의**: 토큰은 비밀번호처럼 절대 공유 금지!

---

### Confluence가 뭐예요?

**간단 설명**: 팀 위키 (회사용 Google Docs)

**Jira와의 차이**:
- **Jira**: 할 일 관리 (To-Do)
- **Confluence**: 지식 저장 (문서)

**실무 예시**:
- Jira: "로그인 버튼 디자인" (작업)
- Confluence: "로그인 UI 디자인 가이드라인" (문서)

---

## 🆘 6부: 문제 해결

### 터미널을 찾을 수 없어요 (Mac)

**해결 방법**:
1. Finder 열기 (Dock 하단의 파란색 얼굴)
2. 상단 메뉴 → "이동" → "유틸리티"
3. **Terminal.app** 더블클릭

**또는**:
- Spotlight 검색: ⌘ + Space → "terminal"

---

### PowerShell을 찾을 수 없어요 (Windows)

**해결 방법**:
1. 작업 표시줄 검색 (윈도우 키 옆 돋보기)
2. "PowerShell" 입력
3. **Windows PowerShell** 우클릭 → 관리자 권한

**또는**:
- `Win + X` 누르기 → "Windows PowerShell (관리자)" 선택

---

### Git이 없다고 나와요

**증상**: `git: command not found`

**해결 방법**:

#### Mac:
```bash
# Homebrew 설치 (없으면)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Git 설치
brew install git
```

#### Windows:
1. https://git-scm.com/download/win 방문
2. 다운로드 후 설치 (기본 설정으로 "Next" 계속 클릭)
3. PowerShell 다시 열기

---

### 설치 중 에러가 나요

**가장 흔한 에러**:

#### "Permission denied"
**원인**: 관리자 권한 부족
**해결**:
- Mac: `sudo ./scripts/setup.sh` (비밀번호 입력)
- Windows: PowerShell을 "관리자 권한"으로 다시 실행

#### "Node not found"
**원인**: Node.js 미설치
**해결**:
1. https://nodejs.org/ 방문
2. "LTS" 버전 다운로드 (숫자 큰 것)
3. 설치 후 터미널/PowerShell 다시 열기

#### "npm ERR!"
**원인**: 네트워크 또는 권한 문제
**해결**:
```bash
# 캐시 삭제 후 재시도
npm cache clean --force
./scripts/setup.sh
```

---

### Claude 명령어를 찾을 수 없어요

**증상**: `claude: command not found`

**해결 방법**:

#### Step 1: 설치 확인
```bash
npm list -g @anthropic-ai/claude-code
```

**나와야 할 결과**: `@anthropic-ai/claude-code@x.x.x`
**안 나오면**: `npm install -g @anthropic-ai/claude-code`

#### Step 2: PATH 확인 (Mac)
```bash
echo $PATH | grep npm
```

**아무것도 안 나오면**: 터미널 재시작

#### Step 3: 재설치
```bash
npm uninstall -g @anthropic-ai/claude-code
npm install -g @anthropic-ai/claude-code
```

---

### MCP 서버가 연결되지 않아요

**증상**: "MCP server connection failed"

**해결 방법**:

#### Step 1: 연결 상태 확인
```bash
claude mcp list
```

**나와야 할 결과**: `atlassian - connected`
**안 나오면**: Step 2로

#### Step 2: 재연결 (Rovo 사용자)
```bash
claude mcp remove atlassian
claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse
```

브라우저가 열리면 "Allow" 클릭

#### Step 3: 네트워크 확인
- 회사 VPN 연결되어 있나요?
- 방화벽이 차단하고 있나요? (IT팀 문의)

---

### Jira 프로젝트가 안 보여요

**증상**: "No projects found"

**원인**:
1. Jira 권한 없음 (프로젝트 멤버가 아님)
2. 프로젝트 키가 잘못됨
3. Atlassian 계정이 다름

**해결 방법**:

#### Step 1: Jira 웹에서 확인
1. https://your-company.atlassian.net/jira 방문
2. 프로젝트 목록 보이나요?
3. 보이면 → Claude에게 물어보기: "내 Jira 프로젝트 목록 보여줘"

#### Step 2: 계정 확인
```bash
# 현재 연결된 계정 확인
claude mcp list
```

**잘못된 계정이면**:
```bash
claude mcp remove atlassian
# 다시 설정 (올바른 계정으로 로그인)
```

---

### 실행 정책을 변경할 수 없어요 (Windows)

**증상**: "Set-ExecutionPolicy cannot be changed"

**원인**: 회사 정책으로 잠김

**해결 방법**:

#### Option 1: 현재 세션만 허용
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

#### Option 2: IT팀 요청
- "PowerShell 실행 정책을 RemoteSigned로 변경해주세요"라고 요청

#### Option 3: 대안 (WSL 사용)
- Windows Subsystem for Linux 설치 후 Mac 가이드 따라하기

---

### 그래도 안 되면?

**단계별 도움 받기**:

1. **에러 메시지 복사**
   - 빨간색 에러 전체를 복사 (Ctrl+C 또는 ⌘+C)

2. **GitHub Issue 생성**
   - https://github.com/popup-studio-ai/AI-driven-work/issues
   - "New Issue" 클릭 → 에러 메시지 붙여넣기

3. **팀원에게 물어보기**
   - 이미 설치한 동료에게 도움 요청

4. **IT팀 문의**
   - 관리자 권한, 네트워크 문제는 IT팀이 빠름

---

## 다음 단계

설치가 완료되었나요? 축하합니다! 🎉

이제 다음을 읽어보세요:

- **[Claude Code 사용 가이드](claude-code-guide.md)**: 상세한 사용법
- **[Jira 운영 규칙](jira-guidelines.md)**: Jira 이슈 관리 방법
- **[업무 플로우 예시](workflow-examples.md)**: 실제 업무 시나리오

---

## 피드백

이 가이드가 도움이 되었나요? 개선할 점이 있나요?

- 👍 좋았어요: [GitHub에 스타 남기기](https://github.com/popup-studio-ai/AI-driven-work)
- 💬 궁금해요: [GitHub Discussions](https://github.com/popup-studio-ai/AI-driven-work/discussions)
- 🐛 버그 발견: [GitHub Issues](https://github.com/popup-studio-ai/AI-driven-work/issues)

---

**작성**: POPUP STUDIO
**최종 수정**: 2025-11-08
**버전**: 1.0.0
**대상**: 완전 초보자 (비개발자)
