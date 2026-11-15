<script setup lang="ts">
import { computed, nextTick, onMounted, reactive, ref } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'

interface Citation {
  index: number
  chunk_id: number
  parent_id: number
  product_id: number
  heading_path: string
  page_no: number
  snippet: string
}

interface ToolChip {
  name: string
  detail: string
}

interface Message {
  role: 'assistant' | 'user'
  text: string
  citations?: Citation[]
  tools?: ToolChip[]
  elapsedMs?: number
}

interface ConversationItem {
  id: number
  title: string
  lastIntent?: string
  updatedAt?: string
}

const STORAGE_KEY = 'ia.conversation.id'
const WELCOME = '你好，我是保顾问。可以问我条款细节、产品推荐或产品差异，答案会标注出自条款第几页。'

const route = useRoute()
const productId = route.query.product ? Number(route.query.product) : undefined

const messages = ref<Message[]>([{ role: 'assistant', text: WELCOME }])
const conversations = ref<ConversationItem[]>([])
const activeId = ref<number | null>(null)
const input = ref('')
const sending = ref(false)
const error = ref('')
const streamRef = ref<HTMLElement | null>(null)
const showNeeds = ref(false)

const activeTitle = computed(
  () => conversations.value.find((c) => c.id === activeId.value)?.title || '顾问对话',
)

const needsSubmitted = ref(false)
const lastAnswer = computed(() =>
  [...messages.value].reverse().find(
    (m) => m.role === 'assistant' && (m.citations?.length || m.tools?.length || m.text),
  ),
)
const railCitations = computed(() => lastAnswer.value?.citations ?? [])
const railTools = computed(() => lastAnswer.value?.tools ?? [])
const railElapsed = computed(() => lastAnswer.value?.elapsedMs)
const needsSummary = computed(
  () => `${needs.age} 岁 · ${needs.occupation} · ${needs.budget} · ${needs.family} · ${needs.category}`,
)

const samples = [
  '这款产品的等待期是多久？',
  '我是程序员，30 岁，推荐什么医疗险？',
  '我是货车司机，适合买什么保险？',
  '这款和同类产品比有什么区别？',
]

const needs = reactive({
  age: 30,
  occupation: '程序员',
  budget: '3000 元以内',
  family: '三口之家',
  category: '医疗险',
})
const occupations = ['程序员', '教师', '销售', '司机', '建筑工人', '医生', '其他']
const budgets = ['500 元以内', '1000 元以内', '3000 元以内', '不限']
const families = ['单身', '两口之家', '三口之家', '有老人同住']
const categories = ['医疗险', '意外险', '重疾险', '寿险', '不确定']

async function api<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(path, init)
  const body = await res.json()
  if (body?.code !== 0) throw new Error(body?.message || `请求失败 ${res.status}`)
  return body.data as T
}

async function loadConversations() {
  try {
    const data = await api<{ records: ConversationItem[] }>('/api/v1/conversations?page=1&size=30')
    conversations.value = data.records
  } catch {
    /* 列表失败不影响对话 */
  }
}

async function createConversation() {
  const data = await api<ConversationItem>('/api/v1/conversations', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: '{}',
  })
  activeId.value = data.id
  localStorage.setItem(STORAGE_KEY, String(data.id))
  messages.value = [{ role: 'assistant', text: WELCOME }]
  await loadConversations()
}

async function openConversation(id: number) {
  activeId.value = id
  localStorage.setItem(STORAGE_KEY, String(id))
  error.value = ''
  try {
    const rows = await api<Array<{
      role: string
      content: string
      citationsJson?: string
      toolsJson?: string
      elapsedMs?: number
    }>>(`/api/v1/conversations/${id}/messages`)
    const parse = <T>(raw?: string): T | undefined => {
      if (!raw) return undefined
      try {
        return JSON.parse(raw) as T
      } catch {
        return undefined
      }
    }
    messages.value = rows.length
      ? rows.map((m) => ({
          role: m.role === 'user' ? 'user' : 'assistant',
          text: m.content,
          citations: parse<Citation[]>(m.citationsJson),
          tools: parse<ToolChip[]>(m.toolsJson),
          elapsedMs: m.elapsedMs ?? undefined,
        }))
      : [{ role: 'assistant', text: WELCOME }]
  } catch {
    messages.value = [{ role: 'assistant', text: WELCOME }]
  }
  scrollToBottom()
}

