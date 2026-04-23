import { useEffect, useRef } from 'react'

export function useNotifications(tasks) {
  const notified = useRef(new Set())

  useEffect(() => {
    if (Notification.permission === 'default') Notification.requestPermission()
  }, [])

  useEffect(() => {
    const check = () => {
      if (Notification.permission !== 'granted') return
      const now = new Date()
      tasks.forEach(t => {
        if (!t.reminder_at || notified.current.has(t.task_id)) return
        const diff = new Date(t.reminder_at) - now
        if (diff >= 0 && diff <= 60000) {
          new Notification(`🔔 Recordatorio: ${t.task_name}`)
          notified.current.add(t.task_id)
        }
      })
    }
    check()
    const id = setInterval(check, 60000)
    return () => clearInterval(id)
  }, [tasks])
}
