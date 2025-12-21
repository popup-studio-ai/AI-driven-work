# Windows 11에서 Claude Code 설치하기

> 컴퓨터 초보자도 따라할 수 있는 친절한 설치 가이드

---

## 시작하기 전에 알아두세요

### 이 가이드는 누구를 위한 건가요?

- Windows 11 컴퓨터를 사용하시는 분
- 개발 경험이 없으신 분
- Claude Code를 처음 설치하시는 분

### 설치에 얼마나 걸리나요?

**약 1시간 30분** 정도 예상됩니다. 천천히 따라오세요!

### 설치할 프로그램들

| 순서 | 프로그램 | 쉽게 말하면? |
|:---:|---------|------------|
| 1 | VS Code | 글을 쓰는 메모장 같은 프로그램이에요 |
| 2 | Git | 파일을 인터넷에서 다운받는 도구예요 |
| 3 | Node.js | Claude Code가 돌아가는 엔진이에요 |
| 4 | Docker | 특별한 프로그램 실행기예요 |
| 5 | Claude Code | AI 비서 프로그램이에요 |

### 미리 준비해주세요

- [ ] 인터넷이 연결된 Windows 11 컴퓨터
- [ ] 회사 이메일 주소
- [ ] 1시간 30분의 여유 시간

---

## 진행 상황

```
[1단계] VS Code 설치        ○○○○○○○○○○
[2단계] Git 설치           ○○○○○○○○○○
[3단계] Node.js 설치        ○○○○○○○○○○
[4단계] Docker 설치         ○○○○○○○○○○
[5단계] Claude Code 설치    ○○○○○○○○○○
[6단계] GitHub 연결         ○○○○○○○○○○
[7단계] 프로젝트 다운로드    ○○○○○○○○○○
[8단계] Jira/Confluence 연결 ○○○○○○○○○○
```

---

# 1단계: VS Code 설치하기

> **VS Code란?** 코드를 작성하고 Claude Code를 사용하는 프로그램이에요.
> 마치 "메모장의 고급 버전"이라고 생각하시면 됩니다.

## 1-1. 다운로드 받기

**① 인터넷 브라우저를 열어주세요** (크롬, 엣지 등)

**② 주소창에 아래 주소를 복사해서 붙여넣고 Enter를 눌러주세요**

```
https://code.visualstudio.com
```

**③ 파란색 "Download for Windows" 버튼을 클릭하세요**

```
┌─────────────────────────────────────┐
│                                     │
│   [Download for Windows]  ← 이 버튼!│
│                                     │
└─────────────────────────────────────┘
```

**④ 다운로드가 완료될 때까지 잠시 기다려주세요** (보통 1분 내외)

---

## 1-2. 설치하기

**① 다운로드된 파일을 찾아서 더블클릭하세요**

파일 위치: `다운로드` 폴더
파일 이름: `VSCodeUserSetup-x64-....exe`

```
📁 다운로드
   └── 📄 VSCodeUserSetup-x64-1.xx.x.exe  ← 이 파일!
```

**② "동의합니다" 체크하고 [다음] 클릭**

```
┌─────────────────────────────────────┐
│ 사용권 계약                          │
│                                     │
│ ☑ 동의합니다  ← 체크하세요!          │
│                                     │
│              [다음] ← 클릭!          │
└─────────────────────────────────────┘
```

**③ 설치 위치는 그대로 두고 [다음] 클릭**

**④ 중요! 추가 작업 선택 화면에서 아래 항목들을 체크하세요**

```
┌─────────────────────────────────────┐
│ 추가 작업 선택                       │
│                                     │
│ ☑ PATH에 추가        ← 꼭 체크!     │
│ ☑ Code로 열기 추가    ← 체크 권장    │
│                                     │
│              [다음]                  │
└─────────────────────────────────────┘
```

> ⚠️ **"PATH에 추가"는 반드시 체크해주세요!**
> 이걸 체크하지 않으면 나중에 문제가 생길 수 있어요.

**⑤ [설치] 클릭하고 기다리세요** (1~2분)

**⑥ [마침] 클릭**

---

## 1-3. 잘 설치됐는지 확인하기

**① 키보드에서 Windows 키를 누르세요** (키보드 왼쪽 하단 🪟 모양)

**② "Visual Studio Code" 라고 입력하세요**

**③ 나타난 앱을 클릭하세요**

