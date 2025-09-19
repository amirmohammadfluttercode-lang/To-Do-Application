import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/Model/task_model.dart';
import 'package:todoapp/Pages/home_page.dart';
import 'package:todoapp/Themes/my_theme.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>("todo_box");
  var settingBox = await Hive.openBox("settings");
  runApp(MyApp(settingBox: settingBox));
}

class MyApp extends StatefulWidget {
  final Box? settingBox;
  const MyApp({super.key, this.settingBox});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeMode themeMode = ThemeMode.light; //default ThemeMode
  late Box settings;

  @override
  void initState() {
    super.initState();
    settings = widget.settingBox ?? Hive.box("settings");
    bool isdark = settings.get("isDarkMode", defaultValue: false);
    themeMode = isdark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) {
    setState(() {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    settings.put("isDarkMode", isDark);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkThem,
      debugShowCheckedModeBanner: false,
      title: "To-Do-Application",
      home: HomePage(
        isdarkMode: themeMode == ThemeMode.dark,
        ontoggleTheme: toggleTheme,
      ),
    );
  }
}
