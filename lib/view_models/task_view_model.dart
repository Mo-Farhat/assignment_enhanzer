import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_reposoitory.dart';

class TaskViewModel with ChangeNotifier {
  List<Task> _tasks = [];
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _taskRepository.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.addTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    await fetchTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted; // Toggle completion status
    await _taskRepository.updateTask(task); // Update the task in the repository
    notifyListeners(); // Notify listeners to update the UI
  }
}