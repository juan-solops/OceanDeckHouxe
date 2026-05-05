#!/usr/bin/env bash
set -e

INDEX="index.html"
CSS="assets/css/style.css"
JS="assets/js/main.js"

cp "$INDEX" "${INDEX}.bak.$(date +%Y%m%d-%H%M%S)"
cp "$CSS" "${CSS}.bak.$(date +%Y%m%d-%H%M%S)"
cp "$JS" "${JS}.bak.$(date +%Y%m%d-%H%M%S)"
echo "✅ Backups created."

python3 - << 'PY'
from pathlib import Path
import re

p = Path("index.html")
html = p.read_text(encoding="utf-8")

if 'id="heroVideo"' in html:
    print("ℹ️ heroVideo already present, skipping HTML injection.")
else:
    pattern = re.compile(r'(<section[^>]*class="[^"]*\bhero\b[^"]*"[^>]*>)', re.IGNORECASE)
    m = pattern.search(html)
    if not m:
        print("⚠️ Could not find hero section. No HTML changes made.")
    else:
        inject = '''
  <video class="hero-video" id="heroVideo" autoplay muted loop playsinline preload="metadata" poster="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1600&q=80">
    <source src="assets/video/hero.mp4" type="video/mp4" />
  </video>
  <div class="hero-overlay"></div>
'''
        html = html[:m.end()] + inject + html[m.end():]
        p.write_text(html, encoding="utf-8")
        print("✅ Injected hero video HTML.")
PY

if grep -q "ODH_VIDEO_PATCH_START" "$CSS"; then
  echo "ℹ️ CSS patch already exists, skipping."
else
cat >> "$CSS" << 'CSS_EOF'

/* ===== ODH_VIDEO_PATCH_START ===== */
.hero { position: relative; overflow: hidden; }
.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background: url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1600&q=80') center/cover no-repeat;
  opacity: 0.25;
  z-index: 0;
}
.hero-video { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; z-index: 0; }
.hero-overlay { position: absolute; inset: 0; background: rgba(10, 35, 66, 0.45); z-index: 1; }
.hero-content { position: relative; z-index: 2; }

.hero-stats {
  margin-top: 56px;
  display: grid;
  grid-template-columns: repeat(4, minmax(120px, 1fr));
  gap: 20px;
  max-width: 760px;
  margin-left: auto;
  margin-right: auto;
  align-items: start;
}
.stat { text-align: center; display: flex; flex-direction: column; align-items: center; }
.stat-num { line-height: 1.1; min-height: 2.4rem; }
.stat-label { margin-top: 6px; line-height: 1.25; min-height: 2.2em; }

@media (max-width: 900px) {
  .hero-stats { grid-template-columns: repeat(2, minmax(130px, 1fr)); max-width: 420px; gap: 18px 24px; }
}
@media (max-width: 600px) {
  .hero-stats { grid-template-columns: repeat(2, 1fr); max-width: 320px; gap: 14px 16px; }
}
/* ===== ODH_VIDEO_PATCH_END ===== */
CSS_EOF
  echo "✅ CSS patch appended."
fi

if grep -q "ODH_VIDEO_JS_PATCH_START" "$JS"; then
  echo "ℹ️ JS patch already exists, skipping."
else
cat >> "$JS" << 'JS_EOF'

/* ===== ODH_VIDEO_JS_PATCH_START ===== */
const USE_HERO_VIDEO = true;
(function () {
  const video = document.getElementById('heroVideo');
  if (!video) return;
  if (!USE_HERO_VIDEO) { video.style.display = 'none'; return; }
  video.play().catch(() => { video.style.display = 'none'; });
})();
/* ===== ODH_VIDEO_JS_PATCH_END ===== */
JS_EOF
  echo "✅ JS patch appended."
fi

echo ""
echo "Done. Next:"
echo "1) Put your real video at assets/video/hero.mp4"
echo "2) Rebuild minified files:"
echo "   npx cleancss -o assets/css/style.min.css assets/css/style.css"
echo "   npx terser assets/js/main.js -o assets/js/main.min.js -c -m"
