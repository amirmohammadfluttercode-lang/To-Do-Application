import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/Constant/my_string.dart';
import 'package:todoapp/Model/task_model.dart';

class AddOrEditePage extends StatefulWidget {
  final bool isdarkMode;
  final TaskModel task;
  const AddOrEditePage({
    super.key,
    required this.isdarkMode,
    required this.task,
  });

  @override
  State<AddOrEditePage> createState() => _AddOrEditePageState();
}

class _AddOrEditePageState extends State<AddOrEditePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final Box<TaskModel> box = Hive.box("todo_box");

  @override
  void initState() {
    if (widget.task.isInBox) {
      titleController.text = widget.task.title;
      contentController.text = widget.task.details;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.task.isInBox
            ? Text(MyString.titleAddorEdit2)
            : Text(MyString.titleAddorEdit1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(
                color: widget.isdarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isdarkMode
                        ? Color(0xFF3A3B6B)
                        : Colors.black54,
                  ),
                ),
                hintText: MyString.hintTitle,
                hintStyle: TextStyle(
                  color: widget.isdarkMode ? Colors.white : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: contentController,
              style: TextStyle(
                color: widget.isdarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isdarkMode
                        ? Color(0xFF3A3B6B)
                        : Colors.black54,
                  ),
                ),
                hintText: MyString.hintContent,
                hintStyle: TextStyle(
                  color: widget.isdarkMode ? Colors.white : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (widget.task.isInBox) {
                  Navigator.pop(context);
                  widget.task.title = titleController.text;
                  widget.task.details = contentController.text;
                  widget.task.save();
                } else {
                  Navigator.pop(context);
                  widget.task.title = titleController.text;
                  widget.task.details = contentController.text;
                  box.add(widget.task);
                }
              },
              child: widget.task.isInBox
                  ? Text(
                      MyString.btnEdit,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      MyString.btnAdd,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
