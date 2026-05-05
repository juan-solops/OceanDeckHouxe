function toggleMenu() {
  const navLinks = document.getElementById('navLinks');
  const icon = document.querySelector('.menu-toggle i');
  if (!navLinks || !icon) return;
  navLinks.classList.toggle('active');
  icon.classList.toggle('fa-bars');
  icon.classList.toggle('fa-times');
}

document.querySelectorAll('.nav-links a').forEach(link => {
  link.addEventListener('click', () => {
    const navLinks = document.getElementById('navLinks');
    const icon = document.querySelector('.menu-toggle i');
    if (!navLinks || !icon) return;
    navLinks.classList.remove('active');
    icon.classList.remove('fa-times');
    icon.classList.add('fa-bars');
  });
});

function handleSubmit(e) {
  e.preventDefault();
  alert('Thank you for your message! We will get back to you within 24 hours.');
}

document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', e => {
    const targetSelector = a.getAttribute('href');
    const target = document.querySelector(targetSelector);
    if (!target) return;
    e.preventDefault();
    target.scrollIntoView({ behavior: 'smooth' });
  });
});

const USE_HERO_VIDEO = true;
(function initHeroVideo() {
  const video = document.getElementById('heroVideo');
  if (!video) return;
  if (!USE_HERO_VIDEO) {
    video.style.display = 'none';
    return;
  }
  video.play().catch(() => {
    video.style.display = 'none';
  });
})();

/* ===== ODH_VIDEO_JS_PATCH_START ===== */
(function () {
  const video = document.getElementById('heroVideo');
  if (!video) return;
  if (!USE_HERO_VIDEO) { video.style.display = 'none'; return; }
  video.play().catch(() => { video.style.display = 'none'; });
})();

/* ===== ODH_VIDEO_JS_PATCH_END ===== */
