import 'dart:math';

import 'package:dartnative/dartnative.dart';
import 'package:example/sticky-note/todo_screen.dart';

class CreateNotePanel extends StatefulWidget {
  final VoidCallback onClose;

  final void Function({
    required String title,
    required String description,
    required Color color,
  })
  onCreate;

  const CreateNotePanel({
    required this.onClose,
    required this.onCreate,
  });

  @override
  State<CreateNotePanel> createState() => _CreateNotePanelState();
}

class _CreateNotePanelState extends State<CreateNotePanel> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Color selectedColor = NoteColors.all[Random().nextInt(NoteColors.all.length)];

  @override
  void didUpdateWidget(covariant CreateNotePanel oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

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
                child: Text(
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
            autofocus: false,
            key: Key('title_input'),
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: Color(0xFF292524),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            // onChanged: (value) => print('title: $value'),
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
            // onChanged: (value) => print('descriptio: $value'),
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
              Expanded(
                child: Row(
                  children: [
                    ...NoteColors.all.map(
                      (color) {
                        return GestureDetector(
                          onTap: () {
                            selectedColor = color;
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 7),
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == color
                                    ? const Color(0xFF292524)
                                    : const Color(0x22000000),
                                width: selectedColor == color ? 2 : 1,
                              ),
                            ),
                            child: selectedColor == color
                                ? Center(
                                    child: const Icon(
                                      CupertinoIcons.checkmark,
                                      size: 16,
                                      color: Color(0xFF292524),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
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
                  if (titleController.text.trim().isEmpty) {
                    return;
                  }

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