```
┌─────────────────────────────────────┐
│ 🔍 Visual Studio Code               │
│                                     │
│ 📘 Visual Studio Code  ← 이거 클릭! │
│    앱                               │
└─────────────────────────────────────┘
```

**④ 이런 화면이 나오면 성공!**

```
┌─────────────────────────────────────┐
│ Visual Studio Code                  │
│ ─────────────────────────────────── │
│ │ Welcome │                         │
│ │         │                         │
│ │ Start   │                         │
│ │ • New   │      VS Code 화면       │
│ │ • Open  │                         │
│ │         │                         │
└─────────────────────────────────────┘
```

> ✅ **1단계 완료!** 잘 하셨어요! 다음 단계로 넘어가세요.

---

## 1-4. (선택) 한글로 바꾸기

VS Code를 한글로 사용하고 싶으시면:

**① VS Code 왼쪽에서 네모 4개 모양 아이콘 클릭**

```
┌────┬────────────────────────────────┐
│ 📄 │                                │
│ 🔍 │                                │
│ 📦 │  ← 이 아이콘 (확장)            │
│ 🐛 │                                │
│ ⬜ │                                │
└────┴────────────────────────────────┘
```

**② 검색창에 "Korean" 입력**

**③ "Korean Language Pack" 찾아서 [Install] 클릭**

**④ 오른쪽 아래에 [Restart] 버튼 나오면 클릭**

---

# 2단계: Git 설치하기

> **Git이란?** 인터넷에서 프로젝트 파일을 다운받는 도구예요.
> 마치 "특별한 다운로드 프로그램"이라고 생각하시면 됩니다.

## 2-1. 다운로드 받기

**① 브라우저 주소창에 입력하고 Enter**

```
https://git-scm.com/download/win
```

**② "64-bit Git for Windows Setup" 클릭해서 다운로드**

```
┌─────────────────────────────────────┐
│ Download for Windows                │
│                                     │
│ 64-bit Git for Windows Setup ← 클릭!│
│                                     │
└─────────────────────────────────────┘
```

---

## 2-2. 설치하기

**① 다운로드된 파일 더블클릭**

파일 이름: `Git-2.xx.x-64-bit.exe`

**② 대부분 [Next]만 계속 클릭하시면 됩니다**

**③ 단! 이 화면에서는 "Visual Studio Code" 선택하세요**

```
┌─────────────────────────────────────┐
│ Choosing the default editor         │
│                                     │
│ ○ Use Vim                           │
│ ● Use Visual Studio Code  ← 선택!   │
│ ○ Use Notepad++                     │
│                                     │
│              [Next]                  │
└─────────────────────────────────────┘
```

**④ 나머지는 계속 [Next] → [Install] → [Finish]**

---

## 2-3. 잘 설치됐는지 확인하기

**① 키보드에서 `Windows 키 + R` 동시에 누르기**

**② "cmd" 입력하고 [확인] 클릭**

```
┌─────────────────────────────────────┐
│ 실행                                │
│                                     │
│ 열기: cmd      ← 입력하세요!        │
│                                     │
│      [확인]    [취소]                │
└─────────────────────────────────────┘
```

**③ 검은 창이 열리면 아래 명령어 입력 후 Enter**

```
git --version
```

**④ 이렇게 나오면 성공!**

```
C:\Users\사용자> git --version
git version 2.43.0.windows.1   ← 이런 메시지가 나와야 해요!
```

> ✅ **2단계 완료!** 절반 가까이 왔어요!

---

# 3단계: Node.js 설치하기

> **Node.js란?** Claude Code가 실행되는 엔진이에요.
> 자동차가 움직이려면 엔진이 필요하듯, Claude Code도 Node.js가 필요해요.

## 3-1. 다운로드 받기

**① 브라우저 주소창에 입력하고 Enter**

```
https://nodejs.org
```

**② 왼쪽 초록색 "LTS" 버튼 클릭**

```
┌─────────────────────────────────────┐
│           node.js                   │
│                                     │
│  [20.x LTS]    [21.x Current]       │
│    ↑ 이거!       (이건 아님)        │
│   (권장)                            │
└─────────────────────────────────────┘
```

> 💡 **LTS**는 "Long Term Support"의 약자로, "오래 지원되는 안정적인 버전"이라는 뜻이에요.

---

## 3-2. 설치하기

