<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { fetchCategories, fetchProducts, type CategoryNode, type ProductCard } from '../api/products'
import { useCompareStore } from '../stores/compare'

const router = useRouter()
const compare = useCompareStore()

const categories = ref<CategoryNode[]>([])
const products = ref<ProductCard[]>([])
const total = ref(0)
const page = ref(1)
const size = 9
const loading = ref(false)

const categoryId = ref<number | undefined>(undefined)
const age = ref<number | undefined>(undefined)
const keyword = ref('')

const ageOptions = [
  { label: '不限年龄', value: undefined },
  { label: '0–17 岁', value: 10 },
  { label: '18–30 岁', value: 25 },
  { label: '31–45 岁', value: 38 },
  { label: '46–60 岁', value: 52 },
  { label: '60 岁以上', value: 65 },
]

const heroStats = computed(() => [
  { value: total.value || '—', label: '在售产品' },
  { value: products.value.filter((p) => p.dataStatus === 'VERIFIED').length || '—', label: '本页有条款' },
  { value: products.value.filter((p) => p.priceStatus === 'PUBLISHED').length || '—', label: '本页有费率' },
])

async function load() {
  loading.value = true
  try {
    const data = await fetchProducts({
      categoryId: categoryId.value,
      age: age.value,
      keyword: keyword.value.trim() || undefined,
      page: page.value,
      size,
    })
    products.value = data.records
    total.value = data.total
  } catch (e) {
    ElMessage.error((e as Error).message)
  } finally {
    loading.value = false
  }
}

function pickCategory(id?: number) {
  categoryId.value = id
  page.value = 1
  load()
}

function search() {
  page.value = 1
  load()
}

function changePage(p: number) {
  page.value = p
  load()
  window.scrollTo({ top: 220, behavior: 'smooth' })
}

function toggleCompare(p: ProductCard) {
  if (!compare.has(p.id) && !compare.canAdd) {
    ElMessage.warning('最多对比 4 个产品')
    return
  }
  compare.toggle(p.id)
}

onMounted(async () => {
  try {
    categories.value = await fetchCategories()
  } catch {
    /* 分类失败不阻塞产品列表 */
  }
  load()
})
</script>

<template>
  <div class="page">
    <section class="hero container">
      <div class="hero-copy rise">
        <p class="eyebrow">PRODUCT LIBRARY · 条款原文可查</p>
        <h1 class="hero-title">
          把条款读明白，<br />
          再决定买什么。
        </h1>
        <p class="hero-sub">
          每一个数字都来自保险公司的公开披露文件。点开产品，能看到条款原文、页码，以及字段是从哪一条抽出来的。
        </p>
      </div>

      <aside class="hero-stats rise rise-2">
        <div v-for="s in heroStats" :key="s.label" class="stat">
          <strong class="serif">{{ s.value }}</strong>
          <span>{{ s.label }}</span>
        </div>
      </aside>
    </section>

    <section class="filters container rise rise-3">
      <div class="chips">
        <button :class="['chip', { active: categoryId === undefined }]" @click="pickCategory(undefined)">
          全部
        </button>
        <button
          v-for="c in categories"
          :key="c.id"
          :class="['chip', { active: categoryId === c.id }]"
          @click="pickCategory(c.id)"
        >
          {{ c.name }}
        </button>
      </div>

      <div class="filter-tools">
        <el-select v-model="age" placeholder="投保年龄" clearable class="age-select" @change="search">
          <el-option v-for="o in ageOptions" :key="String(o.value)" :label="o.label" :value="o.value" />
        </el-select>
        <el-input
          v-model="keyword"
          placeholder="搜产品名、公司或保障关键词"
          clearable
          class="search-input"
          @keyup.enter="search"
          @clear="search"
        >
          <template #append>
            <el-button @click="search">搜索</el-button>
          </template>
        </el-input>
      </div>
    </section>

    <section class="container">
      <div v-loading="loading" class="grid">
        <article
          v-for="(p, i) in products"
          :key="p.id"
          class="card rise"
          :style="{ animationDelay: `${0.06 * i}s` }"
        >
          <RouterLink :to="`/products/${p.id}`" :class="['cover', `tone-${(p.categoryId ?? 0) % 5}`]">
            <div class="cover-art">
              <span class="cover-kicker">{{ p.categoryName || '保险产品' }}</span>
              <span class="cover-glyph serif">{{ (p.productType || p.categoryName || p.name).slice(0, 1) }}</span>
              <span class="cover-word">{{ p.productType || p.categoryName }}</span>
            </div>
            <span v-if="p.dataStatus === 'VERIFIED'" class="verified">条款原文</span>
            <span v-if="p.priceStatus !== 'PUBLISHED'" class="badge">价格未公开</span>
          </RouterLink>

          <div class="card-body">
            <div class="meta">
              <span class="company">{{ p.company }}</span>
              <span class="type">{{ p.productType || p.categoryName }}</span>
            </div>

            <RouterLink :to="`/products/${p.id}`" class="name serif">{{ p.name }}</RouterLink>

            <dl class="facts">
              <div>
                <dt>投保年龄</dt>
                <dd>{{ p.minAge ?? '不限' }}–{{ p.maxAge ?? '不限' }} 岁</dd>
              </div>
              <div>
                <dt>等待期</dt>
                <dd>{{ p.waitingDays != null ? `${p.waitingDays} 天` : '未披露' }}</dd>
              </div>
              <div>
                <dt>续保</dt>
                <dd>
                  {{ p.guaranteedRenewal === true ? '保证续保' : p.guaranteedRenewal === false ? '不保证' : '未提及' }}
                </dd>
              </div>
            </dl>

            <div class="labels">
              <span v-for="l in p.labels.slice(0, 3)" :key="l" class="label">{{ l }}</span>
            </div>

            <p class="price" :class="{ muted: p.priceStatus !== 'PUBLISHED' }">
              {{ p.priceDisplay }}
            </p>

            <div class="actions">
              <RouterLink :to="`/products/${p.id}`" class="detail-link">查看条款 →</RouterLink>
              <button
                :class="['compare-btn', { active: compare.has(p.id) }]"
                @click.prevent="toggleCompare(p)"
              >
                {{ compare.has(p.id) ? '已加入对比' : '加入对比' }}
              </button>
            </div>
          </div>
        </article>
      </div>

      <el-empty v-if="!loading && !products.length" description="没有匹配的产品，换个条件试试" />

      <el-pagination
        v-if="total > size"
        background
        layout="prev, pager, next"
        :total="total"
        :page-size="size"
        :current-page="page"
        @current-change="changePage"
      />
    </section>

    <transition name="tray">
      <div v-if="compare.count" class="tray">
        <div class="tray-inner container">
          <p class="tray-text">
            <span class="eyebrow">COMPARE</span>
            已选 <strong>{{ compare.count }}</strong> / {{ compare.MAX }} 个产品
          </p>
          <div class="tray-actions">
            <button class="tray-clear" @click="compare.clear()">清空</button>
            <el-button type="primary" :disabled="compare.count < 2" @click="router.push('/compare')">
              开始对比
            </el-button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.page {
  padding-top: 8px;
}

