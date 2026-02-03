# Claude Code 설치 가이드

> 컴퓨터를 처음 사용하는 분도 따라할 수 있도록 작성된 설치 가이드입니다.

---

## 먼저! 파일 다운로드하기

### 방법 1: ZIP 파일로 다운로드 (추천)

1. 이 페이지 상단의 초록색 **`<> Code`** 버튼 클릭
2. **`Download ZIP`** 클릭
3. 다운로드된 ZIP 파일을 **바탕화면**에 압축 풀기
4. 압축 푼 폴더 안의 **`installer_popup`** 폴더로 이동

### 방법 2: Git으로 다운로드 (Git 설치된 경우)

터미널에서 아래 명령어 실행:

```bash
git clone https://github.com/popup-studio-ai/AI-driven-work.git
cd AI-driven-work/installer_popup
```

---

## 이 폴더에 있는 파일들은 뭔가요?

| 파일 이름 | 무슨 파일? | 누가 쓰나요? |
|----------|-----------|-------------|
| `install.ps1` | Windows 설치 프로그램 | 기획자, 디자이너, 마케터 등 |
| `install.sh` | Mac 설치 프로그램 | 기획자, 디자이너, 마케터 등 |
| `install_dev.ps1` | Windows 설치 프로그램 (개발자용) | 개발자 |
| `install_dev.sh` | Mac 설치 프로그램 (개발자용) | 개발자 |
| `setup.ps1` | Windows MCP 설정 프로그램 | 모두 |
| `setup.sh` | Mac MCP 설정 프로그램 | 모두 |

### 쉽게 설명하면

- **install** = 필요한 프로그램들을 자동으로 설치해줌
- **install_dev** = 개발자에게 필요한 프로그램까지 추가로 설치해줌
- **setup** = Jira, Confluence 연동 설정을 도와줌
- **.ps1** = Windows용 파일
- **.sh** = Mac용 파일

---

## 나는 뭘 설치해야 하나요?

### 질문 1: 컴퓨터가 Windows인가요, Mac인가요?

- **Windows** → `.ps1` 파일 사용
- **Mac** → `.sh` 파일 사용

### 질문 2: 개발자인가요?

- **아니오** (기획자, 디자이너, 마케터 등) → `install` 파일 사용
- **예** (백엔드, 프론트엔드, DevOps 등) → `install_dev` 파일 사용

### 정리

| 나는... | Windows | Mac |
|---------|---------|-----|
| 비개발자 | `install.ps1` | `install.sh` |
| 개발자 | `install_dev.ps1` | `install_dev.sh` |

---

## 설치 방법 (Windows)

### 1단계: 프로그램 설치하기

#### 비개발자라면

1. 이 폴더에서 **마우스 오른쪽 클릭**
2. **"터미널에서 열기"** 또는 **"PowerShell 창 열기"** 클릭
3. 아래 명령어를 **복사**해서 **붙여넣기** 후 **Enter**

```
powershell -ep bypass -File install.ps1
```

4. "관리자 권한이 필요합니다" 창이 뜨면 **"예"** 클릭
5. 설치가 끝날 때까지 기다리기 (자동으로 진행됨)

#### 개발자라면

1. 이 폴더에서 **마우스 오른쪽 클릭**
2. **"터미널에서 열기"** 또는 **"PowerShell 창 열기"** 클릭
3. 아래 명령어를 **복사**해서 **붙여넣기** 후 **Enter**

```
powershell -ep bypass -File install_dev.ps1
```

4. "관리자 권한이 필요합니다" 창이 뜨면 **"예"** 클릭
5. 설치가 끝날 때까지 기다리기
6. **컴퓨터 재부팅** (중요!)
7. 재부팅 후 **Docker Desktop** 프로그램 실행
8. 라이선스 동의 버튼 클릭

### 2단계: Jira/Confluence 연동하기

1. 터미널을 다시 열기
2. 아래 명령어 입력 후 **Enter**

```
powershell -ep bypass -File setup.ps1
```

3. 질문에 답하기 (아래 설명 참고)

---

## 설치 방법 (Mac)

### 1단계: 프로그램 설치하기

#### 비개발자라면

1. **Finder**에서 이 폴더 열기
2. 상단 메뉴에서 **"이동"** → **"폴더의 터미널 열기"** 클릭
   - 또는 **Spotlight** (Cmd + Space)에서 "터미널" 검색해서 열기
3. 아래 명령어를 **복사**해서 **붙여넣기** 후 **Enter**

```
chmod +x install.sh && ./install.sh
```

4. 비밀번호를 물어보면 **Mac 로그인 비밀번호** 입력 (화면에 안 보여도 정상)

#### 개발자라면

1. 터미널 열기
2. 아래 명령어 입력 후 **Enter**

```
chmod +x install_dev.sh && ./install_dev.sh
```

