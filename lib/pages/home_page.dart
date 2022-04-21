import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_stroage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';

import '../helper/translation_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTask = <Task>[];
    _getAllTaskState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskButton(context);
          },
          child: Text(
            'title',
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
            color: Colors.blue,
          ),
          IconButton(
            onPressed: () {
              _showAddTaskButton(context);
            },
            icon: const Icon(Icons.add),
            color: Colors.blue.shade600,
          )
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var task = _allTask[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("remove_task").tr()
                    ],
                  ),
                  key: Key(task.id),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    _localStorage.deleteTask(task: task);
                    setState(() {});
                  },
                  child: TaskItem(task: task),
                );
              },
              itemCount: _allTask.length,
            )
          :  Center(child: Text('empty_taks_list').tr()),
    );
  }

  void _showAddTaskButton(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListTile(
              title: TextField(
                autofocus: true,
                decoration:  InputDecoration(
                    hintText: "add_task".tr(), border: InputBorder.none),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(context, locale: TranslationsHelper.getDeviceLanguage(context), showSecondsColumn: false,
                        onConfirm: (time) async {
                      var newTask = Task.create(name: value, date: time);
                      _allTask.insert(0, newTask);
                      await _localStorage.addTask(task: newTask);
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          );
        });
  }

  Future<void> _getAllTaskState() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTask));
    _getAllTaskState();
  }
}