.hero {
  display: grid;
  grid-template-columns: 1.6fr 1fr;
  gap: 64px;
  align-items: end;
  padding-bottom: 56px;
  border-bottom: 1px solid var(--line);
}

.hero-title {
  font-size: clamp(38px, 5vw, 64px);
  line-height: 1.18;
  margin: 18px 0 22px;
  letter-spacing: 0.01em;
}

.hero-sub {
  max-width: 560px;
  color: var(--muted);
  font-size: 15px;
  margin: 0;
}

.hero-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  border-left: 1px solid var(--line);
  padding-left: 40px;
}

.stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat strong {
  font-size: 40px;
  font-weight: 600;
  line-height: 1;
  color: var(--ink);
}

.stat span {
  font-size: 12px;
  color: var(--muted);
  letter-spacing: 0.08em;
}

.filters {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 24px;
  padding: 26px 0;
  flex-wrap: wrap;
}

.chips {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.chip {
  border: 1px solid var(--line);
  background: transparent;
  color: var(--ink-soft);
  padding: 8px 16px;
  border-radius: var(--radius-pill);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.22s ease;
  font-family: var(--body);
}

.chip:hover {
  border-color: var(--ink-soft);
}

.chip.active {
  background: var(--ink);
  border-color: var(--ink);
  color: var(--paper);
}

.filter-tools {
  display: flex;
  gap: 10px;
  align-items: center;
}

.age-select {
  width: 132px;
}

.search-input {
  width: 300px;
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 28px;
  min-height: 320px;
}

.card {
  background: var(--paper-raised);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s ease,
    border-color 0.3s ease;
}

.card:hover {
  transform: translateY(-4px);
  border-color: var(--line-strong);
  box-shadow: var(--shadow-card);
}

.cover {
  position: relative;
  display: block;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  background: var(--ink);
}

.cover-art {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 18px 20px;
  background:
    radial-gradient(120% 120% at 85% 10%, rgba(255, 255, 255, 0.14), transparent 45%),
    linear-gradient(140deg, var(--tone-a) 0%, var(--tone-b) 100%);
  transition: transform 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}

.cover-art::after {
  content: "";
  position: absolute;
  inset: 12px;
  border: 1px solid rgba(245, 240, 230, 0.22);
  pointer-events: none;
}

.card:hover .cover-art {
  transform: scale(1.03);
}

.tone-0 { --tone-a: #101a24; --tone-b: #1c4a52; }
.tone-1 { --tone-a: #3a2a20; --tone-b: #8a5a33; }
.tone-2 { --tone-a: #1f2a1d; --tone-b: #4d6340; }
.tone-3 { --tone-a: #232a35; --tone-b: #55607a; }
.tone-4 { --tone-a: #2c2320; --tone-b: #6d4a45; }

.cover-kicker {
  font-family: var(--mono);
  font-size: 10px;
  letter-spacing: 0.24em;
  color: rgba(245, 240, 230, 0.72);
  z-index: 1;
}

.cover-glyph {
  position: absolute;
  right: 18px;
  bottom: -18px;
  font-size: 132px;
  line-height: 1;
  color: rgba(245, 240, 230, 0.14);
  pointer-events: none;
}

.cover-word {
  position: relative;
  z-index: 1;
  font-family: var(--display);
  font-size: 20px;
  letter-spacing: 0.06em;
  color: rgba(245, 240, 230, 0.94);
}

.verified {
  position: absolute;
  bottom: 18px;
  right: 18px;
  z-index: 2;
  font-size: 10px;
  letter-spacing: 0.08em;
  color: var(--gold-soft);
  border: 1px solid rgba(216, 189, 138, 0.45);
  padding: 2px 8px;
}

.badge {
  position: absolute;
  top: 18px;
  right: 18px;
  font-size: 10.5px;
  padding: 3px 9px;
  background: rgba(16, 26, 36, 0.6);
  color: var(--paper);
  border-radius: var(--radius-pill);
  letter-spacing: 0.04em;
}

.card-body {
  padding: 20px 22px 22px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  flex: 1;
}

.meta {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  font-size: 11.5px;
  color: var(--muted);
  letter-spacing: 0.04em;
}

.company {
  font-weight: 500;
  color: var(--ink-soft);
}

.type {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 52%;
}

.name {
  font-size: 19px;
  line-height: 1.4;
  color: var(--ink);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  min-height: 53px;
}

.name:hover {
  color: var(--teal);
}

.facts {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin: 0;
  padding: 12px 0;
  border-top: 1px solid var(--line);
  border-bottom: 1px solid var(--line);
}

.facts dt {
  font-size: 10.5px;
  color: var(--muted);
  letter-spacing: 0.08em;
  margin-bottom: 3px;
}

.facts dd {
  margin: 0;
  font-size: 13px;
  color: var(--ink);
  font-variant-numeric: tabular-nums;
}

.labels {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  min-height: 22px;
}

.label {
  font-size: 11px;
  padding: 2px 8px;
  border: 1px solid var(--line);
  border-radius: var(--radius-sm);
  color: var(--ink-soft);
  background: rgba(236, 228, 213, 0.4);
}

.price {
  font-size: 12.5px;
  color: var(--ink-soft);
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  min-height: 36px;
}

.price.muted {
  color: var(--muted);
}

.actions {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 6px;
}

.detail-link {
  font-size: 13px;
  color: var(--teal);
  letter-spacing: 0.04em;
}

.compare-btn {
  border: 1px solid var(--line-strong);
  background: transparent;
  color: var(--ink-soft);
  font-size: 12px;
  padding: 7px 14px;
  border-radius: var(--radius-pill);
  cursor: pointer;
  transition: all 0.22s ease;
  font-family: var(--body);
}

.compare-btn:hover {
  border-color: var(--teal);
  color: var(--teal);
}

.compare-btn.active {
  background: var(--teal);
  border-color: var(--teal);
  color: #fff;
}

.tray {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 30;
  background: var(--ink);
  color: var(--paper);
  box-shadow: 0 -12px 40px -20px rgba(0, 0, 0, 0.6);
}

.tray-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 68px;
}

.tray-text {
  margin: 0;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 14px;
}

.tray-text .eyebrow {
  color: var(--gold-soft);
}

.tray-text strong {
  font-family: var(--display);
  font-size: 20px;
}

.tray-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.tray-clear {
  background: none;
  border: 0;
  color: rgba(245, 240, 230, 0.6);
  font-size: 12px;
  cursor: pointer;
  letter-spacing: 0.08em;
}

.tray-clear:hover {
  color: var(--paper);
}

.tray-enter-active,
.tray-leave-active {
  transition: transform 0.32s cubic-bezier(0.22, 1, 0.36, 1);
}

.tray-enter-from,
.tray-leave-to {
  transform: translateY(100%);
}

@media (max-width: 1080px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .hero {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .hero-stats {
    border-left: 0;
    padding-left: 0;
    border-top: 1px solid var(--line);
    padding-top: 24px;
  }
}

@media (max-width: 720px) {
  .grid {
    grid-template-columns: 1fr;
  }
  .filters {
    align-items: stretch;
  }
  .filter-tools {
    width: 100%;
  }
  .search-input {
    flex: 1;
    width: auto;
  }
}
</style>
