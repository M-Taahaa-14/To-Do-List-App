import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'TaskMate',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to TaskMate',
              style: GoogleFonts.poppins(
                  fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ToDoListScreen()),
                );
              },
              child: const Text('Go to To-Do List'),
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final List<Map<String, dynamic>> _toDoItems = [];
  final TextEditingController _controller = TextEditingController();

  void _addToDoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _toDoItems.add({'task': task, 'completed': false});
      });
      _controller.clear();
    }
  }

  void _removeToDoItem(int index) {
    setState(() {
      _toDoItems.removeAt(index);
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _toDoItems[index]['completed'] = !_toDoItems[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                    ),
                    onSubmitted: (value) => _addToDoItem(value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addToDoItem(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _toDoItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_toDoItems[index]['task']),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeToDoItem(index);
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: _toDoItems[index]['completed'],
                      onChanged: (value) {
                        _toggleComplete(index);
                      },
                    ),
                    title: Text(
                      _toDoItems[index]['task'],
                      style: TextStyle(
                        decoration: _toDoItems[index]['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
