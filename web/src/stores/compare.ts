import { defineStore } from 'pinia'
import { computed, ref, watch } from 'vue'

const KEY = 'ia.compare.ids'
const MAX = 4

export const useCompareStore = defineStore('compare', () => {
  const ids = ref<number[]>(load())

  function load(): number[] {
    try {
      const raw = localStorage.getItem(KEY)
      return raw ? (JSON.parse(raw) as number[]) : []
    } catch {
      return []
    }
  }

  watch(ids, (v) => localStorage.setItem(KEY, JSON.stringify(v)), { deep: true })

  const count = computed(() => ids.value.length)
  const canAdd = computed(() => ids.value.length < MAX)

  function toggle(id: number) {
    const i = ids.value.indexOf(id)
    if (i >= 0) ids.value.splice(i, 1)
    else if (ids.value.length < MAX) ids.value.push(id)
  }

  function has(id: number) {
    return ids.value.includes(id)
  }

  function remove(id: number) {
    ids.value = ids.value.filter((x) => x !== id)
  }

  function clear() {
    ids.value = []
  }

  return { ids, count, canAdd, toggle, has, remove, clear, MAX }
})
