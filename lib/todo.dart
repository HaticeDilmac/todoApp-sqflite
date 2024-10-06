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

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              onSubmit: (title) async {
                await todoDB.create(
                  title: title,
                );
                if (!mounted) return;
                fetchTodos();
              },
            ),
          );
        },
      ),
      body: FutureBuilder<List<ToDo>>(
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
                final hour = DateFormat('hh:mm').format(
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
                    showDialog(
                      context: context,
                      builder: (context) => CreateTodoWidget(
                        todo: todo, // Burada ilgili todo nesnesini geçiriyoruz
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
    );
  }
}
