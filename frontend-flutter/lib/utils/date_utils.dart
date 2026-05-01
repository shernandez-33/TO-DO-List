import 'package:intl/intl.dart';

String formatReminder(String reminderAt) {
  try {
    final date = DateTime.parse(reminderAt);
    return DateFormat('dd/MM/yyyy hh:mm a').format(date);
  } catch (e) {
    return reminderAt;
  }
}

String formatDueDate(String dueDate) {
  try {
    final date = DateTime.parse(dueDate);
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (e) {
    return dueDate;
  }
}

String getStatusLabel(String status) {
  return status == 'completed' ? '✅ Completada' : '⏳ Pendiente';
}

String getPriorityLabel(String priority) {
  return switch (priority) {
    'low' => '🟢 Baja',
    'medium' => '🟡 Media',
    'high' => '🔴 Alta',
    _ => priority,
  };
}
