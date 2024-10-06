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
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.todo != null) controller.text = widget.todo?.title ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.todo != null;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white, // Arka plan rengi beyaz
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16.0), // Sol üst köşeyi yuvarla
//           topRight: Radius.circular(16.0), // Sağ üst köşeyi yuvarla
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3), // Hafif siyah gölge
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: Offset(0, 3), // Gölgenin konumu
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             isEditing ? 'Edit Todo' : 'Add Todo',
//             style:
//                 const TextStyle(color: Colors.black), // Başlık için siyah renk
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: controller,
//             maxLines: 4, //field text show line
//             decoration: const InputDecoration(
//               labelText: 'Enter title',
//               labelStyle:
//                   TextStyle(color: Colors.black), // Etiket için siyah renk
//               border: OutlineInputBorder(),
//               focusedBorder: OutlineInputBorder(
//                 borderSide:
//                     BorderSide(color: Colors.black), // Seçili border siyah
//               ),
//             ),
//             style: const TextStyle(
//                 color: Colors.black), // Giriş metni için siyah renk
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.white,
//                 ),
//                 onPressed: () {
//                   // Validate the input
//                   if (controller.text.isEmpty) {
//                     // Show error dialog if validation fails
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Please enter a valid title.'),
//                         actions: [
//                           TextButton(
//                             child: const Text('OK'),
//                             onPressed: () {
//                               Navigator.pop(context); // Close error dialog
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     // Submit if validation passes
//                     widget.onSubmit(controller.text);
//                     Navigator.pop(
//                         context); // Close the bottom sheet after submission
//                   }
//                 },
//                 child: const Text('Submit'), //send button
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
