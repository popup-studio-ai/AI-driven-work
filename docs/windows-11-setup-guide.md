# Windows 11 Pro - Claude Code 환경 세팅 가이드

이 문서는 **완전히 새로운 Windows 11 Pro PC**에서 Claude Code와 Atlassian MCP Server를 처음부터 세팅하는 방법을 단계별로 안내합니다.

---

## 목차

1. [사전 준비 사항](#1-사전-준비-사항)
2. [Node.js 설치](#2-nodejs-설치)
3. [Git 설치](#3-git-설치)
4. [VS Code 설치 (선택사항)](#4-vs-code-설치-선택사항)
5. [Claude Code 설치](#5-claude-code-설치)
6. [Docker Desktop 설치](#6-docker-desktop-설치)
7. [프로젝트 다운로드](#7-프로젝트-다운로드)
8. [Atlassian API 토큰 발급](#8-atlassian-api-토큰-발급)
9. [자동 설정 스크립트 실행](#9-자동-설정-스크립트-실행)
10. [수동 설정 (스크립트 실패 시)](#10-수동-설정-스크립트-실패-시)
11. [설치 확인 및 테스트](#11-설치-확인-및-테스트)
12. [자주 발생하는 문제 해결](#12-자주-발생하는-문제-해결)

---

## 1. 사전 준비 사항

### 필요한 것들
- Windows 11 Pro PC (관리자 권한)
- 인터넷 연결
- Atlassian 계정 (Jira/Confluence 사용 권한)
- Anthropic 계정 (Claude Code 사용)

### 소요 시간
- 전체 설치: 약 30~45분
- 다운로드 속도에 따라 변동

---

## 2. Node.js 설치

Node.js는 Claude Code 실행에 필요한 JavaScript 런타임입니다.

### 2.1 Node.js 다운로드

1. 웹 브라우저에서 다음 주소로 이동:
   ```
   https://nodejs.org/ko
   ```

2. **LTS (장기 지원 버전)** 버튼 클릭하여 다운로드
   - 파일명 예시: `node-v20.x.x-x64.msi`

### 2.2 Node.js 설치

1. 다운로드된 `.msi` 파일 실행
2. **Next** 클릭
3. **I accept the terms in the License Agreement** 체크 후 **Next**
4. 설치 경로 확인 (기본값 유지 권장) 후 **Next**
5. **Next** 클릭 (기본 구성 요소 유지)
6. **Automatically install the necessary tools...** 체크박스 **체크하지 않음**
7. **Install** 클릭
8. UAC 팝업이 나오면 **예** 클릭
9. 설치 완료 후 **Finish** 클릭

### 2.3 설치 확인

1. `Windows 키 + R` 눌러 실행 창 열기
2. `cmd` 입력 후 Enter
3. 명령 프롬프트에서 다음 명령어 실행:

```cmd
node --version
```

결과 예시:
```
v20.10.0
```

```cmd
npm --version
```

결과 예시:
```
10.2.3
```

> 버전 번호가 나오면 설치 성공!

---

## 3. Git 설치

Git은 프로젝트 코드를 다운로드하는 데 필요합니다.

### 3.1 Git 다운로드

1. 웹 브라우저에서 다음 주소로 이동:
   ```
   https://git-scm.com/download/win
   ```

2. **64-bit Git for Windows Setup** 클릭하여 다운로드
   - 파일명 예시: `Git-2.x.x-64-bit.exe`

### 3.2 Git 설치

1. 다운로드된 `.exe` 파일 실행
2. **Next** 클릭 (여러 화면에서 기본값 유지)
3. 중요 설정 화면들:
   - **Choosing the default editor**: VS Code 선택 권장 (또는 기본값 유지)
   - **Adjusting the name of the initial branch**: "main" 선택 권장
   - **PATH environment**: "Git from the command line and also from 3rd-party software" 선택
4. 나머지는 기본값으로 **Next** 클릭
5. **Install** 클릭
6. 설치 완료 후 **Finish** 클릭

### 3.3 설치 확인

새 명령 프롬프트 창을 열고:

```cmd
git --version
```

결과 예시:
```
git version 2.42.0.windows.1
```

---

## 4. VS Code 설치 (선택사항)

VS Code는 코드 편집기로, Claude Code와 함께 사용하면 편리합니다.

### 4.1 VS Code 다운로드

1. 웹 브라우저에서 다음 주소로 이동:
   ```
   https://code.visualstudio.com/
   ```

2. **Download for Windows** 버튼 클릭
   - 파일명 예시: `VSCodeUserSetup-x64-1.x.x.exe`

### 4.2 VS Code 설치

1. 다운로드된 `.exe` 파일 실행
2. 라이센스 동의 후 **Next**
3. 설치 경로 확인 후 **Next**
4. 추가 작업 선택:
   - **"Code로 열기" 작업을 Windows 탐색기 파일의 상황에 맞는 메뉴에 추가** 체크
   - **"Code로 열기" 작업을 Windows 탐색기 디렉터리의 상황에 맞는 메뉴에 추가** 체크
   - **PATH에 추가** 체크 (중요!)
5. **Install** 클릭
6. 설치 완료 후 **Finish** 클릭

---

## 5. Claude Code 설치

### 5.1 Claude Code 설치

1. 명령 프롬프트 또는 PowerShell을 **관리자 권한으로** 실행:
   - `Windows 키` 누르고 "cmd" 또는 "powershell" 검색
   - **관리자 권한으로 실행** 클릭

2. 다음 명령어 실행:

```cmd
npm install -g @anthropic-ai/claude-code
```

설치 진행 중 메시지가 나타나면 기다립니다. 완료까지 1~3분 소요.

### 5.2 설치 확인

```cmd
claude --version
```

버전 정보가 나오면 설치 성공!

### 5.3 Claude Code 최초 실행 및 인증

1. 명령 프롬프트에서 실행:

```cmd
claude
```

2. 처음 실행 시 Anthropic 계정 인증이 필요합니다:
   - 브라우저가 자동으로 열립니다
   - Anthropic 계정으로 로그인
   - "Allow" 버튼 클릭하여 권한 승인
   - 터미널로 돌아오면 인증 완료

3. Claude Code 프롬프트가 나타나면 성공:
   ```
   claude>
   ```

4. 종료하려면:
   ```
   /exit
   ```

---

## 6. Docker Desktop 설치

Docker는 mcp-atlassian 서버를 실행하는 데 필요합니다.

> **참고**: Rovo MCP Server(클라우드 방식)를 사용할 경우 Docker 설치가 필요 없습니다.
> 하지만 mcp-atlassian(로컬 방식)은 더 많은 기능과 무제한 사용을 제공합니다.

### 6.1 Docker Desktop 다운로드

1. 웹 브라우저에서 다음 주소로 이동:
   ```
   https://www.docker.com/products/docker-desktop/
   ```

2. **Download for Windows** 버튼 클릭
   - 파일명 예시: `Docker Desktop Installer.exe`

### 6.2 Docker Desktop 설치

1. 다운로드된 `.exe` 파일 실행
2. **Configuration** 화면에서:
   - **Use WSL 2 instead of Hyper-V** 체크 (권장)
   - **Add shortcut to desktop** 체크
3. **Ok** 클릭하여 설치 시작
4. 설치 완료 후 **Close and restart** 클릭 (PC 재시작)

### 6.3 Docker Desktop 설정

1. PC 재시작 후 Docker Desktop 자동 실행
   - 또는 시작 메뉴에서 "Docker Desktop" 검색하여 실행
2. 서비스 약관 동의
3. **Skip** 또는 **Continue without signing in** 클릭 (로그인 불필요)
4. 시스템 트레이(우하단)에 Docker 아이콘이 나타나면 준비 완료

### 6.4 설치 확인

명령 프롬프트에서:

```cmd
docker --version
```

결과 예시:
```
Docker version 24.0.6, build ed223bc
```

---

## 7. 프로젝트 다운로드

### 7.1 작업 폴더 생성 및 이동

1. 명령 프롬프트 또는 PowerShell 실행
2. 다음 명령어 실행:

```cmd
cd %USERPROFILE%\Documents
mkdir GitHub
cd GitHub
```

### 7.2 프로젝트 복제

```cmd
git clone https://github.com/your-org/AI-driven-work.git
cd AI-driven-work
```

> **참고**: 실제 저장소 URL은 회사에서 제공받으세요.

또는 ZIP 파일로 다운로드한 경우:
1. ZIP 파일 압축 해제
2. 폴더를 `C:\Users\[사용자명]\Documents\GitHub\` 위치로 이동
3. 명령 프롬프트에서:

```cmd
cd %USERPROFILE%\Documents\GitHub\AI-driven-work
```

---

## 8. Atlassian API 토큰 발급

### 8.1 API 토큰 생성

1. 웹 브라우저에서 다음 주소로 이동:
   ```
   https://id.atlassian.com/manage-profile/security/api-tokens
   ```

2. Atlassian 계정으로 로그인

3. **Create API token** 버튼 클릭

4. 토큰 정보 입력:
   - **Label**: `claude-code` 또는 `MCP-ATLASSIAN` (원하는 이름)

5. **Create** 클릭

6. **생성된 토큰을 복사하여 안전한 곳에 저장**
   - 이 창을 닫으면 토큰을 다시 볼 수 없습니다!
   - 메모장이나 비밀번호 관리자에 저장하세요

### 8.2 필요한 정보 정리

설정에 필요한 정보를 미리 정리해두세요:

| 항목 | 예시 | 내 정보 |
|------|------|---------|
| Jira URL | `https://회사명.atlassian.net` | |
| Confluence URL | `https://회사명.atlassian.net/wiki` | |
| 이메일 | `name@company.com` | |
| API 토큰 | `ABCdef123...` | |

---

## 9. 자동 설정 스크립트 실행

### 9.1 PowerShell 실행 정책 변경

1. **PowerShell을 관리자 권한으로 실행**:
   - `Windows 키` 누르고 "powershell" 검색
   - **관리자 권한으로 실행** 클릭

2. 실행 정책 변경:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. 확인 메시지가 나오면 `Y` 입력 후 Enter

### 9.2 프로젝트 폴더로 이동

```powershell
cd $env:USERPROFILE\Documents\GitHub\AI-driven-work
```

### 9.3 설정 스크립트 실행

```powershell
.\scripts\setup.ps1
```

### 9.4 스크립트 안내 따라가기

스크립트가 실행되면 대화형으로 진행됩니다:

1. **직군 선택**
   ```
   1. 개발자 (백엔드/프론트엔드/DevOps/QA)
   2. 비개발자 (기획/디자인/마케팅/운영)
   직군을 선택하세요 (1 또는 2):
   ```
   - 해당하는 번호 입력 후 Enter

2. **MCP Server 선택**
   ```
   1. Rovo MCP Server (클라우드 기반, 간편 설정)
   2. mcp-atlassian (로컬 Docker 기반, 고급 기능)
   선택하세요 (1 또는 2):
   ```

   **추천**:
   - 비개발자: `1` (Rovo MCP Server) - 설정이 간단함
   - 개발자: `2` (mcp-atlassian) - 기능이 더 많음

3. **Rovo MCP Server 선택 시** (옵션 1):
   - 자동으로 설정이 완료됩니다
   - 브라우저가 열리면 Atlassian 계정으로 로그인

4. **mcp-atlassian 선택 시** (옵션 2):
   - Jira URL 입력 (예: `https://회사명.atlassian.net`)
   - 이메일 입력
   - API 토큰 입력 (입력 시 화면에 표시되지 않음 - 보안)
   - 사용 범위 선택 (1: 모든 프로젝트, 2: 현재 프로젝트만)

### 9.5 설정 완료 확인

스크립트가 완료되면 다음과 같은 메시지가 표시됩니다:

```
==========================================
✨ 설정 완료! ✨
==========================================

다음 단계:
1. PowerShell 또는 터미널에서 Claude Code 실행:
   claude

2. 연결 테스트:
   > Jira 프로젝트 목록 보여줘

3. 첫 slash command 실행:
   > /daily-standup
```

---

## 10. 수동 설정 (스크립트 실패 시)

스크립트가 실패한 경우 수동으로 설정할 수 있습니다.

### 10.1 방법 A: Rovo MCP Server (클라우드 방식)

가장 간단한 방법입니다.

1. 명령 프롬프트 또는 PowerShell 실행

2. 다음 명령어 실행:

```cmd
claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse
```

3. Claude Code 실행 시 브라우저가 열리면:
   - Atlassian 계정으로 로그인
   - "Allow" 버튼 클릭

### 10.2 방법 B: mcp-atlassian (로컬 Docker 방식)

#### Step 1: Docker 이미지 다운로드

```cmd
docker pull ghcr.io/sooperset/mcp-atlassian:latest
```

#### Step 2: 환경 변수 파일 생성

1. 설정 폴더 생성:

```cmd
mkdir %USERPROFILE%\.mcp-atlassian
```

2. 메모장으로 환경 변수 파일 생성:

```cmd
notepad %USERPROFILE%\.mcp-atlassian\.env
```

3. 다음 내용을 입력하고 저장 (실제 값으로 교체):

```
# Confluence 설정
CONFLUENCE_URL=https://회사명.atlassian.net/wiki
CONFLUENCE_USERNAME=your-email@company.com
CONFLUENCE_API_TOKEN=your-api-token

# Jira 설정
JIRA_URL=https://회사명.atlassian.net
JIRA_USERNAME=your-email@company.com
JIRA_API_TOKEN=your-api-token
```

> **주의**: API 토큰에 특수문자가 있으면 따옴표로 감싸세요:
> ```
> JIRA_API_TOKEN="your-api-token-with-special-chars"
> ```

#### Step 3: Claude Code에 MCP 서버 등록

```cmd
claude mcp add --scope user --transport stdio mcp-atlassian -- docker run -i --rm --env-file %USERPROFILE%\.mcp-atlassian\.env ghcr.io/sooperset/mcp-atlassian:latest
```

### 10.3 Slash Commands 복사

1. 설정 폴더 생성:

```cmd
mkdir %USERPROFILE%\.config\claude\.claude\commands
```

2. 명령어 파일 복사:

```cmd
copy %USERPROFILE%\Documents\GitHub\AI-driven-work\.claude\commands\* %USERPROFILE%\.config\claude\.claude\commands\
```

---

## 11. 설치 확인 및 테스트

### 11.1 MCP 서버 연결 확인

```cmd
claude mcp list
```

결과 예시:
```
mcp-atlassian   stdio   docker run -i --rm ...   Connected
```

또는 Rovo 방식의 경우:
```
atlassian   sse   https://mcp.atlassian.com/v1/sse   Connected
```

### 11.2 Claude Code 실행 및 테스트

1. Claude Code 실행:

```cmd
claude
```

2. Jira 연결 테스트:

```
Jira 프로젝트 목록 보여줘
```

3. Confluence 연결 테스트:

```
Confluence 스페이스 목록 보여줘
```

4. Slash Command 테스트:

```
/daily-standup
```

### 11.3 성공적인 테스트 결과 예시

```
claude> Jira 프로젝트 목록 보여줘

현재 접근 가능한 Jira 프로젝트 목록입니다:

1. PROJ - 메인 프로젝트
2. DEV - 개발 프로젝트
3. SUPPORT - 지원 프로젝트
...
```

---

## 12. 자주 발생하는 문제 해결

### 문제 1: `node`를 찾을 수 없음

**증상:**
```
'node'은(는) 내부 또는 외부 명령, 실행할 수 있는 프로그램, 또는 배치 파일이 아닙니다.
```

**해결:**
1. Node.js가 설치되어 있는지 확인
2. 새 명령 프롬프트 창 열기 (환경 변수 새로고침)
3. 여전히 안 되면 PC 재시작

### 문제 2: `claude`를 찾을 수 없음

**증상:**
```
'claude'은(는) 내부 또는 외부 명령, 실행할 수 있는 프로그램, 또는 배치 파일이 아닙니다.
```

**해결:**
1. Claude Code 재설치:
   ```cmd
   npm uninstall -g @anthropic-ai/claude-code
   npm install -g @anthropic-ai/claude-code
   ```
2. 새 명령 프롬프트 창 열기

### 문제 3: Docker 실행 오류

**증상:**
```
error during connect: ... : The system cannot find the file specified.
```

**해결:**
1. Docker Desktop이 실행 중인지 확인 (시스템 트레이 아이콘)
2. Docker Desktop을 시작하고 "Docker Desktop is running" 메시지 확인
3. 명령 프롬프트를 새로 열고 다시 시도

### 문제 4: API 토큰 인증 실패

**증상:**
```
401 Unauthorized
```

**해결:**
1. API 토큰이 정확히 복사되었는지 확인
2. 이메일 주소가 정확한지 확인
3. URL에 오타가 없는지 확인 (https:// 포함)
4. 새 API 토큰 발급 후 재시도

### 문제 5: PowerShell 스크립트 실행 불가

**증상:**
```
파일을 로드할 수 없습니다. ... 디지털 서명되어 있지 않습니다.
```

**해결:**
1. PowerShell을 관리자 권한으로 실행
2. 실행 정책 변경:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   ```
3. 스크립트 다시 실행

### 문제 6: WSL 관련 오류

**증상:**
```
WSL 2 requires an update to its kernel component.
```

**해결:**
1. WSL 업데이트 설치:
   ```cmd
   wsl --update
   ```
2. PC 재시작
3. Docker Desktop 다시 실행

### 문제 7: MCP 서버 연결 실패

**증상:**
```
mcp-atlassian   stdio   ...   Failed to connect
```

**해결:**
1. Docker Desktop이 실행 중인지 확인
2. `.env` 파일 내용 확인:
   ```cmd
   type %USERPROFILE%\.mcp-atlassian\.env
   ```
3. MCP 서버 제거 후 재등록:
   ```cmd
   claude mcp remove mcp-atlassian
   claude mcp add --scope user --transport stdio mcp-atlassian -- docker run -i --rm --env-file %USERPROFILE%\.mcp-atlassian\.env ghcr.io/sooperset/mcp-atlassian:latest
   ```

---

## 부록: 유용한 명령어 모음

### Claude Code 관련

```cmd
# Claude Code 실행
claude

# Claude Code 버전 확인
claude --version

# MCP 서버 목록 확인
claude mcp list

# MCP 서버 추가
claude mcp add [name] [url]

# MCP 서버 제거
claude mcp remove [name]
```

### Docker 관련

```cmd
# Docker 버전 확인
docker --version

# 실행 중인 컨테이너 확인
docker ps

# Docker 이미지 목록
docker images

# Docker 이미지 삭제
docker rmi [image-name]
```

### Node.js 관련

```cmd
# Node.js 버전 확인
node --version

# npm 버전 확인
npm --version

# 글로벌 패키지 목록
npm list -g --depth=0

# 글로벌 패키지 업데이트
npm update -g @anthropic-ai/claude-code
```

---

## 체크리스트

설치가 완료되었는지 확인하세요:

- [ ] Node.js 설치 완료 (`node --version` 실행 가능)
- [ ] npm 설치 완료 (`npm --version` 실행 가능)
- [ ] Git 설치 완료 (`git --version` 실행 가능)
- [ ] Claude Code 설치 완료 (`claude --version` 실행 가능)
- [ ] Docker Desktop 설치 완료 (`docker --version` 실행 가능)
- [ ] Atlassian API 토큰 발급 완료
- [ ] MCP 서버 연결 완료 (`claude mcp list`에서 Connected 확인)
- [ ] Claude Code에서 Jira 연동 테스트 성공
- [ ] Slash command (`/daily-standup`) 실행 성공

---

## 다음 단계

설치가 완료되었다면:

1. **사용 가이드 읽기**: `docs/claude-code-guide.md`
2. **Jira 운영 규칙 확인**: `docs/jira-guidelines.md`
3. **Confluence 운영 규칙 확인**: `docs/confluence-guidelines.md`
4. **워크플로우 예시 보기**: `docs/workflow-examples.md`

---

## 도움이 필요하면

- **사내 IT 팀**: 설치 및 네트워크 문제
- **프로젝트 리더**: Jira/Confluence 권한 문제
- **Claude Code 공식 문서**: https://docs.anthropic.com/claude-code

---

**문서 버전**: 1.0
**최종 업데이트**: 2025-12-01
**대상 OS**: Windows 11 Pro
