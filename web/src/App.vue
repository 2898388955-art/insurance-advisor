<script setup lang="ts">
import { RouterView, useRoute } from 'vue-router'
import { computed } from 'vue'

const route = useRoute()
const isChat = computed(() => route.name === 'chat')
</script>

<template>
  <div class="shell">
    <header v-if="!isChat" class="masthead">
      <div class="container masthead-inner">
        <RouterLink to="/" class="brand">
          <span class="brand-mark">保</span>
          <span class="brand-text">
            <strong>保顾问</strong>
            <em>INSURE&nbsp;ADVISOR</em>
          </span>
        </RouterLink>

        <nav class="nav">
          <RouterLink to="/" class="nav-link">产品库</RouterLink>
          <RouterLink to="/compare" class="nav-link">对比</RouterLink>
          <RouterLink to="/chat" class="nav-link nav-link--cta">
            问顾问
            <span class="dot" />
          </RouterLink>
        </nav>
      </div>
    </header>

    <main :class="['main', { 'main--flush': isChat }]">
      <RouterView />
    </main>

    <footer v-if="!isChat" class="footer">
      <div class="container footer-inner">
        <div>
          <p class="serif footer-title">条款可查，答案有出处。</p>
          <p class="muted footer-sub">
            产品资料来自保险公司公开披露渠道，仅用于产品研究与技术演示，不构成投保建议。
          </p>
        </div>
        <p class="footer-meta">INSURANCE ADVISOR · 2026</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.shell {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.masthead {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(14px);
  background: color-mix(in srgb, var(--paper) 82%, transparent);
  border-bottom: 1px solid var(--line);
}

.masthead-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 72px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
}

.brand-mark {
  display: grid;
  place-items: center;
  width: 38px;
  height: 38px;
  border: 1px solid var(--ink);
  border-radius: 50%;
  font-family: var(--display);
  font-size: 19px;
  color: var(--ink);
}

.brand-text {
  display: flex;
  flex-direction: column;
  line-height: 1.1;
}

.brand-text strong {
  font-family: var(--display);
  font-size: 18px;
  letter-spacing: 0.08em;
}

.brand-text em {
  font-family: var(--mono);
  font-style: normal;
  font-size: 9px;
  letter-spacing: 0.28em;
  color: var(--muted);
}

.nav {
  display: flex;
  align-items: center;
  gap: 30px;
}

.nav-link {
  font-size: 14px;
  letter-spacing: 0.06em;
  color: var(--ink-soft);
  position: relative;
  padding: 6px 0;
}

.nav-link.router-link-exact-active {
  color: var(--ink);
}

.nav-link.router-link-exact-active::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 1px;
  background: var(--gold);
}

.nav-link--cta {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 9px 18px;
  border: 1px solid var(--ink);
  border-radius: var(--radius-pill);
  transition: background 0.25s ease, color 0.25s ease;
}

.nav-link--cta:hover {
  background: var(--ink);
  color: var(--paper);
}

.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--gold);
  box-shadow: 0 0 0 0 rgba(176, 134, 60, 0.5);
  animation: pulse 2.4s infinite;
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(176, 134, 60, 0.45); }
  70% { box-shadow: 0 0 0 8px rgba(176, 134, 60, 0); }
  100% { box-shadow: 0 0 0 0 rgba(176, 134, 60, 0); }
}

.main {
  flex: 1;
  padding: 56px 0 96px;
}

.main--flush {
  padding: 0;
}

.footer {
  border-top: 1px solid var(--line);
  padding: 40px 0;
}

.footer-inner {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 24px;
}

.footer-title {
  font-size: 18px;
  margin-bottom: 6px;
}

.footer-sub {
  font-size: 12.5px;
  max-width: 560px;
  margin: 0;
}

.footer-meta {
  font-family: var(--mono);
  font-size: 10px;
  letter-spacing: 0.24em;
  color: var(--muted);
  margin: 0;
}

@media (max-width: 900px) {
  .container {
    width: calc(100% - 32px);
  }
  .nav {
    gap: 16px;
  }
  .brand-text em {
    display: none;
  }
}
</style>
