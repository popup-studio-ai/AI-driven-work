#!/usr/bin/env python3
"""
Jira 주간 이슈 수집 스크립트

팀원별 Jira 이슈를 수집하여 요약된 JSON 파일로 저장합니다.
Claude의 context 제한을 피하기 위해 로컬에서 데이터를 전처리합니다.

사용법:
    python collect-jira-issues.py --start 2026-01-05 --end 2026-01-11 --next-start 2026-01-12 --next-end 2026-01-18

출력:
    /tmp/weekly-report/jira-issues-YYYYMMDD.json
"""

import argparse
import json
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Any
import base64
import urllib.request
import urllib.error
import urllib.parse

# 팀원 목록 (이메일 기준으로 Jira 조회)
TEAM_MEMBERS = [
    {"name": "김태형", "email": "taekim@popupstudio.ai"},
    {"name": "김명일", "email": "reinhard@popupstudio.ai"},
    {"name": "김경호", "email": "kay@popupstudio.ai"},
    {"name": "김용운", "email": "koyu@popupstudio.ai"},
    {"name": "박선영", "email": "sypark@popupstudio.ai"},
    {"name": "이승준", "email": "steve@popupstudio.ai"},
    {"name": "최준호", "email": "jack@popupstudio.ai"},
    {"name": "김민수", "email": "mskim@popupstudio.ai"},
    {"name": "김현진", "email": "jacob@popupstudio.ai"},
    {"name": "이병일", "email": "lion@popupstudio.ai"},
    {"name": "노원대", "email": "drwon@popupstudio.ai"},
    {"name": "황인준", "email": "injunh@popupstudio.ai"},
]

# Jira 프로젝트
PROJECTS = ["PS", "BK", "BKAM"]


