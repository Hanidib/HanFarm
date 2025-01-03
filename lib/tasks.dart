import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseURL = 'hanfarm111.atwebpages.com';

// Task Data Model
class Task {
  final int id;
  final int userId;
  final String taskName;
  final String description;
  final String dueDate;

  Task({
    required this.id,
    required this.userId,
    required this.taskName,
    required this.description,
    required this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json['id']),
      userId: int.parse(json['user_id']),
      taskName: json['task_name'],
      description: json['description'],
      dueDate: json['due_date'],
    );
  }
}

List<Task> tasks = [];
List<Task> filteredTasks = [];  // To store filtered tasks for search

// Fetch all tasks
Future<void> fetchTasks(Function(bool) update) async {
  try {
    final url = Uri.http(baseURL, 'task.php', {'status': 'all'});
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as List;
      tasks = jsonResponse.map((json) => Task.fromJson(json)).toList();
      filteredTasks = List.from(tasks);  // Set filtered tasks to all tasks initially
      update(true);
    } else {
      update(false);
    }
  } catch (e) {
    update(false);
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks((success) {
      setState(() => isLoading = !success);
    });
  }

  void deleteTask(int id) async {
    try {
      final url = Uri.http(baseURL, 'task.php', {'status': 'delete', 'id': '$id'});
      final response = await http.post(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        fetchTasks((success) => setState(() => isLoading = !success));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully!')),
        );
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting task')),
      );
    }
  }

  void searchTasks(String query) {
    setState(() {
      filteredTasks = tasks
          .where((task) => task.taskName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Management')),
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: searchTasks,
              decoration: const InputDecoration(
                labelText: 'Search by Task Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                ? const Center(child: Text('No tasks found'))
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(task.taskName),
                    subtitle: Text('Due Date: ${task.dueDate}\nDescription: ${task.description}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateTaskScreen(task: task),
                              ),
                            );
                            fetchTasks((success) => setState(() => isLoading = !success));
                          },
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(task.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          fetchTasks((success) => setState(() => isLoading = !success));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  Future<void> addTask() async {
    try {
      final url = Uri.http(baseURL, 'task.php', {'status': 'new'});
      final response = await http.post(
        url,
        body: {
          'user_id': _userIdController.text,
          'task_name': _taskNameController.text,
          'description': _descriptionController.text,
          'due_date': _dueDateController.text,
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
      } else {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter user ID' : null,
              ),
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter task name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: 'Due Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value == null || value.isEmpty ? 'Please enter due date' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addTask();
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateTaskScreen extends StatefulWidget {
  final Task task;

  const UpdateTaskScreen({super.key, required this.task});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _taskNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: widget.task.userId.toString());
    _taskNameController = TextEditingController(text: widget.task.taskName);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDateController = TextEditingController(text: widget.task.dueDate);
  }

  Future<void> updateTask() async {
    try {
      final url = Uri.http(baseURL, 'task.php', {
        'status': 'update',
        'id': '${widget.task.id}',  // Task ID for update
      });

      final response = await http.post(
        url,
        body: {
          'user_id': _userIdController.text,
          'task_name': _taskNameController.text,
          'description': _descriptionController.text,
          'due_date': _dueDateController.text,
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully!')),
        );
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter user ID' : null,
              ),
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter task name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: 'Due Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value == null || value.isEmpty ? 'Please enter due date' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateTask();
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
