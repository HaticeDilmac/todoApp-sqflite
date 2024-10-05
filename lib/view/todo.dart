import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/database/todo_db.dart';

import '../model/todo.dart';
import 'widget/todo_widget.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  Future<List<ToDo>>? futureTodos;
  final todoDB = TodoDB();

// initState içinde futureTodos'ı başlat
  @override
  void initState() {
    super.initState();
    fetchTodos(); // Sayfa yüklendiğinde verileri al
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); //today format
    String today = DateFormat('MMMM d, yyyy').format(now);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(today),
                    Text(
                      'Today',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => CreateTodoWidget(
                        onSubmit: (title) async {
                          await todoDB.create(title: title);
                          if (!mounted) return;
                          fetchTodos();
                        },
                      ),
                    );

                    // showDialog(
                    //   context: context,
                    //   builder: (_) => CreateTodoWidget(
                    //     onSubmit: (title) async {
                    //       await todoDB.create(title: title);
                    //       if (!mounted) return;
                    //       fetchTodos();
                    //     },
                    //   ),
                    // );
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        '+ Add Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ToDo>>(
              future: futureTodos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching todos'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No todos...'),
                  );
                } else {
                  final todos = snapshot.data!;
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      final subTitle = DateFormat('yyyy/MM/dd').format(
                        DateTime.parse(todo.updatedTime ?? todo.createdTime),
                      );
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Text(subTitle),
                        trailing: IconButton(
                            onPressed: () async {
                              await todoDB.delete(todo.id);
                              fetchTodos();
                            },
                            icon: Icon(Icons.delete)),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CreateTodoWidget(
                              todo:
                                  todo, // Burada ilgili todo nesnesini geçiriyoruz
                              onSubmit: (title) async {
                                await todoDB.update(id: todo.id, title: title);
                                fetchTodos();
                                if (!mounted) return;
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
