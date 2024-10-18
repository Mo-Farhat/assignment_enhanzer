import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../view_models/task_view_model.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late TaskViewModel _taskViewModel;

  @override
  void initState() {
    super.initState();
    _taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    _taskViewModel.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
        ),
        body: Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
      return ListView.builder(
          itemCount: taskViewModel.tasks.length,
          itemBuilder: (context, index) {
            final task = taskViewModel.tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(task.description),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showTaskDialog(task);
                  } else if (value == 'delete') {
                    _confirmDeleteTask(task.id!);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'edit', 'delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice == 'edit' ? 'Edit' : 'Delete'),
                    );
                  }).toList();
                },
              ),
              onTap: () {
                _taskViewModel.toggleTaskCompletion(task);
              },
            );
          },
      );
        },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showTaskDialog([Task? task]) {
    final titleController = TextEditingController(text: task?.title);
    final descriptionController = TextEditingController(text: task?.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Task Title'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Task Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  if (task == null) {
                    _taskViewModel.addTask(Task(title: title, description: description));
                  } else {
                    task.title = title;
                    task.description = description;
                    _taskViewModel.updateTask(task);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(task == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteTask(int taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _taskViewModel.deleteTask(taskId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}