def load_env_file(env_path: str) -> dict:
    """환경 변수 파일 로드"""
    env_vars = {}
    try:
        with open(env_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip().strip('"').strip("'")
    except FileNotFoundError:
        print(f"Error: 환경 변수 파일을 찾을 수 없습니다: {env_path}")
        sys.exit(1)
    return env_vars


class JiraClient:
    """Jira REST API 클라이언트 (2024년 신규 API 사용)"""

    def __init__(self, base_url: str, username: str, api_token: str):
        self.base_url = base_url.rstrip('/')
        self.auth = base64.b64encode(f"{username}:{api_token}".encode()).decode()

    def _post_request(self, endpoint: str, data: dict) -> dict:
        """POST API 요청 실행"""
        url = f"{self.base_url}/rest/api/3/{endpoint}"

        req = urllib.request.Request(url, method='POST')
        req.add_header('Authorization', f'Basic {self.auth}')
        req.add_header('Accept', 'application/json')
        req.add_header('Content-Type', 'application/json')
        req.data = json.dumps(data).encode('utf-8')

        try:
            with urllib.request.urlopen(req, timeout=30) as response:
                return json.loads(response.read().decode())
        except urllib.error.HTTPError as e:
            error_body = e.read().decode() if e.fp else ''
            print(f"HTTP Error {e.code}: {e.reason} - {error_body[:200]}")
            return {"issues": []}
        except urllib.error.URLError as e:
            print(f"URL Error: {e.reason}")
            return {"issues": []}
        except Exception as e:
            print(f"Error: {e}")
            return {"issues": []}

    def search_issues(self, jql: str, fields: list = None, max_results: int = 100) -> list:
        """JQL로 이슈 검색 (신규 /search/jql API 사용)"""
        all_issues = []
        next_page_token = None

        default_fields = [
            "key", "summary", "status", "issuetype", "priority",
            "updated", "resolutiondate", "duedate", "project",
            "assignee", "reporter", "parent", "description", "created"
        ]

        while len(all_issues) < max_results:
            data = {
                'jql': jql,
                'maxResults': min(50, max_results - len(all_issues)),
                'fields': fields or default_fields
            }

            if next_page_token:
                data['nextPageToken'] = next_page_token

            result = self._post_request('search/jql', data)
            issues = result.get('issues', [])
            all_issues.extend(issues)

            # 페이지네이션 확인
            next_page_token = result.get('nextPageToken')
            is_last = result.get('isLast', True)

            if is_last or not next_page_token or not issues:
                break

        return all_issues


def extract_issue_summary(issue: dict) -> dict:
    """이슈에서 필요한 필드만 추출"""
    fields = issue.get('fields', {})

    # Assignee 정보
    assignee = fields.get('assignee') or {}
    assignee_name = assignee.get('displayName', 'Unassigned')
    assignee_email = assignee.get('emailAddress', '')

    # Reporter 정보
    reporter = fields.get('reporter') or {}
    reporter_name = reporter.get('displayName', 'Unknown')

    # Project 정보
    project = fields.get('project') or {}
    project_key = project.get('key', '')

    # Status 정보
    status = fields.get('status') or {}
    status_name = status.get('name', '')
    status_category = status.get('statusCategory', {}).get('name', '')

    # Issue type
    issuetype = fields.get('issuetype') or {}
    issuetype_name = issuetype.get('name', '')

    # Priority
    priority = fields.get('priority') or {}
    priority_name = priority.get('name', '')

    # Parent (for subtasks)
    parent = fields.get('parent') or {}
    parent_key = parent.get('key', '')
    parent_summary = parent.get('fields', {}).get('summary', '') if parent else ''

    # Description (truncate if too long)
    description = fields.get('description', '') or ''
    if isinstance(description, dict):
        # ADF format - extract text content
        description = extract_text_from_adf(description)
    if len(description) > 500:
        description = description[:500] + '...'

    return {
        'key': issue.get('key', ''),
        'summary': fields.get('summary', ''),
        'project': project_key,
        'status': status_name,
        'status_category': status_category,
        'issuetype': issuetype_name,
        'priority': priority_name,
        'assignee': assignee_name,
        'assignee_email': assignee_email,
        'reporter': reporter_name,
        'created': fields.get('created', ''),
        'updated': fields.get('updated', ''),
        'resolutiondate': fields.get('resolutiondate', ''),
        'duedate': fields.get('duedate', ''),
        'parent_key': parent_key,
        'parent_summary': parent_summary,
        'description': description
    }


def extract_text_from_adf(adf: dict) -> str:
    """Atlassian Document Format에서 텍스트 추출"""
    if not isinstance(adf, dict):
        return str(adf)

    text_parts = []

    def traverse(node):
        if isinstance(node, dict):
            if node.get('type') == 'text':
                text_parts.append(node.get('text', ''))
            for child in node.get('content', []):
                traverse(child)
        elif isinstance(node, list):
            for item in node:
                traverse(item)

    traverse(adf)
    return ' '.join(text_parts)


def collect_member_issues(client: JiraClient, member: dict, start_date: str, end_date: str, next_start: str, next_end: str) -> dict:
    """팀원별 이슈 수집"""
    email = member['email']
    result = {
        'name': member['name'],
        'email': email,
        'updated_this_week': [],
        'completed_this_week': [],
        'in_progress': [],
        'next_week_planned': [],
        'reported_by_me': []
    }

    projects_jql = 'project in (PS, BK, BKAM)'

    # 1. 이번 주 변경된 모든 이슈
    jql = f'{projects_jql} AND assignee = "{email}" AND updated >= "{start_date}" AND updated <= "{end_date}" ORDER BY updated DESC'
    issues = client.search_issues(jql)
    result['updated_this_week'] = [extract_issue_summary(i) for i in issues]
    print(f"  - 이번 주 변경: {len(issues)}건")

    # 2. 이번 주 완료된 이슈 (Done/완료 상태인 것들 필터링)
    completed = [i for i in result['updated_this_week']
                 if i['status_category'] in ('Done', '완료') and i['resolutiondate']
                 and i['resolutiondate'][:10] >= start_date]
    result['completed_this_week'] = completed
    print(f"  - 완료: {len(completed)}건")

    # 3. 현재 진행 중인 이슈
    jql = f'{projects_jql} AND assignee = "{email}" AND status in ("In Progress", "진행 중") ORDER BY priority DESC, updated DESC'
    issues = client.search_issues(jql)
    result['in_progress'] = [extract_issue_summary(i) for i in issues]
    print(f"  - 진행 중: {len(issues)}건")

    # 4. 다음 주 예정 작업
    jql = f'{projects_jql} AND assignee = "{email}" AND (status in ("To Do", "Backlog", "Open", "해야 할 일") OR (dueDate >= "{next_start}" AND dueDate <= "{next_end}")) ORDER BY priority DESC, dueDate ASC'
    issues = client.search_issues(jql)
    result['next_week_planned'] = [extract_issue_summary(i) for i in issues]
    print(f"  - 다음 주 예정: {len(issues)}건")

    # 5. 본인이 생성한 이슈 (다른 사람에게 할당된 것)
    jql = f'{projects_jql} AND reporter = "{email}" AND updated >= "{start_date}" AND updated <= "{end_date}" AND assignee != "{email}" ORDER BY updated DESC'
    issues = client.search_issues(jql)
    result['reported_by_me'] = [extract_issue_summary(i) for i in issues]
    print(f"  - 생성한 이슈: {len(issues)}건")

    return result


def main():
    parser = argparse.ArgumentParser(description='Jira 주간 이슈 수집')
    parser.add_argument('--start', required=True, help='시작일 (YYYY-MM-DD)')
    parser.add_argument('--end', required=True, help='종료일 (YYYY-MM-DD)')
    parser.add_argument('--next-start', required=True, help='다음 주 시작일 (YYYY-MM-DD)')
    parser.add_argument('--next-end', required=True, help='다음 주 종료일 (YYYY-MM-DD)')
    parser.add_argument('--env-file', default=os.path.expanduser('~/.mcp-atlassian/.env'), help='환경 변수 파일 경로')
    parser.add_argument('--output-dir', default='/tmp/weekly-report', help='출력 디렉토리')

    args = parser.parse_args()

    # 환경 변수 로드
    env_vars = load_env_file(args.env_file)

    jira_url = env_vars.get('JIRA_URL')
    jira_username = env_vars.get('JIRA_USERNAME')
    jira_api_token = env_vars.get('JIRA_API_TOKEN')

    if not all([jira_url, jira_username, jira_api_token]):
        print("Error: JIRA_URL, JIRA_USERNAME, JIRA_API_TOKEN 환경 변수가 필요합니다.")
        sys.exit(1)

    # 출력 디렉토리 생성
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Jira 클라이언트 생성
    client = JiraClient(jira_url, jira_username, jira_api_token)

    print(f"Jira 이슈 수집 시작")
    print(f"기간: {args.start} ~ {args.end}")
    print(f"다음 주: {args.next_start} ~ {args.next_end}")
    print("-" * 50)

    # 팀원별 이슈 수집
    all_data = {
        'period': {
            'start': args.start,
            'end': args.end,
            'next_start': args.next_start,
            'next_end': args.next_end
        },
        'collected_at': datetime.now().isoformat(),
        'members': []
    }

    for member in TEAM_MEMBERS:
        print(f"\n{member['name']} ({member['email']}):")
        member_data = collect_member_issues(
            client, member,
            args.start, args.end,
            args.next_start, args.next_end
        )
        all_data['members'].append(member_data)

    # JSON 파일로 저장
    today = datetime.now().strftime('%Y%m%d')
    output_file = output_dir / f'jira-issues-{today}.json'

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_data, f, ensure_ascii=False, indent=2)

    print("\n" + "=" * 50)
    print(f"수집 완료! 결과 파일: {output_file}")
    print("=" * 50)

    # 요약 통계 출력
    total_updated = sum(len(m['updated_this_week']) for m in all_data['members'])
    total_completed = sum(len(m['completed_this_week']) for m in all_data['members'])
    total_in_progress = sum(len(m['in_progress']) for m in all_data['members'])
    total_planned = sum(len(m['next_week_planned']) for m in all_data['members'])

    print(f"\n📊 요약 통계:")
    print(f"  - 이번 주 변경된 이슈: {total_updated}건")
    print(f"  - 완료된 이슈: {total_completed}건")
    print(f"  - 진행 중인 이슈: {total_in_progress}건")
    print(f"  - 다음 주 예정 이슈: {total_planned}건")


if __name__ == '__main__':
    main()
