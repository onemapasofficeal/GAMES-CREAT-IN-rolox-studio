// ── Copy code ────────────────────────────────────────────────────────────────
function copyCode(btn) {
  const code = btn.previousElementSibling?.textContent ?? '';
  navigator.clipboard.writeText(code).then(() => {
    const orig = btn.textContent;
    btn.textContent = '✅';
    btn.style.borderColor = 'var(--green)';
    setTimeout(() => {
      btn.textContent = orig;
      btn.style.borderColor = '';
    }, 1500);
  });
}

// ── Code tabs ────────────────────────────────────────────────────────────────
function showTab(btn, targetId) {
  // Desativa todos os tabs e conteúdos no mesmo grupo
  const group = btn.closest('.step-content');
  group.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  group.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

  btn.classList.add('active');
  const target = document.getElementById(targetId);
  if (target) target.classList.add('active');
}

// ── Animate weight bars on scroll ────────────────────────────────────────────
function animateWeightBars() {
  const bars = document.querySelectorAll('.weight-bar');
  if (!bars.length) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const bar = entry.target;
        const width = bar.style.width;
        bar.style.width = '0%';
        requestAnimationFrame(() => {
          setTimeout(() => { bar.style.width = width; }, 100);
        });
        observer.unobserve(bar);
      }
    });
  }, { threshold: 0.3 });

  bars.forEach(bar => observer.observe(bar));
}

// ── Animate cards on scroll ───────────────────────────────────────────────────
function animateOnScroll() {
  const elements = document.querySelectorAll(
    '.card, .feature-card, .ranking-card, .complexity-card, .system-card, .step'
  );

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry, i) => {
      if (entry.isIntersecting) {
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }, i * 60);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  elements.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity .4s ease, transform .4s ease';
    observer.observe(el);
  });
}

// ── Terminal typing effect ────────────────────────────────────────────────────
function terminalTyping() {
  const terminals = document.querySelectorAll('.terminal-body');
  terminals.forEach(terminal => {
    const lines = terminal.querySelectorAll('p');
    lines.forEach((line, i) => {
      line.style.opacity = '0';
      setTimeout(() => {
        line.style.transition = 'opacity .3s';
        line.style.opacity = '1';
      }, 300 + i * 180);
    });
  });
}

// ── Smooth scroll for anchor links ───────────────────────────────────────────
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', e => {
    const target = document.querySelector(anchor.getAttribute('href'));
    if (target) {
      e.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });
});

// ── Init ─────────────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  animateWeightBars();
  animateOnScroll();
  terminalTyping();
});