**① 다운로드된 파일 더블클릭**

파일 이름: `node-v20.xx.x-x64.msi`

**② [Next] 클릭**

**③ 동의 체크하고 [Next]**

**④ 설치 위치 그대로 [Next]**

**⑤ 기능 선택 그대로 [Next]**

**⑥ 중요! 이 화면에서 체크박스를 체크하세요**

```
┌─────────────────────────────────────┐
│ Tools for Native Modules            │
│                                     │
│ ☑ Automatically install the         │
│   necessary tools...   ← 체크!      │
│                                     │
│              [Next]                  │
└─────────────────────────────────────┘
```

**⑦ [Install] 클릭 → 기다리기**

**⑧ [Finish] 클릭**

---

## 3-3. 추가 도구 설치 (자동으로 시작됨)

설치 완료 후 검은 창이 자동으로 열려요:

```
┌─────────────────────────────────────┐
│                                     │
│ Press any key to continue...        │
│                                     │
└─────────────────────────────────────┘
```

**① 아무 키나 누르세요** (스페이스바, Enter 등)

**② 설치가 진행됩니다** (5~10분 걸려요, 커피 한 잔 하고 오세요 ☕)

**③ 완료되면 창이 자동으로 닫혀요**

---

## 3-4. 잘 설치됐는지 확인하기

> ⚠️ **중요!** 반드시 **새로운** 명령 프롬프트 창을 열어야 해요!
> 이전에 열어둔 창에서는 안 될 수 있어요.

**① `Windows 키 + R` → "cmd" → [확인]** (새 창 열기)

**② 아래 명령어 입력 후 Enter**

```
node --version
```

**③ 버전 번호가 나오면 성공!**

```
v20.10.0   ← 이런 식으로 나와야 해요
```

**④ 하나 더 확인! 아래 명령어도 입력**

```
npm --version
```

```
10.2.3   ← 이런 식으로 나와야 해요
```

> ✅ **3단계 완료!** 이제 절반 넘었어요!

---

# 4단계: Docker 설치하기

> **Docker란?** 특별한 프로그램들을 실행하는 상자예요.
> Jira/Confluence와 Claude Code를 연결할 때 필요해요.

## 4-1. 먼저 WSL 설치하기 (필수!)

Docker를 설치하기 전에 WSL이라는 걸 먼저 설치해야 해요.

> 💡 **WSL**은 Windows에서 리눅스를 실행하게 해주는 기능이에요.

**① Windows 키 누르고 "PowerShell" 입력**

**② "Windows PowerShell"을 마우스 오른쪽 버튼으로 클릭**

**③ "관리자 권한으로 실행" 클릭**

```
┌─────────────────────────────────────┐
│ Windows PowerShell                  │
│                                     │
│   열기                              │
│   관리자 권한으로 실행  ← 이거 클릭!│
│   파일 위치 열기                    │
└─────────────────────────────────────┘
```

**④ 파란 창이 열리면 아래 명령어 입력 후 Enter**

```
wsl --install
```

**⑤ 설치 완료 메시지가 나올 때까지 기다리기**

**⑥ 컴퓨터 재시작하기** (반드시!)

```
┌─────────────────────────────────────────┐
│                                         │
│  ⚠️  지금 컴퓨터를 재시작해주세요!       │
│                                         │
│  시작 메뉴 → 전원 → 다시 시작            │
│                                         │
└─────────────────────────────────────────┘
```

---

## 4-2. Docker 다운로드 받기

재시작 후:

**① 브라우저 주소창에 입력하고 Enter**

```
https://www.docker.com/products/docker-desktop
```

**② "Download for Windows" 버튼 클릭**

---

## 4-3. Docker 설치하기

**① 다운로드된 파일 더블클릭**

파일 이름: `Docker Desktop Installer.exe`

**② 설정 화면에서 두 항목 모두 체크되어 있는지 확인**

```
┌─────────────────────────────────────┐
│ Configuration                       │
│                                     │
│ ☑ Use WSL 2 instead of Hyper-V     │
│   ↑ 이거 체크되어 있어야 해요!      │
│                                     │
│ ☑ Add shortcut to desktop          │
│                                     │
│              [Ok]                    │
└─────────────────────────────────────┘
```

**③ [Ok] 클릭하고 설치 기다리기** (5~10분)

**④ 설치 완료되면 [Close and restart] 클릭**

