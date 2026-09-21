import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

// ---------------------------------------------------------------------------
// Note Colors
// ---------------------------------------------------------------------------

class NoteColors {
  static const yellow = Color(0xFFFFF3A3);
  static const pink = Color(0xFFFFC9D6);
  static const blue = Color(0xFFBFE3FF);
  static const green = Color(0xFFC8F7C5);
  static const purple = Color(0xFFE0C7FF);
  static const orange = Color(0xFFFFD6A5);

  static const all = [yellow, pink, blue, green, purple, orange];
}

// ---------------------------------------------------------------------------
// Todo Model
// ---------------------------------------------------------------------------

class Todo {
  final int id;
  final String title;
  final String description;
  final Color color;
  final bool completed;
  final bool pinned;
  final double rotation;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    this.completed = false,
    this.pinned = false,
    this.rotation = 0,
  });

  Todo copyWith({
    String? title,
    String? description,
    Color? color,
    bool? completed,
    bool? pinned,
    double? rotation,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      completed: completed ?? this.completed,
      pinned: pinned ?? this.pinned,
      rotation: rotation ?? this.rotation,
    );
  }
}

// ---------------------------------------------------------------------------
// Todo Notifier
// ---------------------------------------------------------------------------

class TodoNotifier extends Notifier<List<Todo>> {
  TodoNotifier();

  @override
  List<Todo> build() => const [];

  void addTodo({
    required String title,
    required String description,
    required Color color,
  }) {
    if (title.trim().isEmpty) return;

    final id = DateTime.now().microsecondsSinceEpoch;

    // Give each note a slightly different rotation.
    const rotations = [-0.025, 0.018, -0.012, 0.028, -0.018, 0.012];

    final rotation = rotations[state.length % rotations.length];

    state = [
      ...state,
      Todo(
        id: id,
        title: title.trim(),
        description: description.trim(),
        color: color,
        rotation: rotation,
      ),
    ];
  }

  void toggleTodo(int id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
  }

