import 'package:flutter/material.dart';
/**
 manage list of tasks with CRUD firebase

UI: 
	text input for task names
	add buttons 
	single list view of tasks
		each should have checkmark to mark as complete, delete to remove task, and nested list for sublist w additional tasks [daily+hourly tasks combined] 
			ex. Monday list = 9-10AM details for that timeframe, Monday again with 12PM-2PM w another list of tasks(?)

statefulwidget [tasklistscreen] = main screen
	inside: list of tasks [obj w name, completion status, firebase-related info] as instance vars
	methods to add/complete/remove tasks within tasklistscreen idget [incl firebase] 

firebase--ensure tasks add/complete/remove IRT
	authentication to secure app and identify users

login and logout for users(?)


 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _addTask() {
    setState(() {
      print("ADDED");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              _nameController.text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            ElevatedButton(
              onPressed: () { _addTask(); },
              child: Text("Add Task"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
