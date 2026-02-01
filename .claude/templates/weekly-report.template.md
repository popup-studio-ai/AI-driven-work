# {{report_type}} 주간 업무 보고서

- **기간**: {{period_start}} ~ {{period_end}}
- **작성일**: {{created_date}}
- **대상 프로젝트**: {{projects}}

---

## 팀원별 업무 현황 및 성과

{{#each members}}
### {{name}} ({{role}})

**이번 주 집중 영역:** {{focus_area}}

**주요 성과 (완료 {{completed_count}}건):**

{{#each completed_issues}}
- **{{key}}: {{summary}}** ({{resolution_date}} 완료) - {{description}}
{{/each}}

**진행 중인 작업:**

{{#each in_progress_issues}}
- **{{key}}: {{summary}}** - {{status}}
{{/each}}

**다음 주 예정 작업:**

{{#each planned_issues}}
- **{{key}}: {{summary}}** (기한: {{due_date}})
{{/each}}

**칭찬 포인트:**
{{praise_point}}

---
{{/each}}

## 이번 주 전체 주요 진행 사항

### 개발 (Backend)
{{backend_summary}}

### 개발 (Frontend)
{{frontend_summary}}

### QA & UX/UI
{{qa_ux_summary}}

### 기획 & 콘텐츠
{{planning_summary}}

### 비즈니스 & 마케팅
{{business_summary}}

---

## 잘한 점
{{#each good_points}}
{{index}}. {{content}}
{{/each}}

## 아쉬운 점
{{#each improvement_points}}
{{index}}. {{content}}
{{/each}}

---

## 다음 주 ({{next_period}}) 예상 작업

{{#each projects_next_week}}
### {{project_name}} ({{project_key}})
{{#each members_in_project}}
#### {{member_name}} ({{issue_count}}건)
{{#each issues}}
- {{key}}: {{summary}}
{{/each}}
{{/each}}
{{/each}}

---

## 논의 필요 사항

{{#each discussion_items}}
### {{index}}. {{title}}
- **현황**: {{status}}
- **문제점**: {{problem}}
- **제안**: {{suggestion}}
{{/each}}

---

*이 보고서는 Jira {{projects}} 프로젝트의 이슈를 기반으로 {{period_start}} ~ {{period_end}} 기간의 실제 작업을 반영하여 작성되었습니다.*
