const BASE = import.meta.env.VITE_API_URL || 'http://localhost:8000'

export const api = {
  getTasks: (userId) => fetch(`${BASE}/tasks${userId ? `?user_id=${userId}` : ''}`).then(r => r.json()),
  createTask: (data) => fetch(`${BASE}/tasks`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) }).then(r => r.json()),
  updateTask: (id, data) => fetch(`${BASE}/tasks/${id}`, { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) }).then(r => r.json()),
  deleteTask: (id) => fetch(`${BASE}/tasks/${id}`, { method: 'DELETE' }),
  getUsers: () => fetch(`${BASE}/users`).then(r => r.json()),
  createUser: (data) => fetch(`${BASE}/users`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) }).then(r => r.json()),
}
