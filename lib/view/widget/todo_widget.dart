// import 'package:flutter/material.dart';
// import '../../model/todo.dart';

// class CreateTodoWidget extends StatefulWidget {
//   const CreateTodoWidget({super.key, this.todo, required this.onSubmit});
//   final ToDo? todo;
//   final ValueChanged<String> onSubmit;
//   @override
//   State<CreateTodoWidget> createState() => _CreateTodoWidgetState();
// }

// class _CreateTodoWidgetState extends State<CreateTodoWidget> {
//   final controller = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Correct key type

//   @override
//   void initState() {
//     super.initState();
//     controller.text = widget.todo?.title ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.todo != null;
//     return AlertDialog(
//       title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
//       content: Form(
//         key: formKey, // Assign the form key here
//         child: TextFormField(
//           controller: controller, // Bind the controller
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Title is required';
//             }
//             return null;
//           },
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             // Validate the form
//             if (formKey.currentState!.validate()) {
//               widget.onSubmit(controller.text);
//               Navigator.pop(context);
//             }
//           },
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/todo.dart';

class CreateTodoWidget extends StatefulWidget {
  const CreateTodoWidget({super.key, this.todo, required this.onSubmit});
  final ToDo? todo;
  final ValueChanged<String> onSubmit;

  @override
  State<CreateTodoWidget> createState() => _CreateTodoWidgetState();
}

class _CreateTodoWidgetState extends State<CreateTodoWidget> {
  final controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) controller.text = widget.todo?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return CupertinoAlertDialog(
      title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
      content: Column(
        children: [
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: controller,
            placeholder: 'Enter title',
            clearButtonMode: OverlayVisibilityMode.editing,
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            // Validate the input
            if (controller.text.isEmpty) {
              // Show error dialog if validation fails
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please enter a valid title.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context); // Close error dialog
                      },
                    )
                  ],
                ),
              );
            } else {
              // Submit if validation passes
              widget.onSubmit(controller.text);
              Navigator.pop(context); // Close the main dialog after submission
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
