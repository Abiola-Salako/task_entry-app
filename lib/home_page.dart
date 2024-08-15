import 'package:flutter/material.dart';
import 'package:task_entry/task.dart';

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
  bool _selectionMode = false;

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

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _deleteSelectedTasks() {
    setState(() {
      _tasks.removeWhere((task) => task.isSelected);
      _selectionMode = false;
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

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
    });
  }

  void _selectTask(int index) {
    setState(() {
      _tasks[index].isSelected = !_tasks[index].isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Entry App'),
        actions: [
          if (_selectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedTasks,
            ),
          IconButton(
            icon: Icon(_selectionMode ? Icons.close : Icons.select_all),
            onPressed: _toggleSelectionMode,
          ),
        ],
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _selectTask(index),
                    child: Dismissible(
                      key: Key(_tasks[index].title),
                      onDismissed: (direction) {
                        _deleteTask(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(
                          _tasks[index].title,
                          style: TextStyle(
                            decoration: _tasks[index].isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(_tasks[index].description),
                        trailing: _selectionMode
                            ? Checkbox(
                                value: _tasks[index].isSelected,
                                onChanged: (bool? value) {
                                  _selectTask(index);
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  _tasks[index].isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                ),
                                onPressed: () => _completeTask(index),
                              ),
                      ),
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