3. 설치 완료 후 **Docker Desktop** 실행
4. 라이선스 동의 버튼 클릭

### 2단계: Jira/Confluence 연동하기

1. 터미널에서 아래 명령어 입력

```
chmod +x setup.sh && ./setup.sh
```

2. 질문에 답하기 (아래 설명 참고)

---

## setup 실행할 때 나오는 질문들

### 질문 1: 직군 선택

```
1. Developer
2. Non-developer
Select (1 or 2):
```

- 개발자면 **1** 입력
- 아니면 **2** 입력

### 질문 2: MCP Server 선택

```
1. Rovo MCP Server (Cloud-based, Easy setup)
2. mcp-atlassian (Local Docker, Advanced)
Select (1 or 2):
```

#### 뭘 선택해야 하나요?

| 상황 | 선택 |
|------|------|
| 빠르고 쉽게 설정하고 싶다 | **1** |
| 비개발자다 | **1** |
| 개발자인데 Docker 설치했다 | **2** |
| 고급 기능이 필요하다 | **2** |

#### 1번 (Rovo MCP Server) 선택하면

- 브라우저가 열림
- Atlassian 계정으로 로그인
- "허용" 버튼 클릭
- 끝!

#### 2번 (mcp-atlassian) 선택하면

API 토큰이 필요합니다. 아래 순서대로 하세요:

1. 이 링크 열기: https://id.atlassian.com/manage-profile/security/api-tokens
2. **"API 토큰 만들기"** 버튼 클릭
3. 토큰 이름 입력 (예: MCP-ATLASSIAN)
4. **"만들기"** 클릭
5. 생성된 토큰 **복사해서 어딘가에 저장** (다시 못 봄!)

그 다음 질문에 답하기:

```
Confluence URL: https://회사이름.atlassian.net/wiki
Confluence email: 본인이메일@회사.com
Confluence API token: (위에서 복사한 토큰 붙여넣기)

Jira URL: https://회사이름.atlassian.net
Jira email: 본인이메일@회사.com
Jira API token: (위에서 복사한 토큰 붙여넣기)
```

---

## 설치 확인하기

설치가 잘 됐는지 확인해봅시다!

### VS Code에서 확인

1. **VS Code** 프로그램 실행
2. 왼쪽 사이드바에서 **Claude 아이콘** 클릭 (말풍선 모양)
3. Claude에 로그인
4. 채팅창에 입력: `Jira 프로젝트 목록 보여줘`
5. Jira 프로젝트 목록이 나오면 성공!

### 터미널에서 확인

1. 터미널 열기
2. `claude` 입력 후 Enter
3. `Jira 프로젝트 목록 보여줘` 입력
4. 결과가 나오면 성공!

---

## 뭐가 설치되나요?

### 기본 설치 (install)

| 프로그램 | 설명 |
|---------|------|
| Node.js | JavaScript 실행 환경 (Claude Code에 필요) |
| Git | 코드 버전 관리 도구 |
| VS Code | 코드 편집기 |
| Claude Code CLI | 터미널에서 Claude 사용 |
| VS Code 확장 | VS Code에서 Claude 사용 |

### 개발자용 추가 설치 (install_dev)

| 프로그램 | 설명 |
|---------|------|
| WSL | Windows에서 Linux 사용 (Windows만) |
| Docker Desktop | 컨테이너 실행 환경 |

---

## 자주 묻는 질문

### Q: "관리자 권한이 필요합니다"가 계속 떠요

**A:** "예"를 클릭하세요. 프로그램을 설치하려면 관리자 권한이 필요합니다.

### Q: 설치 중에 에러가 났어요

**A:** 터미널을 닫고 다시 시도해보세요. 인터넷 연결도 확인하세요.

### Q: API 토큰을 잃어버렸어요

**A:** 새로 만들면 됩니다. https://id.atlassian.com/manage-profile/security/api-tokens 에서 새 토큰을 생성하세요.

### Q: Docker Desktop이 안 열려요 (Windows)

**A:** 컴퓨터를 재부팅했는지 확인하세요. install_dev 설치 후에는 반드시 재부팅이 필요합니다.

### Q: "command not found" 에러가 나요

**A:** 터미널을 닫고 새로 열어보세요. 그래도 안 되면 컴퓨터를 재부팅하세요.

### Q: Jira 프로젝트가 안 보여요

**A:**
1. Atlassian 계정 로그인이 됐는지 확인
2. API 토큰을 올바르게 입력했는지 확인
3. 회사 Jira에 접근 권한이 있는지 확인

---

## 도움이 필요하면

설치 중 문제가 생기면 IT팀에 문의하세요.

**필요한 정보:**
- 어떤 파일을 실행했는지 (예: install.ps1)
- 에러 메시지가 뭐였는지 (화면 캡처하면 좋음)
- Windows인지 Mac인지