function inline(text: string): string {
  return text
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\n/g, '<br>')
}

/** 按空行分段渲染，避免连续 <br> 造成过大留白 */
function renderMarkdown(text: string): string {
  const escaped = text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
  const blocks = escaped.split(/\n{2,}/).map((b) => b.trim()).filter(Boolean)
  const out: string[] = []
  for (const block of blocks) {
    const lines = block.split('\n')
    const first = lines[0]
    if (/^###\s+/.test(first)) {
      out.push(`<h4>${inline(first.replace(/^###\s+/, ''))}</h4>`)
      const rest = lines.slice(1).join('\n').trim()
      if (rest) out.push(`<p>${inline(rest)}</p>`)
      continue
    }
    if (/^##\s+/.test(first)) {
      out.push(`<h3>${inline(first.replace(/^##\s+/, ''))}</h3>`)
      const rest = lines.slice(1).join('\n').trim()
      if (rest) out.push(`<p>${inline(rest)}</p>`)
      continue
    }
    if (lines.every((l) => /^[-*]\s+/.test(l))) {
      const items = lines.map((l) => `<li>${inline(l.replace(/^[-*]\s+/, ''))}</li>`).join('')
      out.push(`<ul>${items}</ul>`)
      continue
    }
    out.push(`<p>${inline(block)}</p>`)
  }
  return out.join('')
}

async function scrollToBottom() {
  await nextTick()
  streamRef.value?.scrollTo({ top: streamRef.value.scrollHeight, behavior: 'smooth' })
}

function historyPayload() {
  return messages.value
    .filter((m) => m.text.trim())
    .slice(-10)
    .map((m) => ({ role: m.role, content: m.text }))
}

async function send(text?: string) {
  const question = (text ?? input.value).trim()
  if (!question || sending.value) return
  if (!activeId.value) await createConversation()

  input.value = ''
  error.value = ''
  const history = historyPayload()
  messages.value.push({ role: 'user', text: question })
  messages.value.push({ role: 'assistant', text: '' })
  const reply = messages.value[messages.value.length - 1]
  sending.value = true
  scrollToBottom()

  let queue = ''
  let timer: number | undefined
  const typewrite = () => {
    if (timer) return
    timer = window.setInterval(() => {
      if (!queue) {
        window.clearInterval(timer)
        timer = undefined
        return
      }
      const take = Math.min(3, queue.length)
      reply.text += queue.slice(0, take)
      queue = queue.slice(take)
      scrollToBottom()
    }, 16)
  }
  const drain = () =>
    new Promise<void>((resolve) => {
      const check = () => {
        if (!queue && !timer) resolve()
        else window.setTimeout(check, 30)
      }
      if (!queue) typewrite()
      check()
    })
  const resetTo = (full: string) => {
    if (timer) window.clearInterval(timer)
    timer = undefined
    queue = ''
    reply.text = ''
    if (full) {
      queue = full
      typewrite()
    }
  }

  try {
    const res = await fetch('/v1/chat/stream', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: question,
        product_id: productId,
        conversation_id: activeId.value,
        history,
      }),
    })
    if (!res.ok || !res.body) throw new Error(`服务返回 ${res.status}`)

    const reader = res.body.getReader()
    const decoder = new TextDecoder()
    let buffer = ''
    let done = false

    const handle = (block: string) => {
      const event = block.match(/^event:\s*(.+)$/m)?.[1]
      const dataLine = block.match(/^data:\s*(.+)$/m)?.[1]
      if (!event || !dataLine) return
      const payload = JSON.parse(dataLine)
      if (event === 'meta') {
        reply.tools = payload.tools || []
        reply.elapsedMs = payload.elapsedMs
      } else if (event === 'delta') {
        queue += payload.text
        typewrite()
      } else if (event === 'final') {
        const shown = reply.text + queue
        const finalText: string = payload.answer || ''
        if (finalText.startsWith(shown)) {
          queue += finalText.slice(shown.length)
          typewrite()
        } else if (!shown.startsWith(finalText)) {
          resetTo(finalText)
        }
      } else if (event === 'citations') {
        reply.citations = payload.citations
      } else if (event === 'error') {
        error.value = payload.message || '对话失败'
      } else if (event === 'done') {
        done = true
      }
    }

    while (true) {
      const { done: streamDone, value } = await reader.read()
      if (streamDone) break
      buffer += decoder.decode(value, { stream: true })
      const blocks = buffer.split('\n\n')
      buffer = blocks.pop() ?? ''
      blocks.forEach(handle)
    }
    if (buffer.trim()) handle(buffer)
    if (done) await drain()
    await drain()
  } catch (e) {
    error.value = (e as Error).message
    if (!reply.text) reply.text = '抱歉，服务暂时不可用，请稍后再试。'
  } finally {
    await drain()
    sending.value = false
    scrollToBottom()
    loadConversations()
  }
}

