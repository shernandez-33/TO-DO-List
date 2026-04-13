import React, { useState } from 'react'

export default function UserSelector({ users, current, onChange, onAdd }) {
  const [newName, setNewName] = useState('')

  return (
    <div className="user-selector">
      <select value={current?.id || ''} onChange={e => onChange(users.find(u => u.id === Number(e.target.value)))}>
        {users.map(u => <option key={u.id} value={u.id}>{u.username}</option>)}
      </select>
      <input placeholder="Nuevo usuario" value={newName} onChange={e => setNewName(e.target.value)} />
      <button onClick={() => { if (newName.trim()) { onAdd(newName.trim()); setNewName('') } }}>Agregar usuario</button>
    </div>
  )
}
