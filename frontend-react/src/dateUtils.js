// Convierte un ISO string del backend a formato para <input type="datetime-local">
// Entrada: "2026-04-25T20:03:00-04:00" → Salida: "2026-04-25T20:03"
export const toInputValue = (iso) => {
  if (!iso) return ''
  const d = new Date(iso)
  const pad = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`
}

// Convierte el valor de <input type="datetime-local"> a ISO 8601 con offset local
// Entrada: "2026-04-25T20:03" → Salida: "2026-04-25T20:03:00-04:00"
export const toISOWithOffset = (inputValue) => {
  if (!inputValue) return null
  const d = new Date(inputValue)
  const off = -d.getTimezoneOffset()
  const sign = off >= 0 ? '+' : '-'
  const pad = (n) => String(Math.abs(n)).padStart(2, '0')
  return `${inputValue}:00${sign}${pad(Math.floor(Math.abs(off)/60))}:${pad(Math.abs(off)%60)}`
}

// Convierte un ISO string a texto legible para mostrar en la UI
export const toDisplayText = (iso) => {
  if (!iso) return ''
  return new Date(iso).toLocaleString('es-ES', {
    day: '2-digit', month: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit', hour12: true
  })
}

// Convierte "YYYY-MM-DD" a "DD/MM/YYYY"
export const toDisplayDate = (date) => {
  if (!date) return ''
  const [y, m, d] = date.split('-')
  return `${d}/${m}/${y}`
}

// Convierte el valor de <input type="datetime-local"> a Date para comparaciones
export const toDate = (inputValue) => inputValue ? new Date(inputValue) : null