> ⚠️ 컴퓨터가 다시 시작됩니다!

---

## 4-4. Docker 처음 실행하기

재시작 후:

**① 바탕화면에서 "Docker Desktop" 아이콘 더블클릭**

```
🐳 Docker Desktop   ← 고래 모양 아이콘
```

**② 약관 동의 화면**
- "I accept the terms" 체크
- [Accept] 클릭

**③ 로그인 화면**
- [Continue without signing in] 클릭 (로그인 안 해도 돼요!)

**④ 설문 화면**
- [Skip] 클릭

**⑤ Docker 메인 화면이 나오면 성공!**

---

## 4-5. Docker 실행 확인하기

**① 화면 오른쪽 아래 시스템 트레이에서 고래 아이콘 확인**

```
작업표시줄 오른쪽 → 🐳 (고래 모양)

고래가 움직이면: 아직 준비 중...
고래가 멈추면: 준비 완료! ✅
```

**② 명령 프롬프트에서 확인**

```
docker --version
```

```
Docker version 24.0.7, build afdd53b   ← 이렇게 나오면 성공!
```

> ✅ **4단계 완료!** 이제 정말 많이 왔어요!

---

# 5단계: Claude Code 설치하기

> 드디어 Claude Code를 설치합니다!

## 5-1. Claude Code 설치하기

**① 명령 프롬프트 열기** (`Windows 키 + R` → "cmd" → [확인])

**② 아래 명령어 복사해서 붙여넣고 Enter**

```
npm install -g @anthropic-ai/claude-code
```

> 💡 **복사 붙여넣기 방법**
> 1. 위 명령어 드래그해서 선택
> 2. `Ctrl + C` (복사)
> 3. 명령 프롬프트 창에서 마우스 오른쪽 클릭 (붙여넣기됨)
> 4. Enter

**③ 설치가 진행됩니다** (1~2분)

```
여러 줄의 텍스트가 막 나타나요... 정상이에요!

...
added 123 packages in 45s   ← 이 메시지가 나오면 완료!
```

---

## 5-2. 설치 확인하기

```
claude --version
```

```
claude-code version 1.x.x   ← 이렇게 나오면 성공!
```

---

## 5-3. Claude Code 처음 설정하기

**① Claude Code 실행**

```
claude
```

**② API 키 입력하라고 나와요**

```
Enter your Anthropic API key:
█   ← 여기에 키를 붙여넣으세요
```

**③ 팀에서 받은 API 키 붙여넣기**
- API 키는 `sk-ant-api03-` 로 시작해요
- `Ctrl + V`로 붙여넣기
- Enter 누르기

**④ 설정 완료!**

---

## 5-4. API 키가 없다면? 직접 발급받기

**① 브라우저에서**

```
https://console.anthropic.com
```

**② 로그인 또는 회원가입**

**③ 왼쪽 메뉴에서 "API Keys" 클릭**

**④ "Create Key" 버튼 클릭**

**⑤ 이름 입력** (예: "work-laptop")

**⑥ "Create Key" 클릭**

**⑦ 생성된 키 복사하기**

```
┌─────────────────────────────────────────┐
│                                         │
│  ⚠️  이 키는 한 번만 보여요!             │
│     지금 복사해서 안전한 곳에 저장하세요! │
│                                         │
└─────────────────────────────────────────┘
```

> ✅ **5단계 완료!** Claude Code 설치 끝!

---

# 6단계: GitHub 연결하기

> **GitHub란?** 우리 팀의 프로젝트 파일이 저장된 곳이에요.

## 6-1. Git에 내 정보 등록하기

**① 명령 프롬프트 열기**

**② 아래 명령어에서 이름을 본인 이름으로 바꿔서 입력**

```
git config --global user.name "홍길동"
```

> ⚠️ 따옴표(" ") 안에 본인 이름을 넣으세요!

**③ 아래 명령어에서 이메일을 본인 회사 이메일로 바꿔서 입력**

```
git config --global user.email "gildong@popupstudio.ai"
```

**④ 제대로 입력됐는지 확인**

```
git config --global --list
```

```
user.name=홍길동
user.email=gildong@popupstudio.ai   ← 이렇게 나오면 성공!
```

---

## 6-2. GitHub 계정 만들기

이미 계정이 있으시면 6-3으로 넘어가세요!

**① 브라우저에서**

```
https://github.com
```

