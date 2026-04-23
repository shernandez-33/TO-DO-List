import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

const String baseUrl = 'http://192.168.100.231:8000';

class ApiService {
  Future<List<User>> getUsers() async {
    final r = await http.get(Uri.parse('$baseUrl/users'));
    return (jsonDecode(r.body) as List).map((e) => User.fromJson(e)).toList();
  }

  Future<User> createUser(String username) async {
    final r = await http.post(Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}));
    return User.fromJson(jsonDecode(r.body));
  }

  Future<List<Task>> getTasks(int userId) async {
    final r = await http.get(Uri.parse('$baseUrl/tasks?user_id=$userId'));
    return (jsonDecode(r.body) as List).map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> createTask(Map<String, dynamic> data) async {
    final r = await http.post(Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));
    return Task.fromJson(jsonDecode(r.body));
  }

  Future<Task> updateTask(int id, Map<String, dynamic> data) async {
    final r = await http.put(Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));
    return Task.fromJson(jsonDecode(r.body));
  }

  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$baseUrl/tasks/$id'));
  }
}