function submitNeeds() {
  const text = `我是${needs.occupation}，${needs.age}岁，预算${needs.budget}，${needs.family}，想了解${needs.category}，请推荐`
  needsSubmitted.value = true
  showNeeds.value = false
  send(text)
}

async function newConversation() {
  if (sending.value) return
  try {
    await createConversation()
  } catch (e) {
    error.value = (e as Error).message
  }
}

async function renameConversation(target: ConversationItem) {
  try {
    const { value } = await ElMessageBox.prompt('输入新的会话名称', '重命名会话', {
      inputValue: target.title,
      confirmButtonText: '保存',
      cancelButtonText: '取消',
      inputValidator: (v: string) => (v?.trim() ? true : '名称不能为空'),
    })
    await api(`/api/v1/conversations/${target.id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: value.trim() }),
    })
    await loadConversations()
    ElMessage.success('已重命名')
  } catch (e) {
    if (e !== 'cancel' && e !== 'close') {
      ElMessage.error((e as Error).message || '重命名失败')
    }
  }
}

async function deleteConversation(target: ConversationItem) {
  try {
    await ElMessageBox.confirm(
      `删除「${target.title}」？消息与记忆快照会一并清除，且不可恢复。`,
      '删除会话',
      { type: 'warning', confirmButtonText: '删除', cancelButtonText: '取消' },
    )
    await api(`/api/v1/conversations/${target.id}`, { method: 'DELETE' })
    await loadConversations()
    if (activeId.value === target.id) {
      if (conversations.value.length) await openConversation(conversations.value[0].id)
      else await createConversation()
    }
    ElMessage.success('已删除')
  } catch (e) {
    if (e !== 'cancel' && e !== 'close') {
      ElMessage.error((e as Error).message || '删除失败')
    }
  }
}

onMounted(async () => {
  await loadConversations()
  const saved = Number(localStorage.getItem(STORAGE_KEY))
  if (saved && conversations.value.some((c) => c.id === saved)) {
    await openConversation(saved)
  } else if (conversations.value.length) {
    await openConversation(conversations.value[0].id)
  } else {
    try {
      await createConversation()
    } catch (e) {
      error.value = (e as Error).message
    }
  }
})
</script>

<template>
  <div class="chat">
    <aside class="side">
      <div class="brand">
        <span class="brand-mark">保</span>
        <span class="brand-name">保顾问</span>
      </div>

      <button class="new" @click="newConversation">＋ 新对话</button>

      <p class="side-label">最近</p>
      <ul class="threads">
        <li v-for="c in conversations" :key="c.id">
          <div
            :class="['thread', { active: c.id === activeId }]"
            :data-id="c.id"
            role="button"
            tabindex="0"
            @click="openConversation(c.id)"
            @keydown.enter="openConversation(c.id)"
          >
            <span class="t-title">{{ c.title || '未命名对话' }}</span>
            <span class="thread-actions">
              <button class="icon-btn" title="重命名" @click.stop="renameConversation(c)">✎</button>
              <button class="icon-btn" title="删除" @click.stop="deleteConversation(c)">×</button>
            </span>
          </div>
        </li>
        <li v-if="!conversations.length" class="thread-empty">还没有会话</li>
      </ul>

      <div class="side-foot">
        <div class="side-links">
          <RouterLink to="/">产品库</RouterLink>
          <RouterLink to="/compare">对比</RouterLink>
        </div>
        <p class="side-note">会话与记忆已持久化，刷新后可继续追问。</p>
      </div>
    </aside>

    <section class="room">
      <div class="room-body">
        <div class="content-col">
          <header class="topbar">
            <div class="topbar-center">
              <p class="topbar-title">{{ activeTitle }}</p>
              <p class="topbar-sub">AI 生成内容可能有误，请核对条款原文</p>
            </div>
            <button class="needs-toggle" @click="showNeeds = !showNeeds">
              {{ showNeeds ? '收起需求表' : '填写需求' }}
            </button>
          </header>
      <div ref="streamRef" class="stream">
        <div class="stream-inner">
          <section v-if="showNeeds" class="needs">
            <div class="needs-head">
              <div>
                <p class="needs-eyebrow">NEEDS PROFILE</p>
                <h2 class="needs-title serif">先说说你的基本情况</h2>
              </div>
              <button class="needs-close" @click="showNeeds = false">收起</button>
            </div>
            <div class="needs-grid">
              <label class="field">
                <span>年龄</span>
                <input v-model.number="needs.age" type="number" min="0" max="100" />
              </label>
              <label class="field">
                <span>职业</span>
                <select v-model="needs.occupation">
                  <option v-for="o in occupations" :key="o">{{ o }}</option>
                </select>
              </label>
              <label class="field">
                <span>年预算</span>
                <select v-model="needs.budget">
                  <option v-for="b in budgets" :key="b">{{ b }}</option>
                </select>
              </label>
              <label class="field">
                <span>家庭结构</span>
                <select v-model="needs.family">
                  <option v-for="f in families" :key="f">{{ f }}</option>
                </select>
              </label>
              <label class="field">
                <span>关注险种</span>
                <select v-model="needs.category">
                  <option v-for="c in categories" :key="c">{{ c }}</option>
                </select>
              </label>
              <button class="needs-submit" @click="submitNeeds">生成建议 →</button>
            </div>
          </section>

          <div v-for="(m, i) in messages" :key="i" :class="['msg', m.role]">
            <div class="bubble">
              <div v-if="m.tools?.length" class="tool-row">
                <span v-for="t in m.tools" :key="t.name" class="tool-chip">{{ t.detail }}</span>
                <span v-if="m.elapsedMs" class="tool-time">{{ m.elapsedMs }} ms</span>
              </div>
              <div v-if="m.text" class="text" v-html="renderMarkdown(m.text)" />
              <p v-else class="typing"><span /><span /><span /></p>

              <div v-if="m.citations?.length" class="cites">
                <div v-for="c in m.citations" :key="c.chunk_id" class="cite">
                  <span class="cite-index">{{ c.index }}</span>
                  <div>
                    <p class="cite-title">{{ c.heading_path }}</p>
                    <p class="cite-page">条款第 {{ c.page_no }} 页</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <p v-if="error" class="error">{{ error }}</p>

          <div v-if="!sending" class="hint">
            <p class="hint-title">可以这样问</p>
            <div class="chips">
              <button v-for="s in samples" :key="s" class="chip" @click="send(s)">{{ s }}</button>
            </div>
          </div>

          <div v-if="productId" class="context-tip">已关联产品 #{{ productId }}</div>
        </div>
      </div>

      <footer class="composer">
        <div class="composer-inner">
          <div class="input-row">
            <textarea
              v-model="input"
              :disabled="sending"
              placeholder="发消息或按 Enter 发送…"
              rows="1"
              @keydown.enter.exact.prevent="send()"
            />
            <button class="send" :disabled="sending || !input.trim()" @click="send()">
              {{ sending ? '…' : '↑' }}
            </button>
          </div>
          <p class="composer-note">回答附条款页码引用；涉及投保建议时会提示咨询持牌顾问。</p>
        </div>
      </footer>
        </div>

        <aside class="rail">
          <p class="rail-label">CONTEXT · 本次回答</p>

          <div v-if="railTools.length" class="rail-card">
            <p class="rail-sub">工具调用</p>
            <div class="rail-tags">
              <span v-for="t in railTools" :key="t.name" class="rail-tag">{{ t.detail }}</span>
              <span v-if="railElapsed" class="rail-tag rail-tag--muted">{{ railElapsed }} ms</span>
            </div>
          </div>

          <div v-if="railCitations.length" class="rail-card">
            <p class="rail-sub">引用来源</p>
            <div v-for="c in railCitations" :key="c.chunk_id" class="rail-cite">
              <span class="rail-index">{{ c.index }}</span>
              <div>
                <p class="rail-title">{{ c.heading_path }}</p>
                <p class="rail-page">条款第 {{ c.page_no }} 页</p>
              </div>
            </div>
          </div>

          <div v-if="needsSubmitted" class="rail-card">
            <p class="rail-sub">需求摘要</p>
            <p class="rail-text">{{ needsSummary }}</p>
          </div>

          <p v-if="!railTools.length && !railCitations.length && !needsSubmitted" class="rail-empty">
            回答后，这里会显示条款引用、工具调用与需求摘要。
          </p>
        </aside>
      </div>
    </section>
  </div>
</template>

<style scoped>
.chat {
  display: grid;
  /* 侧栏约 22%，内容区铺满剩余宽度 */
  grid-template-columns: clamp(280px, 22vw, 360px) minmax(0, 1fr);
  height: 100vh;
  background: var(--paper);
}

.side {
  border-right: 1px solid var(--line);
  padding: 16px 12px;
  display: flex;
  flex-direction: column;
  background: color-mix(in srgb, var(--paper-deep) 35%, var(--paper));
  min-height: 0;
}

.brand {
  display: flex;
  align-items: center;
  gap: 9px;
  padding: 4px 8px 14px;
}

.brand-mark {
  width: 28px;
  height: 28px;
  border: 1px solid var(--ink);
  border-radius: 50%;
  display: grid;
  place-items: center;
  font-family: var(--display);
  font-size: 14px;
}

.brand-name {
  font-family: var(--display);
  font-size: 16px;
  letter-spacing: 0.06em;
}

.new {
  border: 1px solid var(--line-strong);
  background: var(--paper-raised);
  padding: 9px 12px;
  font-size: 13px;
  color: var(--ink);
  cursor: pointer;
  font-family: var(--body);
  text-align: left;
  border-radius: var(--radius);
  transition: border-color 0.15s ease, color 0.15s ease;
}

.new:hover {
  border-color: var(--teal);
  color: var(--teal);
}

.side-label {
  margin: 18px 8px 8px;
  font-family: var(--mono);
  font-size: 10px;
  letter-spacing: 0.22em;
  color: var(--muted);
}

.threads {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
  overflow-y: auto;
  flex: 1;
  min-height: 0;
}

.thread {
  position: relative;
  width: 100%;
  padding: 8px 10px;
  cursor: pointer;
  border-radius: var(--radius-sm);
  transition: background 0.15s ease;
}

.thread:hover {
  background: rgba(16, 26, 36, 0.05);
}

.thread.active {
  background: var(--paper-raised);
  box-shadow: inset 2px 0 0 var(--gold);
}

.t-title {
  display: block;
  font-size: 13px;
  color: var(--ink-soft);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: calc(100% - 48px);
}

.thread.active .t-title {
  color: var(--ink);
}

.thread-actions {
  position: absolute;
  right: 6px;
  top: 6px;
  display: flex;
  gap: 2px;
  opacity: 0;
  transition: opacity 0.15s ease;
}

.thread:hover .thread-actions,
.thread:focus-within .thread-actions {
  opacity: 1;
}

.icon-btn {
  width: 22px;
  height: 22px;
  border: 1px solid var(--line);
  background: var(--paper-raised);
  color: var(--muted);
  font-size: 12px;
  line-height: 1;
  cursor: pointer;
  display: grid;
  place-items: center;
  padding: 0;
  border-radius: var(--radius-sm);
}

.icon-btn:hover {
  border-color: var(--teal);
  color: var(--teal);
}

.icon-btn:last-child:hover {
  border-color: var(--danger);
  color: var(--danger);
}

.thread-empty {
  font-size: 12px;
  color: var(--muted);
  padding: 10px;
}

.side-foot {
  border-top: 1px solid var(--line);
  padding-top: 12px;
  margin-top: 8px;
}

.side-links {
  display: flex;
  gap: 16px;
  padding: 0 8px 8px;
}

.side-links a {
  font-size: 12px;
  color: var(--ink-soft);
}

.side-links a:hover {
  color: var(--teal);
}

.side-note {
  margin: 0;
  padding: 0 8px;
  font-size: 10.5px;
  line-height: 1.6;
  color: var(--muted);
}

.room {
  position: relative;
  display: flex;
  flex-direction: column;
  min-width: 0;
  height: 100vh;
}

.room-body {
  flex: 1;
  min-height: 0;
  display: flex;
}

.content-col {
  position: relative;
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.topbar {
  height: 54px;
  flex: none;
  border-bottom: 1px solid var(--line);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  background: color-mix(in srgb, var(--paper) 85%, transparent);
}

.topbar-center {
  text-align: center;
  line-height: 1.25;
}

.topbar-title {
  margin: 0;
  font-size: 14px;
  color: var(--ink);
  font-weight: 500;
  max-width: 520px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.topbar-sub {
  margin: 1px 0 0;
  font-size: 10.5px;
  color: var(--muted);
}

.needs-toggle {
  position: absolute;
  right: 16px;
  top: 14px;
  border: 1px solid var(--line);
  background: transparent;
  color: var(--ink-soft);
  font-size: 12px;
  padding: 5px 11px;
  border-radius: var(--radius-pill);
  cursor: pointer;
  font-family: var(--body);
}

.needs-toggle:hover {
  border-color: var(--teal);
  color: var(--teal);
}

.stream {
  flex: 1;
  overflow-y: auto;
  padding: 22px 0 0;
}

.stream-inner {
  /* 常见笔记本宽度下铺满，超宽屏才封顶，避免长行不可读 */
  max-width: 1440px;
  margin: 0 auto;
  padding: 0 28px 150px;
  display: flex;
  flex-direction: column;
  gap: 22px;
}

.msg {
  display: flex;
}

.msg.user {
  justify-content: flex-end;
}

.bubble {
  max-width: 100%;
  font-size: 18px;
  line-height: 1.85;
  color: var(--ink);
}

.msg.user .bubble {
  max-width: 72%;
  padding: 11px 15px;
  background: #eef0f2;
  color: var(--ink);
  border-radius: var(--radius-md);
  font-size: 17px;
  line-height: 1.7;
}

.msg.user .text :deep(strong) {
  color: var(--ink);
}

.text {
  margin: 0;
}

.text :deep(strong) {
  font-weight: 600;
  color: var(--ink);
}

.text :deep(p) {
  margin: 0 0 12px;
}

.text :deep(p:last-child) {
  margin-bottom: 0;
}

.text :deep(h3),
.text :deep(h4) {
  font-family: var(--display);
  font-size: 18px;
  font-weight: 600;
  margin: 18px 0 8px;
}

.text :deep(h3:first-child),
.text :deep(h4:first-child) {
  margin-top: 0;
}

.text :deep(ul) {
  margin: 0 0 12px;
  padding-left: 20px;
}

.text :deep(li) {
  margin: 3px 0;
}

.typing {
  display: flex;
  gap: 4px;
  margin: 6px 0;
}

.typing span {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--gold);
  animation: blink 1.1s infinite ease-in-out;
}

.typing span:nth-child(2) { animation-delay: 0.15s; }
.typing span:nth-child(3) { animation-delay: 0.3s; }

@keyframes blink {
  0%, 80%, 100% { opacity: 0.25; }
  40% { opacity: 1; }
}

.cites {
  margin-top: 12px;
  padding-top: 10px;
  border-top: 1px solid var(--line);
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.cite {
  display: flex;
  gap: 8px;
  align-items: flex-start;
}

.cite-index {
  width: 20px;
  height: 20px;
  border: 1px solid var(--gold);
  color: var(--gold);
  display: grid;
  place-items: center;
  font-family: var(--mono);
  font-size: 10px;
  flex: none;
  border-radius: var(--radius-sm);
}

.cite-title {
  margin: 0;
  font-size: 12.5px;
  color: var(--teal);
}

.cite-page {
  margin: 1px 0 0;
  font-size: 11px;
  color: var(--muted);
}

.tool-row {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-wrap: wrap;
  margin-bottom: 8px;
}

.tool-chip {
  font-size: 11px;
  color: var(--muted);
  border: 1px solid var(--line);
  border-radius: var(--radius-pill);
  padding: 2px 8px;
  background: rgba(236, 228, 213, 0.35);
}

.tool-time {
  font-family: var(--mono);
  font-size: 10px;
  color: var(--muted);
}

.error {
  margin: 0;
  font-size: 13px;
  color: var(--danger);
}

.hint {
  padding-top: 6px;
}

.hint-title {
  font-size: 10px;
  letter-spacing: 0.16em;
  color: var(--muted);
  font-family: var(--mono);
  margin-bottom: 8px;
}

.chips {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.chip {
  font-size: 12.5px;
  border: 1px solid var(--line);
  padding: 6px 12px;
  color: var(--ink-soft);
  background: var(--paper-raised);
  cursor: pointer;
  font-family: var(--body);
  border-radius: var(--radius-pill);
  transition: border-color 0.15s ease, color 0.15s ease;
}

.chip:hover {
  border-color: var(--teal);
  color: var(--teal);
}

.context-tip {
  font-size: 11px;
  color: var(--muted);
}

/* 输入区固定在底部，悬浮在内容之上 */
.composer {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 10px 0 14px;
  background: linear-gradient(to top, var(--paper) 62%, transparent);
}

.composer-inner {
  /* 输入框保持短于正文，避免超宽输入行 */
  max-width: 820px;
  margin: 0 auto;
  padding: 0 28px;
}

.input-row {
  display: flex;
  gap: 8px;
  align-items: center;
  border: 1px solid var(--line-strong);
  border-radius: var(--radius-lg);
  background: var(--paper-raised);
  padding: 8px 8px 8px 14px;
  box-shadow: 0 12px 30px -24px rgba(16, 26, 36, 0.55);
  transition: border-color 0.15s ease;
}

.input-row:focus-within {
  border-color: var(--teal);
}

textarea {
  flex: 1;
  resize: none;
  border: 0;
  background: transparent;
  padding: 6px 0;
  font-family: var(--body);
  font-size: 15px;
  line-height: 1.5;
  color: var(--ink);
  outline: none;
}

.send {
  width: 36px;
  height: 36px;
  flex: none;
  border-radius: 50%;
  background: var(--ink);
  color: var(--paper);
  border: 0;
  font-size: 16px;
  cursor: pointer;
  display: grid;
  place-items: center;
  transition: background 0.15s ease, opacity 0.15s ease;
}

.send:hover:not(:disabled) {
  background: var(--teal);
}

.send:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.composer-note {
  margin: 8px 0 0;
  font-size: 10.5px;
  color: var(--muted);
  text-align: center;
}

.needs {
  border: 1px solid var(--line);
  background: var(--paper-raised);
  border-radius: var(--radius-md);
  padding: 16px 18px 18px;
  box-shadow: var(--shadow-soft);
}

.needs-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 14px;
}

.needs-eyebrow {
  margin: 0 0 4px;
  font-family: var(--mono);
  font-size: 9.5px;
  letter-spacing: 0.22em;
  color: var(--gold);
}

.needs-title {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
}

.needs-close {
  border: 0;
  background: none;
  color: var(--muted);
  font-size: 11.5px;
  cursor: pointer;
}

.needs-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr)) auto;
  gap: 10px;
  align-items: end;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.field span {
  font-size: 10.5px;
  color: var(--muted);
  letter-spacing: 0.06em;
}

.field input,
.field select {
  width: 100%;
  border: 1px solid var(--line);
  background: var(--paper);
  border-radius: var(--radius-sm);
  padding: 8px 9px;
  font-size: 13px;
  font-family: var(--body);
  color: var(--ink);
  outline: none;
}

.field input:focus,
.field select:focus {
  border-color: var(--teal);
}

.needs-submit {
  height: 36px;
  padding: 0 14px;
  border: 0;
  background: var(--ink);
  color: var(--paper);
  border-radius: var(--radius-sm);
  font-size: 12.5px;
  cursor: pointer;
  white-space: nowrap;
}

.needs-submit:hover {
  background: var(--teal);
}

/* 宽屏右侧上下文栏：只在 ≥1800 出现 */
.rail {
  display: none;
  width: 360px;
  flex: none;
  border-left: 1px solid var(--line);
  padding: 20px 18px 28px;
  overflow-y: auto;
  background: color-mix(in srgb, var(--paper-deep) 22%, var(--paper));
}

.rail-label {
  margin: 0 0 12px;
  font-family: var(--mono);
  font-size: 10px;
  letter-spacing: 0.2em;
  color: var(--muted);
}

.rail-card {
  border: 1px solid var(--line);
  border-radius: var(--radius-md);
  background: var(--paper-raised);
  padding: 12px 14px;
  margin-bottom: 12px;
}

.rail-sub {
  margin: 0 0 8px;
  font-size: 11px;
  letter-spacing: 0.08em;
  color: var(--muted);
}

.rail-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.rail-tag {
  font-size: 11px;
  border: 1px solid var(--line);
  border-radius: var(--radius-pill);
  padding: 2px 8px;
  color: var(--ink-soft);
  background: var(--paper);
}

.rail-tag--muted {
  color: var(--muted);
  font-family: var(--mono);
}

.rail-cite {
  display: flex;
  gap: 8px;
  padding: 8px 0;
  border-bottom: 1px solid var(--line);
}

.rail-cite:last-child {
  border-bottom: 0;
  padding-bottom: 0;
}

.rail-index {
  width: 18px;
  height: 18px;
  flex: none;
  border: 1px solid var(--gold);
  color: var(--gold);
  border-radius: var(--radius-sm);
  display: grid;
  place-items: center;
  font-family: var(--mono);
  font-size: 9px;
}

.rail-title {
  margin: 0;
  font-size: 12px;
  line-height: 1.45;
  color: var(--teal);
}

.rail-page {
  margin: 2px 0 0;
  font-size: 10.5px;
  color: var(--muted);
}

.rail-text {
  margin: 0;
  font-size: 12px;
  line-height: 1.6;
  color: var(--ink-soft);
}

.rail-empty {
  margin: 0;
  font-size: 11.5px;
  line-height: 1.7;
  color: var(--muted);
}

@media (min-width: 1800px) {
  .rail {
    display: block;
  }
  /* 宽屏下引用已在右栏展示，正文内不再重复 */
  .cites {
    display: none;
  }
}

@media (max-width: 900px) {
  .chat { grid-template-columns: 1fr; }
  .side { display: none; }
  .composer { left: 0; }
  .stream-inner,
  .composer-inner { padding-left: 16px; padding-right: 16px; }
  .needs-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .needs-submit { grid-column: span 2; }
}
</style>
