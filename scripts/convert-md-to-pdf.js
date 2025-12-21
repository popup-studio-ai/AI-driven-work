const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const puppeteer = require('puppeteer');

// Custom renderer to add IDs to headers and handle links
const renderer = {
  heading({ tokens, depth }) {
    const text = this.parser.parseInline(tokens);
    const raw = tokens.map(t => t.raw || t.text || '').join('');
    const slug = raw
      .toLowerCase()
      .replace(/[^\w\s가-힣-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/^-+|-+$/g, '');

    return `<h${depth} id="${slug}">${text}</h${depth}>`;
  },

  link({ href, title, tokens }) {
    const text = this.parser.parseInline(tokens);
    const titleAttr = title ? ` title="${title}"` : '';
    const target = href.startsWith('http') ? ' target="_blank"' : '';
    return `<a href="${href}"${titleAttr}${target}>${text}</a>`;
  }
};

// Configure marked
marked.use({ renderer });

async function convertMarkdownToPDF(mdFilePath) {
  try {
    // Read markdown file
    const markdown = fs.readFileSync(mdFilePath, 'utf8');

    // Convert to HTML
    const contentHtml = marked.parse(markdown);

    // Create styled HTML
    const html = `<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>경쟁사 분석 리포트: Supabase</title>
  <style>
    @page {
      margin: 1cm;
    }

    body {
      font-family: 'Apple SD Gothic Neo', 'Malgun Gothic', 'Noto Sans KR', sans-serif;
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
      font-weight: 700;
    }

    h2 {
      color: #2c3e50;
      border-bottom: 2px solid #e0e0e0;
      padding-bottom: 8px;
      margin-top: 40px;
      margin-bottom: 20px;
      font-weight: 700;
    }

    h3 {
      color: #34495e;
      margin-top: 30px;
      margin-bottom: 15px;
      font-weight: 600;
    }

    h4 {
      color: #555;
      margin-top: 25px;
      margin-bottom: 12px;
      font-weight: 600;
    }

    p {
      margin-bottom: 1em;
    }

    a {
      color: #3498db;
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    blockquote {
      border-left: 4px solid #2c3e50;
      margin: 20px 0;
      padding: 10px 20px;
      background-color: #f8f9fa;
      font-style: italic;
    }

    code {
      background-color: #f5f5f5;
      padding: 2px 6px;
      border-radius: 3px;
      font-family: 'Menlo', 'Monaco', 'Consolas', monospace;
      font-size: 14px;
    }

    pre {
      background-color: #f5f5f5;
      border: 1px solid #ddd;
      border-left: 4px solid #2c3e50;
      padding: 15px;
      overflow-x: auto;
      border-radius: 4px;
      font-size: 14px;
      line-height: 1.5;
      margin: 20px 0;
    }

    pre code {
      background-color: transparent;
      padding: 0;
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
  </style>
</head>
<body>
  ${contentHtml}
</body>
</html>`;

    // Save HTML file
    const basePath = path.parse(mdFilePath);
    const htmlPath = path.resolve(basePath.dir, `${basePath.name}.html`);
    const pdfPath = path.resolve(basePath.dir, `${basePath.name}.pdf`);

    fs.writeFileSync(htmlPath, html, 'utf8');
    console.log(`✅ HTML saved: ${htmlPath}`);

    // Generate PDF using Puppeteer
    console.log('🚀 Generating PDF...');
    const browser = await puppeteer.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();

    // Load HTML
    await page.goto(`file://${htmlPath}`, {
      waitUntil: 'networkidle0'
    });

    // Generate PDF with clickable links
    await page.pdf({
      path: pdfPath,
      format: 'A4',
      margin: {
        top: '2cm',
        right: '2cm',
        bottom: '2cm',
        left: '2cm'
      },
      printBackground: true,
      displayHeaderFooter: true,
      headerTemplate: '<div></div>',
      footerTemplate: `
        <div style="font-size: 10px; text-align: center; width: 100%; color: #666; padding: 10px 0;">
          <span class="pageNumber"></span> / <span class="totalPages"></span>
        </div>
      `,
      preferCSSPageSize: false
    });

    await browser.close();

    console.log(`✅ PDF saved: ${pdfPath}`);
    console.log('✨ Conversion complete!');

    return { htmlPath, pdfPath };

  } catch (error) {
    console.error('❌ Error during conversion:', error);
    throw error;
  }
}

// Get file path from command line argument
const mdFile = process.argv[2];

if (!mdFile) {
  console.error('Usage: node convert-md-to-pdf.js <markdown-file>');
  process.exit(1);
}

if (!fs.existsSync(mdFile)) {
  console.error(`File not found: ${mdFile}`);
  process.exit(1);
}

// Run conversion
convertMarkdownToPDF(mdFile)
  .then(({ htmlPath, pdfPath }) => {
    console.log('\n📂 Generated files:');
    console.log(`   HTML: ${htmlPath}`);
    console.log(`   PDF: ${pdfPath}`);
  })
  .catch(error => {
    console.error('Failed to convert:', error.message);
    process.exit(1);
  });
