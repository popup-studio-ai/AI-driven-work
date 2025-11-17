# Markdown to HTML for Print

Convert a markdown file to a styled HTML document optimized for browser printing and viewing.

## Instructions

1. Take the markdown file path provided by the user as an argument
2. Convert the markdown to HTML using `npx marked`
3. Create a complete HTML document with the following features:
   - Dark grey color scheme (#2c3e50 for headers)
   - Proper Korean font support (Apple SD Gothic Neo)
   - Beautiful table styling with borders and hover effects
   - Print optimization with `@page { margin: 1cm; }`
   - Responsive design
   - Code block styling with syntax highlighting support
4. Save the HTML file with `-print.html` suffix (e.g., `document.md` → `document-print.html`)
5. Open the HTML file in the default browser using the `open` command

## CSS Template

Use this exact CSS styling:

```css
@page {
    margin: 1cm;
}

body {
    font-family: 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
    line-height: 1.6;
    max-width: 1200px;
    margin: 0 auto;
    padding: 40px 20px;
    color: #333;
    background-color: #fff;
}

h1 {
    color: #2c3e50;
    border-bottom: 3px solid #2c3e50;
    padding-bottom: 10px;
    margin-bottom: 20px;
}

h2 {
    color: #2c3e50;
    border-bottom: 2px solid #e0e0e0;
    padding-bottom: 8px;
    margin-top: 40px;
    margin-bottom: 20px;
}

h3 {
    color: #34495e;
    margin-top: 30px;
    margin-bottom: 15px;
}

h4 {
    color: #555;
    margin-top: 25px;
    margin-bottom: 12px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

thead {
    background-color: #2c3e50;
    color: white;
}

th {
    padding: 12px 15px;
    text-align: left;
    font-weight: bold;
    border: 1px solid #ddd;
}

td {
    padding: 10px 15px;
    border: 1px solid #ddd;
}

tbody tr:nth-child(even) {
    background-color: #f9f9f9;
}

tbody tr:hover {
    background-color: #ecf0f1;
}

pre {
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    border-left: 4px solid #2c3e50;
    padding: 15px;
    overflow-x: auto;
    border-radius: 4px;
    font-size: 14px;
}

code {
    background-color: #f5f5f5;
    padding: 2px 6px;
    border-radius: 3px;
    font-family: 'Menlo', 'Monaco', monospace;
    font-size: 14px;
}

pre code {
    background-color: transparent;
    padding: 0;
}

blockquote {
    border-left: 4px solid #2c3e50;
    margin: 20px 0;
    padding: 10px 20px;
    background-color: #f8f9fa;
    font-style: italic;
}

ul, ol {
    margin: 15px 0;
    padding-left: 30px;
}

li {
    margin: 8px 0;
}

hr {
    border: none;
    border-top: 2px solid #eee;
    margin: 30px 0;
}

a {
    color: #3498db;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

strong {
    color: #2c3e50;
    font-weight: 600;
}

@media print {
    body {
        max-width: 100%;
        padding: 20px;
    }

    table {
        page-break-inside: avoid;
    }

    h2, h3 {
        page-break-after: avoid;
    }

    thead {
        display: table-header-group;
    }
}
```

## Workflow

1. Get the markdown file path from user
2. Extract filename without extension
3. Run: `npx marked input.md -o temp-content.html`
4. Create complete HTML with header, CSS, content body, and closing tags
5. Save as `{filename}-print.html`
6. Run: `open {filename}-print.html`
7. Inform user: "HTML created and opened in browser. Press Cmd+P to print as PDF."

## Example Usage

User: `/md-html-print document.md`

Result:
- Creates `document-print.html` with full styling
- Opens in browser automatically
- Ready for Cmd+P → Save as PDF