  void togglePin(int id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(pinned: !todo.pinned) else todo,
    ];
  }

  void deleteTodo(int id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

final todoProvider = NotifierProvider<TodoNotifier, List<Todo>>(
  () => TodoNotifier(),
);

// ---------------------------------------------------------------------------
// Layout Mode
// ---------------------------------------------------------------------------

enum TodoLayout { sticky, cards }

// ---------------------------------------------------------------------------
// Home Screen
// ---------------------------------------------------------------------------

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  TodoLayout layout = TodoLayout.sticky;
  bool isCreating = false;
  DNSheetController? sheet;

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);
    final notifier = ref.read(todoProvider.notifier);

    final sortedTodos = [
      ...todos.where((todo) => todo.pinned),
      ...todos.where((todo) => !todo.pinned),
    ];

    void showCreateNote(BuildContext context) {
      sheet = showBottomSheet(
        context,
        detents: const [DNSheetDetent.medium, DNSheetDetent.large],
        initialDetent: DNSheetDetent.medium,
        showGrabber: true,
        builder: (ctx, controller) => _CreateNotePanel(
          onClose: () {
            controller.dismiss();
          },
          onCreate:
              ({
                required String title,
                required String description,
                required Color color,
              }) {
                print("Add todo ${title} ${description} ${color}");
                notifier.addTodo(
                  title: title,
                  description: description,
                  color: color,
                );

                controller.dismiss();
              },
        ),
        onDetentChanged: (detent) => print('settled at ${detent.label}'),
        onDismissed: () => print('sheet closed'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F2),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF292524),
        titleGlassBackground: true,
        title: const Text(
          'My Notes',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        actions: [
          BarButtonItem(
            fontIcon: CupertinoIcons.rectangle_stack,
            titleStyle: TextStyle(color: Colors.white, fontSize: 16),
            onPressed: () {
              layout = (layout == TodoLayout.sticky
                  ? TodoLayout.cards
                  : TodoLayout.sticky);
              setState(() {});
            },
          ),
          BarButtonItem(
            fontIcon: CupertinoIcons.plus,
            titleStyle: TextStyle(color: Colors.white, fontSize: 16),
            onPressed: () {
              showCreateNote(context);
              // setState(() {});
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          // ---------------------------------------------------------------
          // Notes
          // ---------------------------------------------------------------
          Positioned.fill(
            child: sortedTodos.isEmpty
                ? const _EmptyState()
                : layout == TodoLayout.sticky
                ? _StickyGrid(
                    todos: sortedTodos,
                    onToggle: notifier.toggleTodo,
                    onPin: notifier.togglePin,
                    onDelete: notifier.deleteTodo,
                  )
                : _CardList(
                    todos: sortedTodos,
                    onToggle: notifier.toggleTodo,
                    onPin: notifier.togglePin,
                    onDelete: notifier.deleteTodo,
                  ),
          ),

          // ---------------------------------------------------------------
          // Floating composer
          // ---------------------------------------------------------------
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky Grid
// ---------------------------------------------------------------------------

class _StickyGrid extends StatelessWidget {
  final List<Todo> todos;
  final void Function(int id) onToggle;
  final void Function(int id) onPin;
  final void Function(int id) onDelete;

  const _StickyGrid({
    required this.todos,
    required this.onToggle,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 18,
        childAspectRatio: 0.88,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return Transform.rotate(
          angle: todo.rotation,
          child: _StickyNote(
            todo: todo,
            onToggle: () => onToggle(todo.id),
            onPin: () => onPin(todo.id),
            onDelete: () => onDelete(todo.id),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky Note
// ---------------------------------------------------------------------------

class _StickyNote extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const _StickyNote({
    required this.todo,
    required this.onToggle,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: todo.color,
        borderRadius: BorderRadius.circular(3),

        // Fake paper shadow.
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 7,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pin
          Row(
            children: [
              Icon(
                todo.pinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                size: 18,
                color: const Color(0xFF57534E),
              ),

              const Spacer(),

              Button(
                title: '×',
                onPressed: onDelete,
                color: const Color(0x00000000),
                foregroundColor: const Color(0xFF57534E),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            todo.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: todo.completed
                  ? const Color(0xFF78716C)
                  : const Color(0xFF292524),
              fontSize: 17,
              fontWeight: FontWeight.bold,
              decoration: todo.completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Expanded(
            child: Text(
              todo.description.isEmpty ? 'No description' : todo.description,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF57534E),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Complete
          Button(
            title: todo.completed ? '✓ Done' : 'Mark done',
            onPressed: onToggle,
            color: const Color(0x33000000),
            foregroundColor: const Color(0xFF292524),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card Layout
// ---------------------------------------------------------------------------

class _CardList extends StatelessWidget {
  final List<Todo> todos;
  final void Function(int id) onToggle;
  final void Function(int id) onPin;
  final void Function(int id) onDelete;

  const _CardList({
    required this.todos,
    required this.onToggle,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7E5E4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Complete
              GestureDetector(
                onTap: () => onToggle(todo.id),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: todo.completed
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFF5F5F4),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: todo.completed
                      ? const Icon(
                          CupertinoIcons.checkmark,
                          size: 16,
                          color: Color(0xFFFFFFFF),
                        )
                      : null,
                ),
              ),

              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        color: todo.completed
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF1C1917),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    if (todo.description.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        todo.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF78716C),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Pin
              Button(
                title: todo.pinned ? '📌' : '○',
                onPressed: () => onPin(todo.id),
                color: const Color(0x00000000),
                foregroundColor: const Color(0xFF57534E),
              ),

              // Delete
              Button(
                title: '×',
                onPressed: () => onDelete(todo.id),
                color: const Color(0x00000000),
                foregroundColor: const Color(0xFFDC2626),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Empty State
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.square_stack_3d_up,
            size: 64,
            color: Color(0xFFA8A29E),
          ),
          SizedBox(height: 18),
          Text(
            'Your board is empty',
            style: TextStyle(
              color: Color(0xFF292524),
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to create your first note.',
            style: TextStyle(color: Color(0xFF78716C), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _CreateNotePanel extends StatefulWidget {
  final VoidCallback onClose;

  final void Function({
    required String title,
    required String description,
    required Color color,
  })
  onCreate;

  const _CreateNotePanel({
    required this.onClose,
    required this.onCreate,
  });

  @override
  State<_CreateNotePanel> createState() => _CreateNotePanelState();
}

class _CreateNotePanelState extends State<_CreateNotePanel> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Color selectedColor = NoteColors.yellow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E5E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------------
          // Header
          // ---------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const Text(
                  'New note',
                  style: TextStyle(
                    color: Color(0xFF292524),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(
                  CupertinoIcons.xmark,
                  size: 15,
                  color: Color(0xFF57534E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------------------------------------------------------------
          // Title
          // ---------------------------------------------------------------
          TextField(
            controller: titleController,
            autofocus: true,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: Color(0xFF292524),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Note title',
              hintStyle: const TextStyle(color: Color(0xFFA8A29E)),
              filled: true,
              fillColor: const Color(0xFFF7F7F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ---------------------------------------------------------------
          // Description
          // ---------------------------------------------------------------
          TextField(
            controller: descriptionController,
            maxLines: 3,
            style: const TextStyle(color: Color(0xFF44403C), fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Add a description...',
              hintStyle: const TextStyle(color: Color(0xFFA8A29E)),
              filled: true,
              fillColor: const Color(0xFFF7F7F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ---------------------------------------------------------------
          // Bottom controls
          // ---------------------------------------------------------------
          Row(
            children: [
              // Colors
              // Expanded(
              //   child: Row(
              //     children: [
              //       for (final color in NoteColors.all)
              //         GestureDetector(
              //           onTap: () {
              //             setState(() {
              //               selectedColor = color;
              //             });
              //           },
              //           child: Container(
              //             margin: const EdgeInsets.only(right: 7),
              //             width: 27,
              //             height: 27,
              //             decoration: BoxDecoration(
              //               color: color,
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: selectedColor == color
              //                     ? const Color(0xFF292524)
              //                     : const Color(0x22000000),
              //                 width: selectedColor == color ? 2 : 1,
              //               ),
              //             ),
              //             child: selectedColor == color
              //                 ? const Icon(
              //                     CupertinoIcons.checkmark,
              //                     size: 13,
              //                     color: Color(0xFF292524),
              //                   )
              //                 : null,
              //           ),
              //         ),
              //     ],
              //   ),
              // ),
              const SizedBox(width: 8),

              // Create
              Button(
                title: 'Create',
                color: const Color(0xFF292524),
                foregroundColor: const Color(0xFFFFFFFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                onPressed: () {
                  // if (titleController.text.trim().isEmpty) {
                  //   return;
                  // }

                  widget.onCreate(
                    title: titleController.text,
                    description: descriptionController.text,
                    color: selectedColor,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

class CreateNoteBottomsheet extends StatelessWidget {
  const CreateNoteBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Create Note 22334'),
      ),
    );
  }
}
