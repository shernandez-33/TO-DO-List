import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  List<User> users = [];
  User? currentUser;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await api.getUsers();
    setState(() {
      users = data;
      if (data.isNotEmpty) currentUser = data.first;
    });
    if (currentUser != null) _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (currentUser == null) return;
    final data = await api.getTasks(currentUser!.id);
    setState(() => tasks = data);
  }

  Future<void> _deleteTask(int id) async {
    await api.deleteTask(id);
    _loadTasks();
  }

  Future<void> _completeTask(Task t) async {
    await api.updateTask(t.taskId, {'status': 'completed'});
    _loadTasks();
  }

  void _openForm([Task? task]) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (_) => TaskFormScreen(api: api, userId: currentUser!.id, task: task),
    ));
    _loadTasks();
  }

  void _addUser() async {
    final ctrl = TextEditingController();
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Nuevo usuario'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Username')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(onPressed: () async {
          if (ctrl.text.trim().isNotEmpty) {
            final u = await api.createUser(ctrl.text.trim());
            setState(() { users.add(u); currentUser = u; });
            _loadTasks();
          }
          if (mounted) Navigator.pop(context);
        }, child: const Text('Crear')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Todo List'),
        actions: [
          if (users.isNotEmpty)
            DropdownButton<int>(
              value: currentUser?.id,
              underline: const SizedBox(),
              items: users.map((u) => DropdownMenuItem(value: u.id, child: Text(u.username))).toList(),
              onChanged: (id) {
                setState(() => currentUser = users.firstWhere((u) => u.id == id));
                _loadTasks();
              },
            ),
          IconButton(icon: const Icon(Icons.person_add), onPressed: _addUser),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Lista vacía'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final t = tasks[i];
                return ListTile(
                  leading: Icon(
                    t.status == 'completed' ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: t.status == 'completed' ? Colors.green : Colors.grey,
                  ),
                  title: Text(t.taskName, style: TextStyle(
                    decoration: t.status == 'completed' ? TextDecoration.lineThrough : null,
                  )),
                  subtitle: Text('${_priorityLabel(t.priority)}${t.dueDate != null ? ' · 📅 ${t.dueDate}' : ''}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (t.status != 'completed')
                      IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => _completeTask(t)),
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _openForm(t)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                      final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                        content: const Text('¿Eliminar tarea?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                        ],
                      ));
                      if (ok == true) _deleteTask(t.taskId);
                    }),
                  ]),
                );
              },
            ),
      floatingActionButton: currentUser != null
          ? FloatingActionButton(onPressed: () => _openForm(), child: const Icon(Icons.add))
          : null,
    );
  }

  String _priorityLabel(String p) => {'low': '🟢 Baja', 'medium': '🟡 Media', 'high': '🔴 Alta'}[p] ?? p;
}
