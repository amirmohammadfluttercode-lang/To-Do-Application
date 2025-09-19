import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/Constant/my_color.dart';
import 'package:todoapp/Constant/my_string.dart';
import 'package:todoapp/Model/task_model.dart';
import 'package:todoapp/Pages/add_or_edite_page.dart';

class HomePage extends StatefulWidget {
  final bool isdarkMode;
  final Function(bool) ontoggleTheme;
  final Box<TaskModel> box = Hive.box("todo_box");
  HomePage({super.key, required this.isdarkMode, required this.ontoggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.titleMain),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Icon(Icons.light_mode, size: 20, color: Colors.white),
                Switch(
                  value: widget.isdarkMode,
                  onChanged: widget.ontoggleTheme,
                ),
                const Icon(Icons.dark_mode, size: 20, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ValueListenableBuilder(
          valueListenable: widget.box.listenable(),
          builder: (context, todoBox, child) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: todoBox.values.toList().length,
              itemBuilder: (context, index) {
                final taskmodel = todoBox.values.toList()[index];
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.isdarkMode
                        ? Color(0xFF3A3B6B)
                        : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isdarkMode
                            ? Colors.transparent
                            : Colors.black.withAlpha(50),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                taskmodel.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.isdarkMode
                                      ? Colors.white
                                      : MyColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                taskmodel.details,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.isdarkMode
                                      ? Colors.white
                                      : MyColor.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AddOrEditePage(
                                  isdarkMode: widget.isdarkMode,
                                  task: taskmodel,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                          color: MyColor.iconcolor,
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("DELETE TASK"),
                                  content: Text(
                                    "Are You Want To Delete This Task?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("NO"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        taskmodel.delete();
                                        Navigator.pop(context);
                                      },
                                      child: Text("YES"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
                          color: MyColor.iconcolor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddOrEditePage(
                isdarkMode: widget.isdarkMode,
                task: TaskModel(title: "Title", details: "Content"),
              ),
            ),
          );
        },
        child: Icon(CupertinoIcons.add, color: Colors.white),
      ),
    );
  }
}