**② [Sign up] 클릭**

**③ 회사 이메일로 가입**
- Email: 회사 이메일 입력
- Password: 비밀번호 설정
- Username: 원하는 이름 (예: `gildong-popup`)

**④ 이메일로 온 인증 코드 입력**

---

## 6-3. GitHub 토큰 발급받기

> 💡 **토큰이란?** GitHub에서 파일을 다운받을 때 필요한 특별한 비밀번호예요.

**① 브라우저에서**

```
https://github.com/settings/tokens
```

**② [Generate new token] → [Generate new token (classic)] 클릭**

**③ 설정하기**

```
┌─────────────────────────────────────┐
│ New personal access token           │
│                                     │
│ Note: popup-work    ← 아무 이름     │
│                                     │
│ Expiration: 90 days ← 선택          │
│                                     │
│ Select scopes:                      │
│ ☑ repo             ← 꼭 체크!       │
│ ☑ workflow         ← 체크 권장      │
│                                     │
│        [Generate token]              │
└─────────────────────────────────────┘
```

**④ [Generate token] 클릭**

**⑤ 생성된 토큰 복사하기**

```
┌─────────────────────────────────────────┐
│                                         │
│  ⚠️  이 토큰은 한 번만 보여요!           │
│     지금 복사해서 메모장에 저장하세요!    │
│                                         │
│  ghp_xxxxxxxxxxxxxxxxxxxx               │
│                                         │
└─────────────────────────────────────────┘
```

---

## 6-4. 비밀번호 저장 설정하기

매번 비밀번호를 입력하지 않아도 되게 설정해요.

```
git config --global credential.helper manager
```

> 💡 처음 GitHub에서 파일을 다운받을 때 로그인 창이 나타나요.
> - Username: GitHub 사용자명
> - Password: 위에서 발급받은 토큰

> ✅ **6단계 완료!**

---

# 7단계: 프로젝트 다운로드하기

> 이제 우리 팀 프로젝트를 다운받아요!

## 7-1. 작업 폴더 만들기

**① 명령 프롬프트에서**

```
mkdir C:\GitHub
```

> 💡 `mkdir`은 "make directory"의 약자로, 폴더를 만드는 명령어예요.

**② 만든 폴더로 이동**

```
cd C:\GitHub
```

> 💡 `cd`는 "change directory"의 약자로, 폴더를 이동하는 명령어예요.

---

## 7-2. 프로젝트 다운로드하기

```
git clone https://github.com/popup-studio-ai/AI-driven-work.git
```

> 💡 처음 실행하면 GitHub 로그인 창이 나타날 수 있어요.
> - Username: GitHub 사용자명
> - Password: 발급받은 토큰 (ghp_xxxxx)

```
Cloning into 'AI-driven-work'...
remote: Enumerating objects: ...
Receiving objects: 100%...
done.   ← 이 메시지가 나오면 완료!
```

---

## 7-3. VS Code에서 열기

**① 다운받은 폴더로 이동**

```
cd AI-driven-work
```

**② VS Code 실행**

```
code .
```

> 💡 `code .`의 `.`은 "현재 폴더"를 의미해요.

**③ "이 폴더를 신뢰하시겠습니까?" 물으면 [Yes, I trust] 클릭**

> ✅ **7단계 완료!**

---

# 8단계: Jira/Confluence 연결하기

> Claude Code에서 Jira와 Confluence를 사용할 수 있게 연결해요!

## 8-1. 먼저 Atlassian API 토큰 발급받기

**① 브라우저에서**

```
https://id.atlassian.com/manage-profile/security/api-tokens
```

**② Atlassian 계정으로 로그인**

**③ [Create API token] 클릭**

**④ Label 입력** (예: "Claude Code")

**⑤ [Create] 클릭**

**⑥ 생성된 토큰 복사해서 메모장에 저장**

```
┌─────────────────────────────────────────┐
│                                         │
│  ⚠️  이 토큰은 한 번만 보여요!           │
│     지금 복사해서 메모장에 저장하세요!    │
│                                         │
└─────────────────────────────────────────┘
```

---

## 8-2. MCP 서버 연결하기

**① VS Code에서 터미널 열기**

