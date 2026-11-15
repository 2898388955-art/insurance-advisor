<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { fetchCompare, type CompareResult } from '../api/products'
import { useCompareStore } from '../stores/compare'

const store = useCompareStore()
const route = useRoute()
const data = ref<CompareResult | null>(null)
const loading = ref(false)

const diffFields = computed(() => {
  if (!data.value) return new Set<string>()
  return new Set(
    data.value.rows.filter((r) => new Set(r.values).size > 1).map((r) => r.field),
  )
})

async function load() {
  if (store.ids.length < 2) {
    data.value = null
    return
  }
  loading.value = true
  try {
    data.value = await fetchCompare(store.ids)
  } catch (e) {
    ElMessage.error((e as Error).message)
    data.value = null
  } finally {
    loading.value = false
  }
}

function remove(id: number) {
  store.remove(id)
  load()
}

watch(() => store.ids.slice(), load)
onMounted(() => {
  // 支持 ?ids=1,2,3 直接分享对比链接
  const raw = route.query.ids
  if (typeof raw === 'string') {
    const parsed = raw.split(',').map(Number).filter((n) => Number.isFinite(n)).slice(0, 4)
    if (parsed.length >= 2) store.ids = parsed
  }
  load()
})
</script>

<template>
  <div class="container">
    <header class="head rise">
      <p class="eyebrow">SIDE BY SIDE</p>
      <h1 class="title">把差异摊开看</h1>
      <p class="sub">只高亮有差异的行。空值显示为「未披露」，不做推测。</p>
    </header>

    <div v-if="!data" class="empty rise rise-1">
      <p class="serif empty-title">还没有选择产品</p>
      <p class="muted">回到产品库，挑 2–4 个产品加入对比。</p>
      <RouterLink to="/" class="back-link">去产品库 →</RouterLink>
    </div>

    <div v-else v-loading="loading" class="table-wrap rise rise-1">
      <table class="compare">
        <thead>
          <tr>
            <th class="corner">对比项</th>
            <th v-for="p in data.products" :key="p.id">
              <div class="p-head">
                <button class="remove" title="移除" @click="remove(p.id)">×</button>
                <RouterLink :to="`/products/${p.id}`" class="p-name serif">{{ p.name }}</RouterLink>
                <span class="p-company">{{ p.company }}</span>
              </div>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in data.rows" :key="row.field" :class="{ diff: diffFields.has(row.field) }">
            <th class="label">
              {{ row.label }}
              <span v-if="diffFields.has(row.field)" class="diff-dot" />
            </th>
            <td v-for="(v, i) in row.values" :key="i">{{ v }}</td>
          </tr>
        </tbody>
      </table>
      <p class="legend">带 <span class="dot" /> 的行表示产品间存在差异</p>
    </div>
  </div>
</template>

<style scoped>
.head {
  padding-bottom: 32px;
  border-bottom: 1px solid var(--line);
}

.title {
  font-size: clamp(32px, 4vw, 52px);
  margin: 14px 0 12px;
}

.sub {
  color: var(--muted);
  margin: 0;
  font-size: 14px;
}

.empty {
  padding: 96px 0;
  text-align: center;
}

.empty-title {
  font-size: 28px;
  margin-bottom: 8px;
}

.back-link {
  display: inline-block;
  margin-top: 18px;
  color: var(--teal);
  font-size: 14px;
}

.table-wrap {
  overflow-x: auto;
  margin-top: 36px;
}

.compare {
  width: 100%;
  border-collapse: collapse;
  min-width: 760px;
}

.compare th,
.compare td {
  text-align: left;
  padding: 18px 20px;
  border-bottom: 1px solid var(--line);
  font-weight: 400;
  font-size: 14px;
  vertical-align: top;
}

.corner {
  width: 150px;
  font-family: var(--mono);
  font-size: 10px;
  letter-spacing: 0.2em;
  color: var(--muted);
}

.p-head {
  position: relative;
  padding-right: 18px;
}

.p-name {
  display: block;
  font-size: 17px;
  line-height: 1.4;
  margin-bottom: 6px;
  color: var(--ink);
}

.p-name:hover {
  color: var(--teal);
}

.p-company {
  font-size: 11.5px;
  color: var(--muted);
}

.remove {
  position: absolute;
  right: 0;
  top: -2px;
  border: 0;
  background: none;
  color: var(--muted);
  font-size: 18px;
  line-height: 1;
  cursor: pointer;
}

.remove:hover {
  color: var(--danger);
}

.label {
  position: sticky;
  left: 0;
  background: var(--paper);
  font-size: 12.5px;
  color: var(--muted);
  display: flex;
  align-items: center;
  gap: 8px;
}

tr.diff td {
  background: rgba(176, 134, 60, 0.07);
}

.diff-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--gold);
}

.dot {
  display: inline-block;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--gold);
}

.legend {
  font-size: 11.5px;
  color: var(--muted);
  margin-top: 14px;
}
</style>
