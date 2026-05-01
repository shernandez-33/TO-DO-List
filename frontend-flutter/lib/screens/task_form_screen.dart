import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../utils/date_utils.dart';

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
    if (!_formKey.currentState!.validate()) {
      print('Validación del formulario falló');
      return;
    }
    
    print('Iniciando guardado de tarea...');
    
    try {
      final data = {
        'task_name': _nameCtrl.text.trim(),
        'priority': _priority,
        'status': _status,
        if (_dueDate != null) 'due_date': _dueDate!.toIso8601String().split('T').first,
        if (_reminderAt != null) 'reminder_at': _reminderAt!.toIso8601String(),
      };
      
      print('Datos a enviar: $data');
      
      late Task saved;
      if (widget.task != null) {
        print('Actualizando tarea existente: ${widget.task!.taskId}');
        saved = await widget.api.updateTask(widget.task!.taskId, data);
        await cancelReminder(widget.task!.taskId);
      } else {
        print('Creando nueva tarea');
        saved = await widget.api.createTask({...data, 'user_id': widget.userId});
      }
      
      print('Tarea guardada: ${saved.taskId}');
      
      if (_reminderAt != null) {
        print('Programando recordatorio para: $_reminderAt');
        try {
          await scheduleReminder(saved.taskId, saved.taskName, _reminderAt!);
          print('Recordatorio programado exitosamente');
        } catch (e) {
          print('Error al programar recordatorio: $e');
          // Continuar aunque falle la programación del recordatorio
        }
      }
    } catch (e) {
      print('Error general al guardar tarea: $e');
    } finally {
      print('Intentando cerrar pantalla...');
      if (mounted) {
        Navigator.pop(context);
        print('Pantalla cerrada exitosamente');
      } else {
        print('Widget no montado, no se puede cerrar');
      }
    }
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
              initialValue: _priority,
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
              initialValue: _status,
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
              title: Text(_dueDate != null ? '📅 Fecha límite: ${formatDueDate(_dueDate!.toIso8601String().split('T').first)}' : '📅 Sin fecha límite'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final currentContext = context;
                final date = await showDatePicker(
                  context: currentContext,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _dueDate = date);
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_reminderAt != null ? '🔔 Recordatorio: ${formatReminder(_reminderAt!.toIso8601String())}' : '🔔 Sin recordatorio'),
              trailing: const Icon(Icons.alarm),
              onTap: () async {
                final currentContext = context;
                final date = await showDatePicker(
                  context: currentContext,
                  initialDate: _reminderAt ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (date == null) return;
                final time = await showTimePicker(
                  context: currentContext,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.dial,
                );
                if (time != null) {
                  setState(() {
                    _reminderAt = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
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