방법 1: 상단 메뉴 → [터미널] → [새 터미널]
방법 2: 키보드 `` Ctrl + ` `` (백틱, 숫자 1 왼쪽 키)

**② 아래 명령어에서 본인 정보로 바꿔서 입력**

```
claude mcp add mcp-atlassian -s user -- docker run -i --rm -e ATLASSIAN_URL=https://popupstudio.atlassian.net -e ATLASSIAN_EMAIL=본인이메일@popupstudio.ai -e ATLASSIAN_API_TOKEN=발급받은토큰 ghcr.io/sooperset/mcp-atlassian:latest
```

```
바꿔야 할 부분:
├── 본인이메일@popupstudio.ai  → 본인 회사 이메일
└── 발급받은토큰              → 8-1에서 복사한 토큰
```

**예시:**
```
claude mcp add mcp-atlassian -s user -- docker run -i --rm -e ATLASSIAN_URL=https://popupstudio.atlassian.net -e ATLASSIAN_EMAIL=gildong@popupstudio.ai -e ATLASSIAN_API_TOKEN=ATATT3xFfGF0xxxx ghcr.io/sooperset/mcp-atlassian:latest
```

---

## 8-3. 연결 확인하기

```
claude mcp list
```

```
mcp-atlassian: connected   ← 이렇게 나오면 성공!
```

> ✅ **8단계 완료! 모든 설치가 끝났어요!**

---

# 설치 완료! 테스트해보기

## 모든 프로그램 확인하기

명령 프롬프트에서 하나씩 입력해보세요:

| 명령어 | 예상 결과 | 확인 |
|--------|----------|:----:|
| `code --version` | 1.xx.x | ☐ |
| `git --version` | git version 2.xx.x | ☐ |
| `node --version` | v20.x.x | ☐ |
| `docker --version` | Docker version 24.x.x | ☐ |
| `claude --version` | claude-code version 1.x.x | ☐ |
| `claude mcp list` | mcp-atlassian: connected | ☐ |

모든 항목에 체크가 되면 완벽해요!

---

## Claude Code 테스트하기

**① VS Code 터미널에서**

```
claude
```

**② Claude Code가 시작되면 입력해보세요**

```
오늘 내 할 일 보여줘
```

**③ Jira에서 본인에게 할당된 이슈가 나오면 성공!**

---

# 문제가 생겼을 때

## 자주 나오는 오류들

### "'git'은(는) 내부 또는 외부 명령...이 아닙니다"

**이유**: Git이 제대로 설치되지 않았어요.

**해결 방법**:
1. 열려있는 명령 프롬프트 창을 모두 닫기
2. 새로운 명령 프롬프트 창 열기
3. 그래도 안 되면? 컴퓨터 재시작
4. 여전히 안 되면? Git 다시 설치 (PATH 옵션 체크 확인!)

---

### "'node'은(는) 내부 또는 외부 명령...이 아닙니다"

**이유**: Node.js가 제대로 설치되지 않았어요.

**해결 방법**: Git과 동일하게 시도해보세요!

---

### Docker가 시작 안 돼요

**이유**: WSL이 제대로 설치되지 않았어요.

**해결 방법**:
1. PowerShell을 관리자 권한으로 실행
2. 입력: `wsl --update`
3. 컴퓨터 재시작
4. Docker Desktop 다시 실행

---

### "claude: command not found"

**이유**: Claude Code가 설치되지 않았어요.

**해결 방법**:
```
npm install -g @anthropic-ai/claude-code
```
다시 실행해보세요!

---

### MCP 연결이 안 돼요

**확인할 것들**:
1. Docker Desktop이 실행 중인가요? (화면 오른쪽 아래 고래 아이콘 확인)
2. API 토큰이 정확한가요?

**해결 방법**:
```
claude mcp remove mcp-atlassian
```
기존 연결 삭제 후 8-2 단계부터 다시 시도!

---

# 도움이 필요하면

설치 중 문제가 생기면 언제든 연락주세요!

- **Slack**: #ai-driven-work 채널에 질문
- **담당자**: 김경호 (kay@popupstudio.ai)

---

# 다음에 할 일

설치가 완료됐으면:

1. **[AI Driven Work 톺아보기](https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/pages/1048621)** 문서 읽기
2. **[클로드코드 커맨드 사용가이드](https://popupstudio.atlassian.net/wiki/spaces/POPUPSTUDI/pages/3538946)** 참고하기
3. 매일 아침 `/daily-standup` 명령어로 업무 시작하기!

---

**고생하셨습니다! 🎉**
