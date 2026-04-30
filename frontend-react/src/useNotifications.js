import { useEffect, useRef } from 'react'

const WINDOW_MS = 60000        // dispara si faltan <= 60 segundos
const INTERVAL_MS = 30000      // chequea cada 30 segundos

// Persiste IDs ya notificados en sessionStorage para sobrevivir re-renders
const getNotified = () => new Set(JSON.parse(sessionStorage.getItem('notified') || '[]'))
const saveNotified = (set) => sessionStorage.setItem('notified', JSON.stringify([...set]))

export function useNotifications(tasks) {
  const tasksRef = useRef(tasks)

  // Mantiene tasksRef actualizado sin reiniciar el intervalo
  useEffect(() => { tasksRef.current = tasks }, [tasks])

  useEffect(() => {
    if (Notification.permission === 'default') Notification.requestPermission()

    const check = () => {
      if (Notification.permission !== 'granted') return
      const now = new Date()
      const notified = getNotified()

      tasksRef.current.forEach(t => {
        if (!t.reminder_at || notified.has(t.task_id) || t.status === 'completed') return
        const diff = new Date(t.reminder_at) - now
        if (diff <= WINDOW_MS) {  // ya pasó o falta <= 1 min
          new Notification(`🔔 Recordatorio: ${t.task_name}`, {
            body: diff > 0
              ? `En ${Math.ceil(diff / 60000)} min`
              : 'Ahora'
          })
          notified.add(t.task_id)
          saveNotified(notified)
        }
      })
    }

    check()
    const id = setInterval(check, INTERVAL_MS)
    return () => clearInterval(id)
  }, []) // solo monta/desmonta una vez
}
