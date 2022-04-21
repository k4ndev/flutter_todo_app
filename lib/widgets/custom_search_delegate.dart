import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_stroage.dart';
import 'package:todo_app/main.dart';

import '../models/task_model.dart';
import 'task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
        size: 20,
      ),
      onTap: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredTask = allTask
        .where((task) => task.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredTask.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var task = filteredTask[index];
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
                onDismissed: (direction) async{
                  filteredTask.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: task);
                  
                },
                child: TaskItem(task: task),
              );
            },
            itemCount: allTask.length,
          )
        : Center(child: Text('not_found').tr());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
