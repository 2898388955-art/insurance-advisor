import axios from 'axios'

export const http = axios.create({
  baseURL: '/api/v1',
  timeout: 20000,
})

http.interceptors.response.use(
  (res) => {
    const body = res.data
    if (body && typeof body.code === 'number' && body.code !== 0) {
      return Promise.reject(new Error(body.message || '请求失败'))
    }
    return body.data
  },
  (err) => {
    const msg = err?.response?.data?.message || err.message || '网络错误'
    return Promise.reject(new Error(msg))
  },
)
