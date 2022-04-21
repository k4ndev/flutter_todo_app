import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_stroage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.length > 3) {
                    widget.task.name = value;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(DateFormat('HH:mm:ss').format(widget.task.date),
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ),
    );
  }
}
