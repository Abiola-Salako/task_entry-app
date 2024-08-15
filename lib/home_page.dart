import 'package:flutter/material.dart';
import 'package:task_entry/task.dart';

class TaskEntryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Entry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskHomePage(),
    );
  }
}

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> with TaskNotifier {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  Priority _selectedPriority = Priority.Low;
  final List<Task> _tasks = [];

  void _addTask() {
    if (_titleController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _tasks.add(
          Task(
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _selectedDate!,
            priority: _selectedPriority,
          ),
        );
        _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = null;
        _selectedPriority = Priority.Low;
      });
    }
  }

  void _completeTask(int index) {
    setState(() {
      _tasks[index].isCompleted = true;
      logCompletion(_tasks[index]);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Entry App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<Priority>(
              value: _selectedPriority,
              onChanged: (Priority? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
              items: Priority.values.map<DropdownMenuItem<Priority>>((Priority value) {
                return DropdownMenuItem<Priority>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _tasks[index].title,
                      style: TextStyle(
                        decoration: _tasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(_tasks[index].description),
                    trailing: IconButton(
                      icon: Icon(
                        _tasks[index].isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      onPressed: () => _completeTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
     ),
);
}
}
