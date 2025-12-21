const axios = require('axios');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const API_KEY = process.env.LEONARDO_API_KEY;
const BASE_URL = process.env.LEONARDO_API_BASE_URL;

// 이미지 생성 요청
async function generateImage(prompt, filename) {
  try {
    console.log(`\n🎨 Generating: ${filename}`);
    console.log(`   Prompt: ${prompt.substring(0, 80)}...`);

    const response = await axios.post(
      `${BASE_URL}/generations`,
      {
        prompt: prompt,
        modelId: "b24e16ff-06e3-43eb-8d33-4416c2d75876", // Leonardo Lightning XL
        width: 1024,
        height: 1024,
        num_images: 1,
        alchemy: true,
        presetStyle: "DYNAMIC"
      },
      {
        headers: {
          'Authorization': `Bearer ${API_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const generationId = response.data.sdGenerationJob.generationId;
    console.log(`   Generation ID: ${generationId}`);

    // 생성 완료 대기
    let imageUrl = null;
    for (let i = 0; i < 30; i++) {
      await sleep(3000);

      const statusResponse = await axios.get(
        `${BASE_URL}/generations/${generationId}`,
        {
          headers: {
            'Authorization': `Bearer ${API_KEY}`
          }
        }
      );

      const generation = statusResponse.data.generations_by_pk;
      if (generation.status === 'COMPLETE' && generation.generated_images?.length > 0) {
        imageUrl = generation.generated_images[0].url;
        break;
      } else if (generation.status === 'FAILED') {
        throw new Error('Generation failed');
      }

      process.stdout.write('.');
    }

    if (!imageUrl) {
      throw new Error('Timeout waiting for image');
    }

    // 이미지 다운로드
    const imageResponse = await axios.get(imageUrl, { responseType: 'arraybuffer' });
    const outputPath = path.join(__dirname, '..', 'cso-working', 'threads-images', filename);

    // 디렉토리 생성
    const dir = path.dirname(outputPath);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    fs.writeFileSync(outputPath, imageResponse.data);
    console.log(`\n   ✅ Saved: ${outputPath}`);

    return outputPath;
  } catch (error) {
    console.error(`   ❌ Error: ${error.message}`);
    return null;
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// 이미지 프롬프트 정의
const images = [
  {
    filename: '12-08-vibe-coding-intro.png',
    prompt: 'Minimalist infographic about vibe coding, showing a person talking to AI and code appearing on screen, modern tech aesthetic, purple and blue gradient, clean design, no text, digital illustration style, professional business look'
  },
  {
    filename: '12-09-tools-comparison.png',
    prompt: 'Three modern AI coding tools comparison visual, three floating screens showing different code editors, Cursor Bolt Lovable style, minimalist icons, tech startup aesthetic, blue and purple tones, clean professional design, no text'
  },
  {
    filename: '12-09-bkamp-teaser.png',
    prompt: 'Teaser announcement visual for a tech product launch, rocket launching from a laptop, excitement and anticipation, modern startup aesthetic, gradient purple blue background, dynamic composition, clean minimal design, no text'
  },
  {
    filename: '12-11-launch-banner.png',
    prompt: 'Celebration launch announcement banner, confetti and sparkles, laptop showing a showcase platform, modern tech startup vibe, vibrant purple and blue gradient, exciting and dynamic, professional celebration mood, no text'
  },
  {
    filename: '12-11-contest-event.png',
    prompt: 'Weekly contest announcement visual, trophy and prize concept, tech startup competition, gold and purple gradient, modern minimal design, excitement and opportunity, professional event banner style, no text'
  },
  {
    filename: '12-13-free-tools.png',
    prompt: 'Three free AI coding tools concept, floating tool icons with sparkles, accessible and beginner friendly vibe, green and blue gradient suggesting free and open, modern tech aesthetic, clean minimal design, no text'
  },
  {
    filename: '12-14-top3-ranking.png',
    prompt: 'Top 3 ranking podium for tech projects, modern minimal podium design, gold silver bronze medals, tech startup aesthetic, purple and gold gradient, celebration and achievement mood, clean professional design, no text'
  }
];

async function main() {
  console.log('🚀 bkamp.ai Threads 이미지 생성 시작\n');
  console.log(`총 ${images.length}개 이미지 생성 예정\n`);

  const results = [];

  for (const img of images) {
    const result = await generateImage(img.prompt, img.filename);
    results.push({ filename: img.filename, path: result, success: !!result });

    // API 레이트 리밋 방지
    await sleep(5000);
  }

  console.log('\n\n📊 생성 결과:');
  console.log('='.repeat(50));

  let successCount = 0;
  for (const r of results) {
    if (r.success) {
      console.log(`✅ ${r.filename}`);
      successCount++;
    } else {
      console.log(`❌ ${r.filename} - 실패`);
    }
  }

  console.log('='.repeat(50));
  console.log(`완료: ${successCount}/${images.length} 이미지 생성됨`);
  console.log(`\n저장 위치: cso-working/threads-images/`);
}

main().catch(console.error);
