import React, { useState, useEffect } from 'react'
import { toInputValue, toISOWithOffset } from '../dateUtils'

const empty = { task_name: '', priority: 'medium', status: 'pending', due_date: '', reminder_at: '' }

export default function TaskForm({ task, onSave, onCancel }) {
  const [form, setForm] = useState(empty)

  useEffect(() => {
    setForm(task ? {
      task_name: task.task_name,
      priority: task.priority,
      status: task.status,
      due_date: task.due_date || '',
      reminder_at: toInputValue(task.reminder_at)
    } : empty)
  }, [task])

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }))

  const submit = (e) => {
    e.preventDefault()
    if (!form.task_name.trim()) return
    const data = { ...form }
    if (!data.due_date) delete data.due_date
    if (data.reminder_at) {
      data.reminder_at = toISOWithOffset(data.reminder_at)
    } else {
      delete data.reminder_at
    }
    onSave(data)
    setForm(empty)
  }

  return (
    <form className="task-form" onSubmit={submit}>
      <input placeholder="Nombre de la tarea" value={form.task_name} onChange={e => set('task_name', e.target.value)} required />
      <select value={form.priority} onChange={e => set('priority', e.target.value)}>
        <option value="low">Baja</option>
        <option value="medium">Media</option>
        <option value="high">Alta</option>
      </select>
      <select value={form.status} onChange={e => set('status', e.target.value)}>
        <option value="pending">Pendiente</option>
        <option value="completed">Completada</option>
      </select>
      <input type="date" value={form.due_date} onChange={e => set('due_date', e.target.value)} />
      <input type="datetime-local" value={form.reminder_at} onChange={e => set('reminder_at', e.target.value)} placeholder="Recordatorio" />
      <button type="submit">{task ? 'Actualizar' : 'Agregar'}</button>
      {task && <button type="button" onClick={onCancel}>Cancelar</button>}
    </form>
  )
}
