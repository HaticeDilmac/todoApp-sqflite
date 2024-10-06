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
  final todoDB = TodoDB(); //todoDB access

  @override
  void initState() {
    super.initState();
    fetchTodos(); //get function apicall function
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll(); //todoDB task list access
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String today = DateFormat('MMMM d, yyyy').format(now);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          // title
          titleMethod(today, context),
          // list widget
          Expanded(
            child: FutureBuilder<List<ToDo>>(
              future: futureTodos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //loading  state
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error fetching todos')); //erorr state
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //if todos list is null
                  return const Center(child: Text('No todos...'));
                } else {
                  final todos = snapshot.data!;
                  return Stack(
                    //todos list isNotEmpty
                    children: [
                      ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          final subTitle = DateFormat('MMMM d, yyyy').format(
                            DateTime.parse(
                                (todo.updatedTime ?? todo.createdTime)),
                          );
                          final date = DateFormat('HH:mm').format(
                            DateTime.parse(
                                (todo.updatedTime ?? todo.createdTime)),
                          );
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //color circle widget
                              Container(
                                  height: 80,
                                  width: 80,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.amber, width: 3),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(child: Text(date))),
                              taskCardWidget(todo, subTitle, context),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded taskCardWidget(ToDo todo, String subTitle, BuildContext context) {
    return Expanded(
      //task card widget
      child: Container(
        margin: const EdgeInsets.only(
          right: 20,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 180, 4),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                subtitle: Text(subTitle,
                    style: const TextStyle(color: Colors.black54)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateTodoWidget(
                      todo: todo,
                      onSubmit: (title) async {
                        await todoDB.update(id: todo.id, title: title);
                        fetchTodos();
                      },
                    ),
                  );
                },
              ),
            ),
            deleteAlertMethod(context, todo),
          ],
        ),
      ),
    );
  }

  Container titleMethod(String today, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
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
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => CreateTodoWidget(
                  onSubmit: (title) async {
                    await todoDB.create(title: title);
                    fetchTodos();
                  },
                ),
              );
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '+ Add Task',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconButton deleteAlertMethod(BuildContext context, ToDo todo) {
    return IconButton(
      icon: const Icon(Icons.add_task, color: Colors.black),
      onPressed: () async {
        bool? shouldDelete = await showCupertinoDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Are you sure you want to delete?'),
              actions: [
                CupertinoDialogAction(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );

        if (shouldDelete == true) {
          await todoDB.delete(todo.id);
          fetchTodos();
        }
      },
    );
  }
}
