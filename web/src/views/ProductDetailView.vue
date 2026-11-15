<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { fetchProduct, type ProductDetail } from '../api/products'
import { useCompareStore } from '../stores/compare'

const route = useRoute()
const router = useRouter()
const compare = useCompareStore()

const product = ref<ProductDetail | null>(null)
const loading = ref(true)

const statusText: Record<string, string> = {
  DONE: '已入库',
  PENDING: '待解析',
  PARSING: '解析中',
  FAILED: '解析失败',
}

function toggleCompare() {
  if (!product.value) return
  if (!compare.has(product.value.id) && !compare.canAdd) {
    ElMessage.warning('最多对比 4 个产品')
    return
  }
  compare.toggle(product.value.id)
}

function askAdvisor() {
  router.push({ path: '/chat', query: { product: String(product.value?.id) } })
}

onMounted(async () => {
  try {
    product.value = await fetchProduct(Number(route.params.id))
  } catch (e) {
    ElMessage.error((e as Error).message)
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div v-loading="loading" class="container detail">
    <template v-if="product">
      <RouterLink to="/" class="back">← 返回产品库</RouterLink>

      <div class="layout">
        <div class="main">
          <header class="head rise">
            <p class="eyebrow">{{ product.company }} · {{ product.productType || product.categoryName }}</p>
            <h1 class="title">{{ product.name }}</h1>
            <p v-if="product.highlights" class="highlights">{{ product.highlights }}</p>
          </header>

          <figure v-if="product.coverImageUrl" class="cover rise rise-1">
            <img :src="product.coverImageUrl" :alt="product.name" />
            <figcaption>条款首页 / 产品资料图</figcaption>
          </figure>

          <section class="block rise rise-2">
            <h2 class="block-title">关键条款</h2>
            <dl class="spec">
              <div>
                <dt>投保年龄</dt>
                <dd>{{ product.minAge ?? '不限' }}–{{ product.maxAge ?? '不限' }} 岁</dd>
              </div>
              <div>
                <dt>保障期限</dt>
                <dd>{{ product.coverageTerm || product.periodDesc || '未披露' }}</dd>
              </div>
              <div>
                <dt>缴费期限</dt>
                <dd>{{ product.paymentTerm || '未披露' }}</dd>
              </div>
              <div>
                <dt>等待期</dt>
                <dd>{{ product.waitingDays != null ? `${product.waitingDays} 天` : '未披露' }}</dd>
              </div>
              <div>
                <dt>保证续保</dt>
                <dd>
                  {{ product.guaranteedRenewal === true ? '是' : product.guaranteedRenewal === false ? '否' : '条款未提及' }}
                </dd>
              </div>
              <div>
                <dt>备案编号</dt>
                <dd class="small">{{ product.registrationNo || '未披露' }}</dd>
              </div>
            </dl>
            <p v-if="product.verifiedFrom === 'clause_pdf'" class="source">
              以上字段抽取自条款原文，可在下方条款中核对页码。
            </p>
          </section>

          <section class="block rise rise-3">
            <h2 class="block-title">条款文档</h2>
            <ul v-if="product.clauses.length" class="clauses">
              <li v-for="c in product.clauses" :key="c.docId" class="clause">
                <div>
                  <p class="clause-name">{{ c.clauseName || '条款原文' }}</p>
                  <p class="clause-meta">
                    {{ c.fileType || 'PDF' }} · {{ c.pageCount ?? '—' }} 页
                    <span v-if="c.regNo"> · {{ c.regNo }}</span>
                  </p>
                </div>
                <span :class="['status', c.status?.toLowerCase()]">{{ statusText[c.status] || c.status }}</span>
              </li>
            </ul>
            <p v-else class="empty">该产品暂未取得条款原件，字段以公开目录为准。</p>
          </section>
        </div>

        <aside class="aside">
          <div class="quote-card">
            <p class="eyebrow">PRICE</p>
            <p class="price" :class="{ muted: product.priceStatus !== 'PUBLISHED' }">
              {{ product.priceDisplay }}
            </p>
            <div class="tags">
              <span v-for="l in product.labels" :key="l" class="tag">{{ l }}</span>
            </div>
            <el-button type="primary" class="cta" @click="askAdvisor">问顾问这款产品</el-button>
            <button class="cta-ghost" @click="toggleCompare">
              {{ compare.has(product.id) ? '已加入对比' : '加入对比' }}
            </button>
            <p class="disclaimer">
              产品资料来自公开披露文件，仅供研究参考，不构成投保建议。投保前请以保险公司正式条款为准。
            </p>
          </div>
        </aside>
      </div>
    </template>
  </div>
</template>

<style scoped>
.detail {
  min-height: 50vh;
}

.back {
  font-size: 13px;
  color: var(--muted);
  letter-spacing: 0.06em;
}

.back:hover {
  color: var(--teal);
}

.layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 340px;
  gap: 64px;
  margin-top: 28px;
}

.title {
  font-size: clamp(30px, 3.6vw, 46px);
  line-height: 1.25;
  margin: 14px 0 16px;
}

.highlights {
  color: var(--muted);
  font-size: 15px;
  max-width: 720px;
  margin: 0;
}

.cover {
  margin: 32px 0 0;
  border: 1px solid var(--line);
  background: var(--paper-deep);
}

.cover img {
  display: block;
  width: 100%;
  max-height: 520px;
  object-fit: cover;
  object-position: top center;
}

.cover figcaption {
  padding: 10px 14px;
  font-size: 11px;
  color: var(--muted);
  border-top: 1px solid var(--line);
  letter-spacing: 0.08em;
}

.block {
  margin-top: 48px;
  padding-top: 28px;
  border-top: 1px solid var(--line);
}

.block-title {
  font-size: 22px;
  margin-bottom: 20px;
}

.spec {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px 28px;
  margin: 0;
}

.spec dt {
  font-size: 11px;
  color: var(--muted);
  letter-spacing: 0.08em;
  margin-bottom: 5px;
}

.spec dd {
  margin: 0;
  font-size: 15px;
  font-variant-numeric: tabular-nums;
}

.spec dd.small {
  font-size: 12.5px;
  color: var(--ink-soft);
}

.source {
  margin-top: 22px;
  font-size: 12px;
  color: var(--teal);
  background: var(--teal-soft);
  padding: 10px 14px;
  border-radius: var(--radius-sm);
}

.clauses {
  list-style: none;
  margin: 0;
  padding: 0;
}

.clause {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
  padding: 16px 0;
  border-bottom: 1px solid var(--line);
}

.clause-name {
  margin: 0 0 4px;
  font-size: 15px;
}

.clause-meta {
  margin: 0;
  font-size: 12px;
  color: var(--muted);
}

.status {
  font-size: 11px;
  padding: 3px 10px;
  border-radius: var(--radius-pill);
  background: var(--paper-deep);
  color: var(--ink-soft);
  white-space: nowrap;
}

.status.done {
  background: var(--teal-soft);
  color: var(--teal);
}

.status.failed {
  background: #f3e0da;
  color: var(--danger);
}

.empty {
  color: var(--muted);
  font-size: 14px;
}

.aside {
  position: relative;
}

.quote-card {
  position: sticky;
  top: 104px;
  background: var(--paper-raised);
  border: 1px solid var(--line);
  padding: 28px 26px;
  box-shadow: var(--shadow-card);
}

.price {
  font-family: var(--display);
  font-size: 17px;
  line-height: 1.65;
  margin: 12px 0 18px;
}

.price.muted {
  color: var(--muted);
  font-size: 22px;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 22px;
}

.tag {
  font-size: 11px;
  padding: 3px 9px;
  border: 1px solid var(--line);
  color: var(--ink-soft);
}

.cta {
  width: 100%;
  height: 44px;
}

.cta-ghost {
  width: 100%;
  height: 42px;
  margin-top: 10px;
  background: transparent;
  border: 1px solid var(--line-strong);
  color: var(--ink);
  font-size: 14px;
  cursor: pointer;
  font-family: var(--body);
  transition: all 0.22s ease;
}

.cta-ghost:hover {
  border-color: var(--teal);
  color: var(--teal);
}

.disclaimer {
  margin: 20px 0 0;
  font-size: 11px;
  line-height: 1.7;
  color: var(--muted);
  border-top: 1px solid var(--line);
  padding-top: 14px;
}

@media (max-width: 960px) {
  .layout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .quote-card {
    position: static;
  }
  .spec {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
