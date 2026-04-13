import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskFormScreen extends StatefulWidget {
  final ApiService api;
  final int userId;
  final Task? task;

  const TaskFormScreen({super.key, required this.api, required this.userId, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  String _priority = 'medium';
  String _status = 'pending';
  DateTime? _dueDate;
  DateTime? _reminderAt;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _nameCtrl = TextEditingController(text: t?.taskName ?? '');
    _priority = t?.priority ?? 'medium';
    _status = t?.status ?? 'pending';
    _dueDate = t?.dueDate != null ? DateTime.tryParse(t!.dueDate!) : null;
    _reminderAt = t?.reminderAt != null ? DateTime.tryParse(t!.reminderAt!) : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'task_name': _nameCtrl.text.trim(),
      'priority': _priority,
      'status': _status,
      if (_dueDate != null) 'due_date': _dueDate!.toIso8601String().split('T').first,
      if (_reminderAt != null) 'reminder_at': _reminderAt!.toIso8601String(),
    };
    if (widget.task != null) {
      await widget.api.updateTask(widget.task!.taskId, data);
    } else {
      await widget.api.createTask({...data, 'user_id': widget.userId});
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task != null ? 'Editar tarea' : 'Nueva tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre de la tarea'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('🟢 Baja')),
                DropdownMenuItem(value: 'medium', child: Text('🟡 Media')),
                DropdownMenuItem(value: 'high', child: Text('🔴 Alta')),
              ],
              onChanged: (v) => setState(() => _priority = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('⏳ Pendiente')),
                DropdownMenuItem(value: 'completed', child: Text('✅ Completada')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_dueDate != null ? '📅 Fecha límite: ${_dueDate!.toIso8601String().split('T').first}' : '📅 Sin fecha límite'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _dueDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                if (d != null) setState(() => _dueDate = d);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_reminderAt != null ? '🔔 Recordatorio: ${_reminderAt!.toLocal()}' : '🔔 Sin recordatorio'),
              trailing: const Icon(Icons.alarm),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _reminderAt ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                if (d == null) return;
                final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (t != null) setState(() => _reminderAt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: Text(widget.task != null ? 'Actualizar' : 'Crear tarea')),
          ]),
        ),
      ),
    );
  }
}
