// import 'package:dartnative/dartnative.dart';
// import 'package:example/todo_screen.dart';

// class StickyNote extends StatefulWidget {
//   final Todo todo;

//   final VoidCallback onToggle;

//   final VoidCallback onPin;

//   final VoidCallback onDelete;

//   const StickyNote({
//     required this.todo,
//     required this.onToggle,
//     required this.onPin,
//     required this.onDelete,
//   });

//   @override
//   State<StickyNote> createState() => StickyNoteState();
// }

// class StickyNoteState extends State<StickyNote> {
//   @override
//   void didUpdateWidget(covariant StickyNote oldWidget) {
//     print("didUpdateWidget 1");
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.amber,
//         borderRadius: BorderRadius.circular(20),
//         // Fake paper shadow.
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x22000000),
//             blurRadius: 20,
//             offset: Offset(2, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Pin
//           Row(
//             children: [
//               Icon(
//                 widget.todo.pinned
//                     ? CupertinoIcons.pin_fill
//                     : CupertinoIcons.pin,
//                 size: 18,
//                 color: const Color(0xFF57534E),
//               ),

//               const Spacer(),

//               Button(
//                 child: Icon(CupertinoIcons.xmark, size: 20),
//                 onPressed: widget.onDelete,
//                 variant: ButtonVariant.plain,
//                 foregroundColor: const Color(0xFF57534E),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // Title
//           Text(
//             widget.todo.title,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: widget.todo.completed
//                   ? const Color(0xFF78716C)
//                   : const Color(0xFF292524),
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//               decoration: widget.todo.completed
//                   ? TextDecoration.lineThrough
//                   : TextDecoration.none,
//             ),
//           ),

//           const SizedBox(height: 8),

//           // Description
//           Expanded(
//             child: Text(
//               widget.todo.description.isEmpty
//                   ? 'No description'
//                   : widget.todo.description,
//               maxLines: 5,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Color(0xFF57534E),
//                 fontSize: 13,
//                 height: 1.35,
//               ),
//             ),
//           ),

//           const SizedBox(height: 8),

//           // Complete
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Button(
//                 title: widget.todo.completed ? '✓ Done' : 'Mark done',
//                 onPressed: widget.onToggle,
//                 color: const Color(0x33000000),
//                 foregroundColor: const Color(0xFF292524),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
