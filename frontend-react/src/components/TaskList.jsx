import React from 'react'
import { toDisplayText, toDisplayDate } from '../dateUtils'

const priorityLabel = { low: '🟢 Baja', medium: '🟡 Media', high: '🔴 Alta' }

export default function TaskList({ tasks, onEdit, onDelete, onComplete }) {
  if (!tasks.length) return <p className="empty">Lista vacía</p>

  return (
    <ul className="task-list">
      {tasks.map(t => (
        <li key={t.task_id} className={`task-item ${t.status}`}>
          <div className="task-info">
            <span className="task-name">{t.task_name}</span>
            <span className="task-meta">{priorityLabel[t.priority]} · {t.status === 'completed' ? '✅ Completada' : '⏳ Pendiente'}</span>
            {t.due_date && <span className="task-meta">📅 {toDisplayDate(t.due_date)}</span>}
            {t.reminder_at && <span className="task-meta">🔔 {toDisplayText(t.reminder_at)}</span>}
          </div>
          <div className="task-actions">
            {t.status !== 'completed' && <button onClick={() => onComplete(t)}>✔</button>}
            <button onClick={() => onEdit(t)}>✏️</button>
            <button onClick={() => { if (confirm('¿Eliminar tarea?')) onDelete(t.task_id) }}>🗑️</button>
          </div>
        </li>
      ))}
    </ul>
  )
}
