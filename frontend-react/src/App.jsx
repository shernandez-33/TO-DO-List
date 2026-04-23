import React, { useState, useEffect } from 'react'
import { api } from './api'
import TaskList from './components/TaskList'
import TaskForm from './components/TaskForm'
import UserSelector from './components/UserSelector'
import { useNotifications } from './useNotifications'
import './index.css'

export default function App() {
  const [tasks, setTasks] = useState([])
  const [users, setUsers] = useState([])
  const [currentUser, setCurrentUser] = useState(null)
  const [editingTask, setEditingTask] = useState(null)

  useEffect(() => {
    api.getUsers().then(data => {
      setUsers(data)
      if (data.length > 0) setCurrentUser(data[0])
    })
  }, [])

  useEffect(() => {
    if (currentUser) api.getTasks(currentUser.id).then(setTasks)
  }, [currentUser])

  const refresh = () => api.getTasks(currentUser?.id).then(setTasks)

  useNotifications(tasks)

  const handleSave = async (data) => {
    if (editingTask) {
      await api.updateTask(editingTask.task_id, data)
    } else {
      await api.createTask({ ...data, user_id: currentUser.id })
    }
    setEditingTask(null)
    refresh()
  }

  const handleDelete = async (id) => {
    await api.deleteTask(id)
    refresh()
  }

  const handleComplete = async (task) => {
    await api.updateTask(task.task_id, { status: 'completed' })
    refresh()
  }

  return (
    <div className="app">
      <h1>📝 Todo List</h1>
      <UserSelector users={users} current={currentUser} onChange={setCurrentUser} onAdd={async (name) => {
        await api.createUser({ username: name })
        api.getUsers().then(data => { setUsers(data); setCurrentUser(data.find(u => u.username === name)) })
      }} />
      {currentUser && (
        <>
          <TaskForm task={editingTask} onSave={handleSave} onCancel={() => setEditingTask(null)} />
          <TaskList tasks={tasks} onEdit={setEditingTask} onDelete={handleDelete} onComplete={handleComplete} />
        </>
      )}
    </div>
  )
}
